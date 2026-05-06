# Spreadsheet import + fix-failed flow

> **Status:** preserved on this branch (`archive/import-fix-failed-flow`).
> The active branch may delete this code in favor of the analyzer-only path
> (`/import/analyze` → review → `/import/confirm`) once that flow is
> validated for CSV/XLSX. This doc captures the design memory so the code
> can be restored or referenced later.

---

## Why this flow exists

Two ways to get transactions into a user's account:

| Path | Endpoint | Behavior |
| - | - | - |
| **Spreadsheet** (this doc) | `POST /api/v1/import` then `PUT /api/v1/imports/{id}/fix` | Rule-based parse, immediate transactions on success, leftovers go to a `failed_imports` table the user fixes and retries. |
| **Document scan** | `POST /api/v1/import/analyze` then `POST /api/v1/import/confirm` | AI extraction → user reviews suggestions → confirm creates transactions. |

The spreadsheet path is **commit-then-cleanup**: by the time the user lands
on the detail screen, valid rows are already real transactions; only the
broken ones are outstanding.

## Server contract

### Upload

`POST /api/v1/import` with multipart `file`. Backend dispatches
`ImportFileJob` which calls `FileImportService::processImports`. Each row
becomes either a `transaction` (success) or a `failed_imports` row with a
`reason` string (failed). Counters on `file_imports` track running totals.

### Fetch failed rows

`GET /api/v1/imports/{id}/failed` returns paginated `FailedImport[]`:

```
{ id, file_import_id, amount, currency, type, party, wallet, category,
  description, date, reason }
```

### Retry

`PUT /api/v1/imports/{id}/fix` — synchronous, processes each row and
deletes the corresponding `failed_imports` row on success.

**Original wire format** (raw array body):

```json
[
  { "id": 12, "amount": "5.00", "type": "expense", "wallet": "Cash", ... }
]
```

**Mobile-side migration we coordinated** (mirroring `/import/confirm`):

```json
{
  "rows": [
    { "id": 12, "amount": "5.00", "type": "expense",
      "wallet_id": 7, "party_id": 3, "category_id": 11 }
  ],
  "auto_create_wallets": false,
  "auto_create_parties": false,
  "auto_create_categories": false
}
```

The mobile DTO already sends this shape (see `failed_import_dto.dart` on
this branch). The server-side switch to this contract was **not yet
shipped at the time the flow was archived** — restoring requires both
the mobile code AND the server-side `FixFailedImportsRequest`,
`ImportController::fixFailedImports`, and
`FileImportService::importTransaction` updates described below.

## Reasons emitted by the server

From `FileImportService::processImports` and `importTransfer`. Six
distinct strings — five specific, one catch-all:

| Reason string | Implicated field(s) | Source |
| - | - | - |
| `Date must be in the format YYYY-MM-DD` | date | `processImports` |
| `Invalid transaction type` | type | `processImports` |
| `Corresponding -Transfer transaction not found` | type / row pairing | `processImports` |
| `no wallets found` | wallet (+ currency) | `importTransfer` |
| `Cannot compute transfer with zero send amount` | amount | `importTransfer` |
| `An error occurred while importing this transaction` | unknown — catch-all | `processImports` |

The catch-all dominates in practice because `importTransaction` (the
non-transfer path) **never throws a specific `FileImportException`**.
Most concrete failures (currency missing, FK violations, etc.) collapse
to the opaque sixth string. To enable better field-level UX, the server
needs to throw `FileImportException` with structured codes from inside
`importTransaction`.

## Mobile UX

### Failed-rows screen (`lib/presentation/imports/failed_imports_screen.dart`)

- **Collapsible cards** — each failed row is a header-only card; tap to
  expand the editable form. Mirrors the suggestion-review pattern.
- **Header** — error avatar (red), primary text (party → description →
  fallback), amount, reason text in red as the meta line.
- **Expanded form** — amount, type (DropdownButtonFormField for align),
  description, **wallet/party/category pickers** via
  `CustomAutoCompleteSearch`, and a tap-to-pick date field.
- **Auto-match by name** — when wallets/parties/categories load, names
  on each row are matched to existing entities and the IDs prefilled
  silently. Mirrors `_maybeAutoMatch` in suggestion review.
- **Inline errors** — `_fieldsForReason(reason)` maps each known reason
  to a `FailedField` enum; the matching field renders `errorText` with
  the reason. Catch-all rows show a banner above the form instead.
- **Confirm sheet** — bottom sheet asks the user about
  `auto_create_wallets/parties/categories` flags before retry. Disabled
  switches when no rows are missing the corresponding entity.

### Reason → field map

```dart
enum FailedField { amount, type, wallet, date }

Set<FailedField> _fieldsForReason(String? reason) {
  if (reason == null || reason.isEmpty) return const {};
  final r = reason.toLowerCase();
  if (r.contains('date must be')) return const {FailedField.date};
  if (r.contains('invalid transaction type')) return const {FailedField.type};
  if (r.contains('-transfer transaction not found')) return const {FailedField.type};
  if (r.contains('no wallets found')) return const {FailedField.wallet};
  if (r.contains('zero send amount')) return const {FailedField.amount};
  return const {};
}
```

Substring match (lowercased) so minor punctuation tweaks don't break
the mapping. Empty result = catch-all → top banner instead of inline
error.

### Detail screen (`lib/presentation/imports/import_detail_screen.dart`)

- Gradient hero header with file name, status pill, and total-rows pill.
- Animated processing banner while non-terminal.
- Progress card with segmented bar (success / failed / pending) and
  legend dots.
