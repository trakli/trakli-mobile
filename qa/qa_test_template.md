# 📊 Trakli – QA Test Cases

## 🧪 Test Table

| Test ID | Feature | Test Scenario | Steps | Expected Results | Tester Name | Device | Status | Comments | Screenshot |
|--------|--------|--------------|-------|------------------|-------------|--------|--------|----------|------------|
| AUTH-01 | Auth | Register | Open app → Tap Register → Enter email & password → Submit | Account created & onboarding starts |  |  | ⬇️ |  |  |
| AUTH-02 | Auth | Login | Open app → Enter valid credentials → Tap Login | User logs in and is redirected |  |  | ⬇️ |  |  |
| WLT-01 | Wallets | Create | Tap '+' on Wallets → Enter name & balance → Save | Wallet appears in list with correct balance |  |  | ⬇️ |  |  |
| WLT-02 | Wallets | Edit | Select wallet → Tap Edit → Change name → Save | Wallet details updated successfully |  |  | ⬇️ |  |  |
| WLT-03 | Wallets | Delete | Select wallet → Tap Edit/Delete → Confirm | Wallet removed and transactions updated/orphaned |  |  | ⬇️ |  |  |
| TXN-01 | Transactions | Create | Tap '+' → Enter amount → Select category & wallet → Save | Transaction in history & balance updates |  |  | ⬇️ |  |  |
| TXN-02 | Transactions | Edit | Open transaction → Tap Edit → Change amount → Save | Transaction updated & balance adjusted |  |  | ⬇️ |  |  |
| TXN-03 | Transactions | Delete | Open transaction → Tap Delete → Confirm | Transaction removed & balance reverted |  |  | ⬇️ |  |  |
| TRF-01 | Transfers | Create | Tap Transfer → Select From/To wallets → Enter amount → Save | Balances of both wallets updated correctly |  |  | ⬇️ |  |  |
| GRP-01 | Groups | Create | Go to Groups → Tap '+' → Enter name → Save | Group created for shared tracking |  |  | ⬇️ |  |  |
| GRP-02 | Groups | Edit | Select Group → Tap Edit → Change name → Save | Group details updated |  |  | ⬇️ |  |  |
| GRP-03 | Groups | Delete | Select Group → Tap Delete → Confirm | Group removed |  |  | ⬇️ |  |  |
| CAT-01 | Categories | Create | Go to Categories → Tap '+' → Choose icon & name → Save | New category available for transactions |  |  | ⬇️ |  |  |
| CAT-02 | Categories | Edit | Select Category → Tap Edit → Change name/icon → Save | Category updated across all transactions |  |  | ⬇️ |  |  |
| CAT-03 | Categories | Delete | Select Category → Tap Delete → Confirm | Category removed or reset to default |  |  | ⬇️ |  |  |
| PTY-01 | Parties | Create | Go to Parties → Tap '+' → Enter name → Save | Party (contact) created for transactions |  |  | ⬇️ |  |  |
| PTY-02 | Parties | Edit | Select Party → Tap Edit → Change details → Save | Party information updated |  |  | ⬇️ |  |  |
| PTY-03 | Parties | Delete | Select Party → Tap Delete → Confirm | Party removed |  |  | ⬇️ |  |  |
| CFG-01 | Config | Change Currency | Settings → Defaults → Select Currency → Choose USD/EUR | All balances update with new currency symbol |  |  | ⬇️ |  |  |
| CFG-02 | Config | Switch Default Group | Settings → Defaults → Tap Group → Select new group | New transactions default to the selected group |  |  | ⬇️ |  |  |
| CFG-03 | Config | Switch Default Wallet | Settings → Defaults → Tap Wallet → Select new wallet | New transactions default to the selected wallet |  |  | ⬇️ |  |  |
| SNC-01 | Sync | Manual Trigger | Settings → Sync → Tap 'Sync Now' | Data is pushed to server and "Last Synced" updates |  |  | ⬇️ |  |  |
| SNC-02 | Sync | Background Sync | Create txn offline → Go online → Wait | Transaction appears in "Last Sync Status" history |  |  | ⬇️ |  |  |
| SNC-03 | Sync | Handle Failed Changes | Settings → Sync → Check "Failed" → Retry or Dismiss | Failed change is re-processed or removed |  |  | ⬇️ |  |  |

---

## 🔽 Status Options

Testers should select one of:

- Not Started
- In Progress
- Passed
- Failed
- Blocked

---

## 📝 Notes for Testers

- Fill in:
  - Tester Name
  - Device (e.g. Android, iOS)
  - Status
  - Comments
  - Screenshot (attach link)

- Report any:
  - Errors/Crashes
  - Unexpected behavior

---

## ✅ Completion Criteria

All tests should:
- Pass without errors
- Handle invalid input gracefully
- Reflect data changes across all relevant screens
- Maintain state after app restart
