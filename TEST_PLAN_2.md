# 📊 Trakli App – Manual Testing Guide (Extended)

## 🧩 Overview

This guide helps testers verify the full user journey in Trakli, including **authentication and onboarding setup**.

---

# 🔐 0. Authentication (Login & Registration)

## 🆕 Register New User

### Steps:

1. Open the app
2. Tap **Sign Up / Register**
3. Enter:

    * Email
    * Password
4. Submit

### ✅ Expected Result:

* User account is created
* User is redirected to onboarding

---

## 🔑 Login Existing User

### Steps:

1. Open the app
2. Enter valid credentials
3. Tap **Login**

### ✅ Expected Result:

* User is logged in successfully
* If first time → onboarding starts
* If returning user → goes to dashboard

---

# 🚀 1. Onboarding Flow (5 Steps)

---

## 🌍 Step 1: Language Selection

### Steps:

1. On first launch, observe language screen
2. Select a language (e.g., English)
3. Continue

### ✅ Expected Result:

* Language is applied across the app
* User proceeds to next step

---

## 👥 Step 2: Group Setup

(Defines user's main financial group)

### Steps:

Test ALL options:

### Option A: Create Automatically

1. Select **Create Automatically**
2. Continue

### ✅ Expected Result:

* Default group is created (e.g., “Personal”)

---

### Option B: Create Manually

1. Select **Create Manually**
2. Enter group name
3. Save

### ✅ Expected Result:

* New group is created with provided name

---

### Option C: Select from Existing Groups

1. Select **Select from Group List**
2. Choose a group

### ✅ Expected Result:

* Selected group is assigned to user

---

## 💼 Step 3: Wallet Setup

(Defines where money is stored)

### Steps:

Test ALL options:

### Option A: Create Automatically

1. Select **Create Automatically**
2. Continue

### ✅ Expected Result:

* Default wallet (e.g., “Cash”) is created

---

### Option B: Create Manually

1. Select **Create Manually**
2. Enter:

    * Wallet name
    * Initial balance
3. Save

### ✅ Expected Result:

* Wallet is created with correct balance

---

### Option C: Select from Wallet List

1. Select **Select from Wallet List**
2. Choose a wallet

### ✅ Expected Result:

* Selected wallet is assigned

---

## 🏷️ Step 4: Category Setup

### Steps:

1. Review list of categories shown
2. Ensure both:

    * Income categories
    * Expense categories
3. Continue

### ✅ Expected Result:

* Default categories are created
* Categories are available in transactions

---

## ✅ Step 5: All Set

### Steps:

1. Review completion screen
2. Tap **Continue / Finish**

### ✅ Expected Result:

* User is redirected to main dashboard
* No onboarding screens appear again

---

# 🔄 Onboarding Edge Cases

Test the following:

### 🔁 Restart During Onboarding

* Close app mid-onboarding
* Reopen app

### ✅ Expected:

* User resumes from last step OR restarts correctly

---

### ⏭️ Skip Actions

* Try continuing without selecting options

### ✅ Expected:

* Validation prevents skipping required steps

---

### 🔙 Navigate Back

* Go back to previous step

### ✅ Expected:

* Previously entered data is preserved

---

# ⚠️ What to Watch For

Report if:

* Onboarding skips steps unexpectedly
* Data is not saved after onboarding
* Duplicate wallets/groups are created
* App crashes between steps
* Wrong default values appear

---

# ✅ Onboarding Completion Checklist

* [ ] Language selection works
* [ ] Group setup works (all 3 options)
* [ ] Wallet setup works (all 3 options)
* [ ] Categories are created correctly
* [ ] User reaches dashboard successfully
* [ ] Onboarding does not repeat unnecessarily

---

# 📌 Final Result

After onboarding:

* User should have:

    * 1 Group
    * 1 Wallet
    * Default Categories
* App should be ready for normal usage

---

**Status:** Ready for Full User Journey Testing