- Stat tiles for success and failed counts.
- Metadata card with imported / last-update dates.
- Bottom-bar "Fix failed rows" button that only renders when
  `failedCount > 0`.

### Spreadsheet upload screen (`lib/presentation/imports/spreadsheet_import_screen.dart`)

- Single primary CTA via `ImportSourceButton(isPrimary: true)`.
- File picker accepts `csv`, `xlsx`, `xls`.
- On success, replaces the screen with `ImportDetailScreen(importId)`
  which polls the import until terminal.

## State plumbing (snapshot)

```
ImportRepository
  uploadImport(File) → FileImportEntity
  getImports() → List<FileImportEntity>
  getFailedImports(importId) → List<FailedImportEntity>
  fixFailedImports(importId, rows, {autoCreate*}) → FixFailedImportsResult

FileImportEntity { id, name, filePath, fileType, status, totalRows,
  successCount, failedCount, createdAt, updatedAt }
  + isTerminal getter (status in [completed, failed, partial])

FailedImportEntity { id, fileImportId, amount, currency, type, party,
  wallet, category, description, date, reason,
  walletId?, partyId?, categoryId? }
  + withWalletId/withPartyId/withCategoryId helpers
  + copyWith preserves the IDs

ImportCubit
  loadImports() / loadFailedImports(importId) / uploadImport(file)
  fixFailedImports(importId, rows, {autoCreate*}) — emits state.failedImports
    = result.stillFailed so the screen re-renders survivors
  startPollingImport(importId) — every 3s, replaces state.imports list,
    stops when matching import is terminal

DTO layer
  FailedImportDto { ...all fields, includeIfNull: false on toJson }
  FileImportDto / DTO ↔ Entity conversion in fromEntity/toEntity
```

## Why we may delete this

The backend team indicated `/import/analyze` now handles spreadsheets too.
Consolidating to a single review-then-confirm pipeline eliminates:

- Two import code paths in mobile and server
- The silent-duplicate bug class (auto-create from typed names without
  user awareness)
- The `failed_imports` table and the entire fix-then-retry UX
- The need for the `wallet_id` / `auto_create_*` migration on `/fix`

The cost is that AI extraction takes longer than rule-based parsing for
large CSVs and runs LLM tokens. If those tradeoffs prove acceptable in
production, the analyzer-only path is the cleaner long-term shape.

## How to restore

This branch (`archive/import-fix-failed-flow`) is the snapshot. To
recover specific files:

```bash
# View a file as it was on the archive branch
git show archive/import-fix-failed-flow:lib/presentation/imports/failed_imports_screen.dart

# Pull a single file back into the active branch
git checkout archive/import-fix-failed-flow -- lib/presentation/imports/failed_imports_screen.dart

# Cherry-pick the import-specific commits
git log archive/import-fix-failed-flow --oneline | grep -i import
```

Files that were specific to this flow (delete candidates if removing
from the active branch):

- `lib/presentation/imports/failed_imports_screen.dart`
- `lib/presentation/imports/import_detail_screen.dart`
- `lib/presentation/imports/spreadsheet_import_screen.dart`
- `lib/domain/entities/import/file_import_entity.dart`
- `lib/domain/entities/import/failed_import_entity.dart`
- `lib/data/datasources/import/dto/file_import_dto.{dart,g.dart}`
- `lib/data/datasources/import/dto/failed_import_dto.{dart,g.dart}`
- `lib/domain/usecases/import/get_imports_usecase.dart`
- `lib/domain/usecases/import/get_failed_imports_usecase.dart`
- `lib/domain/usecases/import/fix_failed_imports_usecase.dart`
- `lib/domain/usecases/import/upload_import_usecase.dart`
- The `_SpreadsheetTile` variant in `import_activity_tile.dart`
- The `uploadImport` / `getImports` / `getFailedImports` /
  `fixFailedImports` methods on `ImportRepository`

Files **shared** with the analyzer flow (do NOT delete):

- `lib/presentation/imports/widgets/picker_with_hint.dart`
- `lib/presentation/imports/widgets/suggestion_card.dart`
- `lib/presentation/imports/widgets/import_source_button.dart`
- `lib/presentation/imports/widgets/import_file_picker.dart`
- `lib/presentation/utils/custom_auto_complete_search.dart`
- `lib/domain/entities/import/import_session_entity.dart`
- `lib/domain/entities/import/import_session_status.dart`
- `lib/data/datasources/import/dto/import_session_dto.{dart,g.dart}`
- `lib/data/datasources/import/dto/transaction_suggestion_dto.{dart,g.dart}`
- `lib/data/datasources/import/dto/confirm_accepted_item_dto.{dart,g.dart}`
- The analyzer / confirm-related cubit methods
- The localized stage labels and analysis-failed strings

## Outstanding server work (only relevant if restored)

If `/imports/{id}/fix` is brought back, the server still owes us:

1. Accept the new request body shape (`{rows, auto_create_*}`) instead
   of a raw array.
2. Read `wallet_id` / `party_id` / `category_id` from each row and prefer
   them over name strings (mirroring `importTransactionFromConfirm`'s
   resolve helpers).
3. Drop the hardcoded `autoCreate*: true` and use the request flags.
4. Increment `success_count` / decrement `failed_count` on
   `$fileImport` after the failed_imports row is deleted, so detail-
   screen stats stop drifting.
5. (Stretch) Throw `FileImportException` with structured codes from
   inside `importTransaction` — closes the gap that today collapses
   most concrete failures into the catch-all reason. Mobile already has
   `_fieldsForReason` ready to consume codes once they exist.
