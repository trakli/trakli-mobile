# Bloc/Cubit Patterns Reference Guide

A comprehensive guide to the state management patterns used in the Trakli mobile application.

---

## Table of Contents

1. [Cubit Architecture Overview](#cubit-architecture-overview)
2. [Examined Cubits Analysis](#examined-cubits-analysis)
3. [State Pattern Documentation](#state-pattern-documentation)
4. [Invocation Patterns](#invocation-patterns)
5. [Error Handling](#error-handling)
6. [Best Practices Guide](#best-practices-guide)
7. [Common Patterns & Anti-Patterns](#common-patterns--anti-patterns)

---

## Cubit Architecture Overview

This codebase uses **flutter_bloc** with the **Cubit** pattern (simplified BLoC without events). Cubits are used for state management across presentation layers, with injectable dependency injection and freezed for immutable state objects.

### Key Technologies
- **flutter_bloc**: State management library
- **freezed**: Immutable data structures and code generation
- **injectable**: Dependency injection
- **Either<Failure, T>**: Functional error handling (from dartz pattern)

---

## Examined Cubits Analysis

### 1. BudgetCubit

**Location**: `lib/presentation/budget/cubit/budget_cubit.dart`

#### State Pattern

```dart
BudgetState(
  List<BudgetEntity> budgets,
  bool isLoading,
  bool isSaving,
  bool isDeleting,
  bool isProgressLoading,
  bool isPeriodTransactionsLoading,
  bool isClosingPeriod,
  BudgetProgressEntity? selectedBudgetProgress,
  BudgetTransactionsResponse? selectedBudgetTransactions,
  List<BudgetTargetEntity> selectedBudgetTargets,
  List<BudgetPeriodStateEntity> selectedBudgetPeriodStates,
  Failure failure,
)
```

#### State Emission Flow

| Operation | State Sequence |
|-----------|-----------------|
| **Load Budgets** | Initial → `isLoading: true` → `isLoading: false, budgets: [...]` or `isLoading: false, failure: ...` |
| **Listen to Budgets** | Continuous stream → emit `budgets: [...]` on each server update |
| **Add/Update Budget** | Initial → `isSaving: true` → `isSaving: false` (success/failure) |
| **Delete Budget** | Initial → `isDeleting: true` → optimistic emit (remove from list) → `isDeleting: false` |
| **Watch Budget Details** | Starts two simultaneous streams: targets & period states |
| **Fetch Progress** | Initial → `isProgressLoading: true` → `isProgressLoading: false, selectedBudgetProgress: ...` |
| **Close Period** | Initial → `isClosingPeriod: true` → calls refresh → `isClosingPeriod: false` |

#### Key Methods

```dart
// Initialization (called in constructor)
listenToBudgets() 
  - Subscribes to continuous server updates
  - Auto-updates budget list when changes occur

// Data Loading
loadBudgets(active?) 
  - One-time fetch with isLoading flag

// CRUD Operations
addBudget(...)           // await required
updateBudget(...)        // await required
deleteBudget(...)        // await required (with optimistic update)

// Detail Screen Operations
watchBudget(clientId)    // Start listening to targets & periods
fetchProgress(serverId)  // await required
fetchPeriodTransactions(serverId, limit)  // await required
closeBudgetPeriod(serverId)  // await required

// Utilities
refreshPeriodStates()    // await required
```

#### Invocation Patterns (from UI)

```dart
// In initState - Setup listeners
final cubit = context.read<BudgetCubit>();
cubit.watchBudget(widget.budget.clientId);  // Fire-and-forget
if (id != null) {
  cubit.fetchProgress(id);                   // Fire-and-forget
}

// In dialog/form - await for operations
await context.read<BudgetCubit>().deleteBudget(budget.clientId);
await context.read<BudgetCubit>().closeBudgetPeriod(id);

// In BlocBuilder - reactive UI
BlocBuilder<BudgetCubit, BudgetState>(
  builder: (context, state) {
    return Text(state.budgets.length);  // Rebuilds on state change
  }
)

// In RefreshIndicator - combine multiple awaits
return Future.wait([
  context.read<BudgetCubit>().fetchProgress(id),
  context.read<BudgetCubit>().refreshPeriodStates(),
]);
```

---

### 2. CategoryCubit

**Location**: `lib/presentation/category/cubit/category_cubit.dart`

#### State Pattern

```dart
CategoryState(
  List<CategoryEntity> categories,
  bool isLoading,
  bool isSaving,
  bool isDeleting,
  Failure failure,
)
```

#### State Emission Flow

| Operation | State Sequence |
|-----------|-----------------|
| **Load Categories** | Initial → `isLoading: true` → `isLoading: false, categories: [...]` |
| **Listen to Categories** | Continuous stream → emit `categories: [...]` on each update |
| **Add/Update Category** | Initial → `isSaving: true` → `isSaving: false` → calls `loadCategories()` |
| **Delete Category** | Initial → `isDeleting: true` → optimistic emit → `isDeleting: false` |

#### Key Methods

```dart
// Initialization (constructor)
listenToCategories()
  - Subscribes to continuous updates via usecase

// Data Operations
loadCategories()              // await required
addCategory(...)              // await required, followed by loadCategories()
updateCategory(...)           // await required, followed by loadCategories()
deleteCategory(clientId)      // await required
```

#### Distinction from BudgetCubit

- **Simpler state**: Only tracks main list + loading flags
- **No nested data**: No `selectedCategory...` fields
- **Reload pattern**: After add/update, calls `loadCategories()` instead of relying on streams
- **Optimistic delete**: Removes from list immediately before API call

#### Invocation Patterns (from UI)

```dart
// In BlocBuilder - dropdown/list rendering
BlocBuilder<CategoryCubit, CategoryState>(
  builder: (context, state) {
    return ListView(
      children: state.categories.map((cat) => ...),
    );
  }
)

// Form submission - await and reload
final cubit = context.read<CategoryCubit>();
await cubit.addCategory(
  name: name,
  slug: slug,
  type: type,
  description: description,
  media: media,
);
// State will auto-update via loadCategories() call within cubit
```

---

### 3. WalletCubit

**Location**: `lib/presentation/wallets/cubit/wallet_cubit.dart`

#### State Pattern

```dart
WalletState(
  List<WalletEntity> wallets,
  bool isLoading,
  bool isSaving,
  bool isDeleting,
  Failure failure,
  @Default(allWalletsIndex) int currentSelectedWalletIndex,
)
```

#### State Emission Flow

| Operation | State Sequence |
|-----------|-----------------|
| **Load Wallets** | Initial → `isLoading: true` → `isLoading: false, wallets: [...]` |
| **Listen for Changes** | Initial → `isLoading: true` → Continuous stream → `isLoading: false` |
| **Add/Update Wallet** | Initial → `isSaving: true` → `isSaving: false` (no explicit reload) |
| **Delete Wallet** | Initial → `isDeleting: true` → `isDeleting: false` |
| **Select Wallet** | Immediate → `currentSelectedWalletIndex: index` (no side effects) |

#### Key Methods

```dart
// Initialization (constructor)
listenForChanges()
  - Subscribes via usecase, sets isLoading: true initially

// Data Operations
loadWallets()                 // await required
addWallet(...)                // await required
updateWallet(...)             // await required
deleteWallet(clientId)        // await required
ensureDefaultWallet(...)      // await required

// Complex Operations
createAndSaveDefaultWallet(...)  // Complex: creates wallet + saves config

// UI State
setCurrentSelectedWalletIndex(index)  // Synchronous, no await
currentSelectedWallet  // Getter, not a method

// Utilities
get isAllWalletsSelected  // Helper property
get currentSelectedWallet  // Safe getter with bounds checking
```

#### Key Differences

1. **Selection State**: Includes `currentSelectedWalletIndex` for UI state
2. **Helper Properties**: Provides computed getters (`currentSelectedWallet`, `isAllWalletsSelected`)
3. **Config Integration**: Can save configs (e.g., default wallet preference)
4. **No explicit reload pattern**: Relies on stream subscription from constructor

#### Invocation Patterns (from UI)

```dart
// Selecting a wallet - synchronous, fire-and-forget
context.read<WalletCubit>().setCurrentSelectedWalletIndex(index);

// Creating wallet - await operation
await context.read<WalletCubit>().addWallet(
  name: name,
  type: type,
  balance: balance,
  currency: currency,
  description: description,
  icon: icon,
);

// Watching changes
BlocBuilder<WalletCubit, WalletState>(
  builder: (context, state) {
    return state.currentSelectedWallet?.name ?? 'All Wallets';
  }
)
```

---

## State Pattern Documentation

### Common State Structure Pattern

All cubits in this codebase follow a consistent pattern:

```dart
@freezed
class [Entity]State with _$[Entity]State {
  const factory [Entity]State({
    // Main data
    required List<[Entity]Entity> [entities],
    
    // Loading indicators (per operation)
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    
    // Optional: nested/selected data
    [Entity]Entity? selected[Entity],
    List<RelatedEntity>? related[Entities],
    
    // Error handling
    required Failure failure,
    
    // Optional: UI state
    @Default(-1) int selectedIndex,
  }) = _[Entity]State;

  factory [Entity]State.initial() => const [Entity]State(
    [entities]: [],
    isLoading: false,
    isSaving: false,
    isDeleting: false,
    failure: const Failure.none(),
  );
}
```

### State Immutability & Updates

State is **always immutable** and updated via `copyWith()`:

```dart
// ✓ Correct: immutable copyWith
emit(state.copyWith(isLoading: true, failure: const Failure.none()));

// ✓ Correct: reset failure when starting new operation
emit(state.copyWith(
  isSaving: true,
  failure: const Failure.none(),  // Always reset on new operation
));

// ✗ Incorrect: mutating state directly
state.budgets.add(newBudget);  // DON'T DO THIS
```

### Failure Handling Pattern

All operations follow a consistent error pattern:

```dart
result.fold(
  (failure) => emit(state.copyWith(
    isLoading: false,
    failure: failure,  // Store failure in state
  )),
  (data) => emit(state.copyWith(
    isLoading: false,
    data: data,
    failure: const Failure.none(),  // Always clear on success
  )),
);
```

---

## Invocation Patterns

### Pattern 1: Fire-and-Forget (No Await)

**Use when**: You don't need to wait for completion, state emission will trigger rebuilds

```dart
// In initState or event handler
context.read<BudgetCubit>().watchBudget(budgetId);
context.read<BudgetCubit>().fetchProgress(serverId);

// In callbacks
context.read<CategoryCubit>().loadCategories();
```

**State Handling**: UI subscribes via BlocBuilder/BlocListener for async feedback

**Examples in codebase**:
- `BudgetDetailScreen.initState()`: calls `watchBudget()` and `fetchProgress()` without await
- `BudgetScreen`: calls `loadBudgets()` via callback without await

---

### Pattern 2: Await with UI Feedback

**Use when**: Need to confirm completion before navigating or showing feedback

```dart
// In form submission
Future<void> _submit() async {
  final cubit = context.read<BudgetCubit>();
  
  await cubit.addBudget(
    name: name,
    amount: amount,
    // ... other params
  );
  
  // After await completes, state has been emitted
  // BlocListener will handle navigation/snackbar
}
```

**State Handling**: BlocListener with `listenWhen` to detect completion

---

### Pattern 3: Multiple Awaits (Coordinated Ops)

**Use when**: Multiple operations must complete together

```dart
// In RefreshIndicator
return Future.wait([
  context.read<BudgetCubit>().fetchProgress(id),
  context.read<BudgetCubit>().refreshPeriodStates(),
]);
```

**State Handling**: UI waits for all operations, then rebuilds

---

### Pattern 4: Confirmation Dialog → Action → Feedback

**Use when**: Destructive operations need confirmation

```dart
Future<void> _confirmDelete(BudgetEntity budget) async {
  // Step 1: Show dialog (blocks)
  final confirm = await showDeleteConfirmationDialog(context, ...);
  if (!confirm || !mounted) return;
  
  // Step 2: Execute action (don't await - let listener handle feedback)
  context.read<BudgetCubit>().deleteBudget(budget.clientId);
  
  // Step 3: BlocListener will detect completion and show snackbar
}
```

**Key Point**: Action is NOT awaited; BlocListener detects state changes

---

### Pattern 5: Complex Multi-Step Operations

**Use when**: Operation has multiple sub-operations

```dart
Future<void> createAndSaveDefaultWallet(...) async {
  emit(state.copyWith(isSaving: true, failure: const Failure.none()));

  // Step 1: Check if wallet exists
  final existingWallet = state.wallets.firstWhere(...);
  
  if (existingWallet != null) {
    // Step 2a: Save existing wallet as default
    final saveResult = await saveConfigUseCase(...);
    // Handle result...
  } else {
    // Step 2b: Create new wallet
    final result = await addWalletUseCase(...);
    
    // Step 3: Save as default
    final saveWallet = await saveConfigUseCase(...);
    // Handle result...
  }
  
  emit(state.copyWith(isSaving: false, failure: ...));
}
```

---

### BlocBuilder Usage Pattern

**For reactive UI that rebuilds on state changes:**

```dart
BlocBuilder<BudgetCubit, BudgetState>(
  builder: (context, state) {
    // Rebuilds whenever BudgetState changes
    return ListView(
      children: state.budgets.map((b) => BudgetTile(budget: b)).toList(),
    );
  },
)
```

**With listenWhen (render only on specific changes):**

```dart
BlocBuilder<BudgetCubit, BudgetState>(
  buildWhen: (prev, curr) => prev.budgets != curr.budgets,
  builder: (context, state) {
    // Only rebuilds when budgets list changes
    return BudgetList(budgets: state.budgets);
  },
)
```

---

### BlocListener Usage Pattern

**For side effects (navigation, snackbars, dialogs):**

```dart
BlocListener<BudgetCubit, BudgetState>(
  listenWhen: (prev, curr) {
    // Trigger listener only when deletion completes
    return prev.isDeleting && !curr.isDeleting;
  },
  listener: (context, state) {
    // This runs when listenWhen returns true
    if (state.failure != const Failure.none()) {
      showSnackBar(message: 'Delete failed', isSuccess: false);
    } else {
      showSnackBar(message: 'Budget deleted', isSuccess: true);
      AppNavigator.pop(context);
    }
  },
  child: BlocBuilder<BudgetCubit, BudgetState>(
    builder: (context, state) => Scaffold(...),
  ),
)
```

**Key Points**:
- `listenWhen`: Determines when listener runs (reduce unnecessary callbacks)
- `listener`: Side effects (no return value)
- `child`: Usually a BlocBuilder for the actual UI
- BlocListener runs AFTER state change is complete

---

## Error Handling

### Failure Type Hierarchy

```dart
Failure
├── ServerError(message)         // Server returned error
├── NetworkError()               // Network unavailable
├── CacheError(message)          // Local cache error
├── SyncError(message)           // Sync failed
├── ValidationError(message, errors)  // Validation failed
├── UnauthorizedError()          // Auth expired/invalid
├── UnknownError()               // Unexpected error
├── BadRequest(errors?, error?)  // 400 Bad Request
├── NotFound()                   // 404
├── Duplicate(message)           // Resource already exists
├── Cancel()                     // Operation cancelled
└── None()                       // No error (default)
```

### Checking for Errors

```dart
// Check if any error occurred
if (state.failure != const Failure.none()) {
  // Handle error
}

// Use hasError property
if (state.failure.hasError) {
  // Error occurred
}

// Get localized message
showSnackBar(message: state.failure);  // Automatically localizes
```

### Error State Emission Pattern

```dart
// On operation start: reset failure
emit(state.copyWith(
  isLoading: true,
  failure: const Failure.none(),  // Always clear previous errors
));

// On completion: emit appropriate state
result.fold(
  (failure) => emit(state.copyWith(
    isLoading: false,
    failure: failure,  // Emit the failure
  )),
  (data) => emit(state.copyWith(
    isLoading: false,
    data: data,
    failure: const Failure.none(),  // Clear on success
  )),
);
```

### UI Error Handling Pattern

```dart
// In BlocListener - show error feedback
BlocListener<BudgetCubit, BudgetState>(
  listenWhen: (prev, curr) => prev.isDeleting && !curr.isDeleting,
  listener: (context, state) {
    if (state.failure != const Failure.none()) {
      showSnackBar(
        message: state.failure,  // Automatically gets customMessage
        isSuccess: false,
      );
      return;
    }
    
    showSnackBar(
      message: 'Deleted successfully',
      isSuccess: true,
    );
  },
)

// In BlocBuilder - show loading/error states
BlocBuilder<BudgetCubit, BudgetState>(
  builder: (context, state) {
    if (state.isLoading) {
      return const CircularProgressIndicator();
    }
    
    if (state.failure.hasError) {
      return ErrorWidget(message: state.failure.customMessage);
    }
    
    return BudgetList(budgets: state.budgets);
  },
)
```

---

## Best Practices Guide

### 1. When to Use Await vs Fire-and-Forget

| Scenario | Pattern | Example |
|----------|---------|---------|
| Form submission with validation | **Await** | Add budget, need success before close |
| Loading data for display | **Fire-and-forget** | Load categories in background |
| Confirmation dialogs | **Await dialog**, don't await action | Delete budget flow |
| Coordinated operations | **Await Future.wait** | Refresh multiple data sources |
| Navigation-critical operations | **Await** | Save settings, then navigate |
| Background refresh | **Fire-and-forget** | Pull-to-refresh without blocking |

### 2. BlocListener Setup for Side Effects

**Always use BlocListener for:**
- Navigation after async operation
- Showing snackbars/dialogs
- Triggering animations
- Any action with no return value

**Pattern:**

```dart
BlocListener<CubitType, StateType>(
  // 1. Determine when to trigger
  listenWhen: (prev, curr) {
    return prev.isSaving && !curr.isSaving;  // Operation completed
  },
  
  // 2. Handle side effect
  listener: (context, state) {
    if (state.failure.hasError) {
      showSnackBar(message: state.failure);
      return;
    }
    
    showSnackBar(message: 'Success!', isSuccess: true);
    AppNavigator.pop(context);
  },
  
  // 3. Wrap the UI
  child: BlocBuilder<CubitType, StateType>(
    builder: (context, state) => Scaffold(...),
  ),
)
```

### 3. BlocBuilder Setup for Reactive UI

**Use BlocBuilder for:**
- Rendering lists that change
- Conditional UI based on state
- Loading indicators during operations
- Any visual that depends on state

**Pattern:**

```dart
BlocBuilder<CubitType, StateType>(
  // Optional: only rebuild for specific changes (optimization)
  buildWhen: (prev, curr) => prev.items != curr.items,
  
  builder: (context, state) {
    // Rebuilds whenever state changes (or buildWhen condition met)
    
    // Show loading
    if (state.isLoading) {
      return const LoadingWidget();
    }
    
    // Show error (if not in BlocListener)
    if (state.failure.hasError) {
      return ErrorWidget(error: state.failure);
    }
    
    // Show data
    return ListView(
      children: state.items.map((item) => ItemTile(item: item)).toList(),
    );
  },
)
```

### 4. Error State Handling Patterns

**Pattern: Comprehensive Error Handling**

```dart
// In cubit
Future<void> fetchData() async {
  emit(state.copyWith(
    isLoading: true,
    failure: const Failure.none(),  // Always reset
  ));
  
  final result = await repository.getData();
  
  result.fold(
    (failure) => emit(state.copyWith(
      isLoading: false,
      failure: failure,
    )),
    (data) => emit(state.copyWith(
      isLoading: false,
      data: data,
      failure: const Failure.none(),
    )),
  );
}

// In UI
BlocBuilder<MyCubit, MyState>(
  builder: (context, state) {
    if (state.isLoading && state.data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // Show data even while loading (for refresh scenarios)
    if (state.data != null) {
      return DataWidget(data: state.data!);
    }
    
    // No data and not loading = error
    if (state.failure.hasError) {
      return ErrorWidget(
        message: state.failure.customMessage,
        onRetry: () => context.read<MyCubit>().fetchData(),
      );
    }
    
    return const EmptyWidget();
  },
)
```

### 5. Navigation State Management Patterns

**Pattern: Post-Async Navigation**

```dart
// Trigger action (don't await)
context.read<BudgetCubit>().addBudget(...);

// Handle navigation in BlocListener
BlocListener<BudgetCubit, BudgetState>(
  listenWhen: (prev, curr) => prev.isSaving && !curr.isSaving,
  listener: (context, state) {
    if (state.failure.hasError) {
      showSnackBar(message: state.failure);
      return;  // Don't navigate
    }
    
    AppNavigator.pop(context);  // Navigate after success
  },
  child: Form(...),
)
```

**Pattern: Conditional Navigation Based on State**

```dart
// Read state after operation
await context.read<WalletCubit>().addWallet(...);

// Check current state
final state = context.read<WalletCubit>().state;
if (state.failure.hasError) {
  showSnackBar(message: state.failure);
} else {
  AppNavigator.pop(context);
}
```

---

## Common Patterns & Anti-Patterns

### Anti-Pattern 1: Not Resetting Failure State

```dart
// ✗ BAD: Old failure remains if new operation fails
emit(state.copyWith(isLoading: true));  // Forgot failure: none()

// ✓ GOOD: Always reset on new operation
emit(state.copyWith(
  isLoading: true,
  failure: const Failure.none(),
));
```

### Anti-Pattern 2: Mutating State Directly

```dart
// ✗ BAD: Violates immutability
state.budgets.add(newBudget);
emit(state);

// ✓ GOOD: Use copyWith for immutability
emit(state.copyWith(
  budgets: [...state.budgets, newBudget],
));
```

### Anti-Pattern 3: Not Awaiting Form Operations

```dart
// ✗ BAD: Form closes before operation completes
void _onSubmit() {
  context.read<BudgetCubit>().addBudget(...);
  Navigator.pop(context);  // Happens immediately!
}

// ✓ GOOD: Let BlocListener handle navigation
Future<void> _onSubmit() async {
  context.read<BudgetCubit>().addBudget(...);
  // Don't navigate here; let BlocListener do it
}
```

### Anti-Pattern 4: Unnecessary Await on Fire-and-Forget

```dart
// ✗ INEFFICIENT: Unnecessary blocking
void initState() {
  super.initState();
  Future.microtask(() async {
    await context.read<BudgetCubit>().watchBudget(id);
  });
}

// ✓ CORRECT: Just call it, no await
void initState() {
  super.initState();
  context.read<BudgetCubit>().watchBudget(id);
}
```

### Anti-Pattern 5: Not Cancelling Subscriptions

```dart
// ✗ BAD: StreamSubscription not cancelled on close
class MyCubit extends Cubit<MyState> {
  StreamSubscription? _sub;
  
  void listen() {
    _sub = repository.listen().listen((_) {
      // ...
    });
  }
  // close() not overridden - memory leak!
}

// ✓ GOOD: Cancel on close
class MyCubit extends Cubit<MyState> {
  StreamSubscription? _sub;
  
  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
```

### Anti-Pattern 6: Loading State Blocking Data Display

```dart
// ✗ BAD: Can't see data while loading
if (state.isLoading) return LoadingWidget();
if (state.data != null) return DataWidget(state.data!);

// ✓ GOOD: Show data during refresh
if (state.data != null) {
  return Stack(
    children: [
      DataWidget(state.data!),
      if (state.isLoading)
        const Opacity(opacity: 0.3, child: LoadingOverlay()),
    ],
  );
}
```

### Best Practice 1: Optimistic Updates

```dart
// In cubit
Future<void> deleteItem(String id) async {
  emit(state.copyWith(isDeleting: true, failure: const Failure.none()));
  
  // 1. Optimistically update UI
  final updated = state.items.where((i) => i.id != id).toList();
  emit(state.copyWith(items: updated));
  
  // 2. Make API call
  final result = await repository.delete(id);
  
  // 3. Rollback if failed
  result.fold(
    (failure) => emit(state.copyWith(
      items: state.items,  // Restore original
      isDeleting: false,
      failure: failure,
    )),
    (_) => emit(state.copyWith(
      isDeleting: false,
      failure: const Failure.none(),
    )),
  );
}
```

### Best Practice 2: Efficient Rebuilds with buildWhen

```dart
// In UI
BlocBuilder<BudgetCubit, BudgetState>(
  // Don't rebuild if only selectedBudgetProgress changed
  buildWhen: (prev, curr) => prev.budgets != curr.budgets,
  builder: (context, state) => BudgetList(budgets: state.budgets),
)
```

### Best Practice 3: Composing Multiple Streams

```dart
// In cubit
void watchBudget(String clientId) {
  _targetsSub?.cancel();
  _targetsSub = repository.listenToTargets(clientId).listen((either) {
    either.fold(
      (f) => emit(state.copyWith(failure: f)),
      (t) => emit(state.copyWith(selectedTargets: t)),
    );
  });
  
  _periodsSub?.cancel();
  _periodsSub = repository.listenToPeriods(clientId).listen((either) {
    either.fold(
      (f) => emit(state.copyWith(failure: f)),
      (p) => emit(state.copyWith(selectedPeriods: p)),
    );
  });
}
```

---

## Integration Checklist

When implementing new cubits, ensure:

- [ ] Use `@freezed` for immutable state
- [ ] Use `@injectable` for dependency injection
- [ ] Override `close()` to cancel subscriptions
- [ ] Call `emit(state.copyWith(failure: const Failure.none()))` at operation start
- [ ] Always emit appropriate loading flags (`isLoading`, `isSaving`, etc.)
- [ ] Store error in state, don't throw exceptions
- [ ] Use BlocListener for side effects (navigation, snackbars)
- [ ] Use BlocBuilder for reactive UI
- [ ] Implement `listenWhen` to filter unnecessary listener triggers
- [ ] Implement `buildWhen` to optimize rebuilds
- [ ] Consider optimistic updates for deletions
- [ ] Document expected state transitions in comments
- [ ] Test error scenarios in unit tests

---

## File References

| File | Purpose |
|------|---------|
| `lib/presentation/budget/cubit/budget_cubit.dart` | Budget CRUD + progress tracking |
| `lib/presentation/budget/cubit/budget_state.dart` | Budget state definition (freezed) |
| `lib/presentation/category/cubit/category_cubit.dart` | Category CRUD |
| `lib/presentation/wallets/cubit/wallet_cubit.dart` | Wallet management + selection |
| `lib/core/error/failures/failures.dart` | Error type definitions |
| `lib/presentation/utils/helpers.dart` | UI helpers (showSnackBar, etc.) |
| `lib/presentation/utils/dialogs.dart` | Dialog helpers |

---

## Related Documentation

- [Flutter Bloc Documentation](https://bloclibrary.dev/)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Injectable Documentation](https://pub.dev/packages/injectable)
- Memory: [Applied Helpers](APPLIED_HELPERS.md) - Reusable helper functions
- Memory: [Refactoring Checklist](REFACTORING_CHECKLIST.md) - Screen refactoring guidelines
