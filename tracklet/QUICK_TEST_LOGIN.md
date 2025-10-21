# Quick Login Test Guide

## 🧪 Test Scenario 1: Login with Distributor Account

### Setup:
1. Open **Super Admin** app
2. Login: `agha@tracklet.com` / `123123`
3. Create user:
   - Email: `distributor@test.com`
   - Role: **Distributor**
   - Click "Create User"

### Test:
1. Open **Tracklet** app
2. Login: `distributor@test.com` / `123123`
3. **Expected:** ✅ Distributor Dashboard with 4 tabs
   - Dashboard
   - Orders  
   - Drivers
   - Settings

---

## 🧪 Test Scenario 2: Login with Gas Plant Account

### Setup:
1. Open **Super Admin** app
2. Login: `agha@tracklet.com` / `123123`
3. Create user:
   - Email: `gasplant@test.com`
   - Role: **Gas Plant**
   - Company Name: "Test Gas Plant"
   - Address: "123 Test Street"
   - Click "Create User"

### Test:
1. Open **Tracklet** app
2. Login: `gasplant@test.com` / `123123`
3. **Expected:** ✅ Gas Plant Dashboard with 5 tabs
   - Dashboard
   - Gas Rate
   - Orders
   - Expenses
   - Settings

---

## 🧪 Test Scenario 3: Quick Account Creation

### Test:
1. Open **Super Admin** app
2. On login screen, click "Create Account"
3. Enter:
   - Email: `quicktest@test.com`
   - Password: `password123`
4. Click "Create"
5. **Expected:** ✅ Account created successfully
6. Open **Tracklet** app
7. Login: `quicktest@test.com` / `password123`
8. **Expected:** ✅ Distributor Dashboard (default role)

---

## ❌ Error Handling Tests

### Test Invalid Credentials:
1. Login: `wrong@test.com` / `wrongpass`
2. **Expected:** ✅ Error message: "No user found with this email"

### Test Wrong Password:
1. Login: `distributor@test.com` / `wrongpassword`
2. **Expected:** ✅ Error message: "Incorrect password"

### Test Empty Fields:
1. Leave email or password empty
2. **Expected:** ✅ Error message: "Please enter both email and password"

---

## 🔧 Troubleshooting

### If login fails with "User data not found":
- **Cause:** User exists in Firebase Auth but not in Firestore
- **Solution:** Delete user from Firebase Console and recreate via Super Admin

### If app crashes on login:
- **Cause:** Firebase not initialized
- **Solution:** Restart app (Firebase initializes on app start)

### If wrong dashboard appears:
- **Cause:** Role mismatch in Firestore
- **Solution:** Check Firestore console → `users` collection → verify `role` field

---

## ✅ All Tests Should Pass!

If any test fails, check:
1. Firebase Configuration
2. Internet connection
3. Google Services plugin
4. Dependencies installed (`flutter pub get`)

Happy testing! 🎉

