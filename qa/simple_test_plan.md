# 📊 Trakli App – Complete Manual Testing Guide

## 🧩 Overview

This guide helps testers verify the full functionality of the Trakli app by following real user actions.

No technical knowledge is required.

---

## 🎯 Goal

Ensure that:

* Users can register and log in
* Onboarding works correctly
* Financial data is accurate
* Data persists offline
* Sync works correctly
* App is stable and user-friendly

---

## 🚀 How to Use This Guide

* Follow each step carefully
* Compare results with expected outcomes
* Report anything that does not match

---

# 🔐 1. Authentication

## 🆕 Register New User

### Steps:

1. Open the app
2. Tap **Create an account or Social(Google/Apple)**
3. If you select **create an account**, follow email verification and provide email and password
4. Submit

### ✅ Expected Result:

* Account is created
* Onboarding starts immediately

---

## 🔑 Login Existing User

### Steps:

1. Open the app
2. Tap **Login or Social(Google/Apple)**
3. If you select **Login**, Enter valid credentials and tap **Login**
4. Tap **Login**

### ✅ Expected Result:

* User logs in successfully
* Goes to onboarding (if first time) or dashboard

---

# 🚀 2. Onboarding Flow

---

## 🌍 Step 1: Language Selection

### Steps:

1. Select a language
2. Continue

### ✅ Expected Result:

* Language is applied across the app

---

## 👥 Step 2: Group Setup

Test all options:

### Option A: Create Automatically

* Select option → Continue
  ✅ Default group is created

### Option B: Create Manually

* Enter group name → Save
  ✅ Group is created with entered name

### Option C: Select from List

* Choose existing group
  ✅ Selected group is assigned

---

## 💼 Step 3: Wallet Setup

Test all options:

### Option A: Create Automatically

✅ Default wallet created

### Option B: Create Manually

* Enter name + balance
  ✅ Wallet created with correct balance

### Option C: Select from List

✅ Selected wallet assigned

---

## 🏷️ Step 4: Category Setup

### Steps:

1. Either select "create default categories" or "skip for now"
2. Continue

### ✅ Expected Result:

* Income and expense categories exist if user chooses option 1.
* No categories exist for option 2.

---

## ✅ Step 5: Completion

### Steps:

1. Tap **Got to dashboard**

### ✅ Expected Result:

* User enters main dashboard
* Onboarding does not repeat

---

## 🔄 Onboarding Edge Cases

* Close app midway → reopen
  ✅ Resume or restart correctly

* Skip required input
  ✅ Validation prevents progress

* Navigate back
  ✅ Data is preserved

---

# 💰 3. Wallet & Transactions

---

## 🧾 Create Wallet + Add Income

### Steps:

1. Go to Wallets → Add Wallet (“Cash”, 0)
2. Add Income = 100

### ✅ Expected Result:

* Balance = 100

---

## 💸 Add Expense

### Steps:

1. Add Expense = 40

### ✅ Expected Result:

* Balance = 60

---

## 🔁 Multiple Transactions

### Steps:

1. Add multiple incomes & expenses

### ✅ Expected Result:

* Balance remains correct

---

# 📂 4. Categories

### Steps:

1. Add category “Food”
2. Delete category

### ✅ Expected Result:

* Category removed without errors

---

# 👥 5. Parties

### Steps:

1. Add new party “John”

### ✅ Expected Result:

* Party appears in list

---

# 📎 6. Attachments

### Steps:

1. Add transaction
2. Attach file

### ✅ Expected Result:

* File saved and accessible

---

# 🔁 7. Data Persistence

### Steps:

1. Close app
2. Reopen app

### ✅ Expected Result:

* All data remains unchanged

---

# 🌐 8. Offline Mode

### Steps:

1. Turn OFF internet
2. Add transaction
3. Turn ON internet

### ✅ Expected Result:

* Data is saved offline
* Sync happens when online

---

# 🔄 9. Sync Testing

### Steps:

1. Add data on one device
2. Open app on another device

### ✅ Expected Result:

* Data syncs correctly

---

# ⚠️ What to Watch For

Report if you see:

* Incorrect balances
* Missing data
* Duplicate entries
* Crashes
* Sync failures
* Onboarding repeating

---

# ✅ Final Checklist

* [ ] Authentication works
* [ ] Onboarding completes correctly
* [ ] Wallet calculations are correct
* [ ] Data persists after restart
* [ ] Offline mode works
* [ ] Sync works
* [ ] No crashes observed

---

# 📌 Expected Final State

After full setup:

* User has at least:

    * 1 Group
    * 1 Wallet
    * Categories
* App is ready for daily use

---

**Status:** Ready for Testing
**Type:** Manual / User Acceptance Testing (UAT)
