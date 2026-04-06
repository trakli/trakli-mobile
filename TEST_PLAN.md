# 📊 Test Plan for Trakli (Offline-First Finance App)

## 🧩 Overview
This PR introduces a **structured and comprehensive test plan** for the Trakli application, an offline-first personal finance tracker built with Flutter and Drift.

The objective is to ensure:
- Accurate financial computations
- Reliable offline data persistence
- Robust CRUD operations
- Stable and predictable user experience
- Reliable data synchronization with backend services

---

## 🎯 Objectives

| Goal | Description |
|-----|------------|
| Data Integrity | Ensure all data is stored and retrieved correctly using Drift |
| Financial Accuracy | Validate wallet balance calculations for all transactions |
| Offline Reliability | Guarantee persistence across app restarts and crashes |
| Sync Consistency | Ensure local and remote data remain consistent |
| UX Quality | Ensure proper validation and responsive UI behavior |

---

## 🧪 Scope of Testing

### ✅ In Scope

| Area | Coverage |
|-----|--------|
| Authentication | Registration, Login, Profile |
| Groups | Create, update, delete, list |
| Categories | Income & Expense categories |
| Parties | Entities involved in transactions |
| Wallets | Cash, bank accounts, balances |
| Transactions | Income & Expense entries |
| Persistence | Drift DB reliability |
| Sync Engine | Local ↔ Server synchronization |

### ❌ Out of Scope

| Area | Reason |
|-----|-------|
| Payment Gateways | Not part of current scope |
| Bank APIs | No external integrations |

---

## 🧠 Test Strategy

### Test Levels

| Level | Focus | Tools |
|------|------|------|
| Unit | Business logic, calculations | `flutter_test` |
| Database | Drift queries, migrations | In-memory DB |
| Widget | UI & validation | `flutter_test` |
| Integration | End-to-end flows | `integration_test` |

---

## 🔥 Critical Test Flows

| Flow ID | Scenario | Expected Outcome |
|--------|---------|----------------|
| FLOW-01 | Create Wallet → Add Income | Balance increases correctly |
| FLOW-02 | Add Expense → Restart App | Data persists after restart |
| FLOW-03 | Delete Category | Transactions handled correctly |
| FLOW-04 | Add Attachment | File path saved & retrievable |
| FLOW-05 | Offline Transaction → Sync | Data pushed to server when online |
| FLOW-06 | Server Update → Sync | Local DB updates with remote changes |
| FLOW-07 | Conflict Resolution | Latest or correct version retained |

---

## 🔄 Synchronization Test Scenarios

| ID | Scenario | Expected Result |
|----|--------|----------------|
| SYNC-01 | Create data offline → go online | Data syncs to server automatically |
| SYNC-02 | Update record locally | Server reflects updated values |
| SYNC-03 | Delete record locally | Server record removed or flagged |
| SYNC-04 | Remote changes | Local DB updates after sync |
| SYNC-05 | Conflict (same record edited locally & remotely) | Conflict resolved based on defined strategy |
| SYNC-06 | Network failure during sync | Retry mechanism triggers |
| SYNC-07 | Partial sync failure | Successful items persist, failed items retried |

---

## 🧾 Core Test Scenarios

### Authentication

| ID | Scenario | Expected Result |
|----|--------|----------------|
| AUTH-01 | Register user | Account created locally |
| AUTH-02 | Login user | Session persists |
| AUTH-03 | Update profile | UI reflects changes instantly |

---

### Entity Management

| ID | Scenario | Expected Result |
|----|--------|----------------|
| CRUD-01 | Create entity | Appears in list |
| CRUD-02 | Update entity | Changes persist |
| CRUD-03 | Delete entity | Removed safely |
| CRUD-04 | Duplicate entry | Error shown |

---

### Transactions & Financial Accuracy

| ID | Scenario | Expected Result |
|----|--------|----------------|
| TRX-01 | Record income | Wallet balance increases |
| TRX-02 | Record expense | Wallet balance decreases |
| TRX-03 | Multiple transactions | Balance remains consistent |
| TRX-04 | Missing fields | Validation error triggered |

---

## ⚠️ Risks & Mitigations

| Risk | Impact | Mitigation |
|-----|-------|-----------|
| DB corruption | Data loss | Use Drift transactions |
| Large data | UI lag | Pagination / lazy loading |
| File path loss | Broken attachments | Dynamic path resolution |
| Sync conflicts | Data inconsistency | Implement conflict resolution strategy |
| Network failure | Sync interruption | Retry & queue mechanism |

---

## 🧪 Example Test Coverage (Included in this PR)

| Test Type | Description |
|----------|------------|
| Unit Test | Wallet balance calculation |
| Database Test | Insert & fetch wallet (Drift in-memory) |
| Widget Test | Form validation |
| Integration Test | Add expense updates wallet balance |
| Sync Test | Offline → Online data synchronization |

---

## 🧪 Sample Test Implementations

### 1. Unit Test (Balance Calculation)

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('expense decreases balance correctly', () {
    final result = calculateBalance(
      initialBalance: 100,
      income: 0,
      expense: 40,
    );

    expect(result, 60);
  });
}
```

---

## ✅ PR Checklist

| Item | Status |
|-----|--------|
| Test plan added | ✅ |
| Covers offline-first scenarios | ✅ |
| Sync scenarios included | ✅ |
| Financial accuracy validated | ✅ |
| Edge cases included | ✅ |
| Unit tests added | ⏳ |
| Integration tests added | ⏳ |

---

## 📌 Why This Matters
Trakli is a **financial system**, not just a CRUD app.  
This test plan ensures correctness, reliability, synchronization, and trust in all financial operations.

---

## 🚀 Next Steps

| Task | Priority |
|-----|---------|
| Expand automated test coverage | High |
| Add CI pipeline (GitHub Actions) | Medium |
| Increase test coverage % | High |
| Implement robust sync retry logic | High |

---

**Status:** Ready for Review  
**Date:** 2026-04-06  
