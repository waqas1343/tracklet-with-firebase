# Login Troubleshooting Guide

## Common Login Issues and Solutions

### 1. User Account Doesn't Exist
**Problem**: Trying to login with an email that hasn't been created in Firebase
**Solution**:
- Go to Firebase Console > Authentication > Users
- Verify that "agha@tracklet.com" exists
- If it doesn't exist, create it with password "123123"
- Or use the "Create Account" button in the app

### 2. Incorrect Password
**Problem**: Using the wrong password for the account
**Solution**:
- Double-check the password is "123123"
- If you've changed it, use the correct password
- Reset the password in Firebase Console if needed

### 3. Firebase Authentication Not Enabled
**Problem**: Email/Password authentication is disabled
**Solution**:
- Go to Firebase Console > Authentication > Sign-in method
- Enable "Email/Password" provider
- Click "Save"

### 4. Network Issues
**Problem**: Internet connection preventing Firebase requests
**Solution**:
- Check your internet connection
- Try on a different network
- Ensure no firewall is blocking Firebase connections

### 5. Invalid API Key
**Problem**: Firebase configuration has incorrect API key
**Solution**:
- Verify API key in `lib/core/config/firebase_options.dart`
- Current key should be: `AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM`
- Check that it matches Firebase Console

### 6. User Disabled
**Problem**: The user account has been disabled
**Solution**:
- Go to Firebase Console > Authentication > Users
- Find "agha@tracklet.com"
- Check if the account is disabled
- Enable it if necessary

## Debugging Steps

### Step 1: Check Firebase Console
1. Go to Firebase Console > Authentication > Users
2. Verify "agha@tracklet.com" exists
3. Check that Email/Password authentication is enabled
4. Verify the account is not disabled

### Step 2: Verify Credentials
1. Email: `agha@tracklet.com`
2. Password: `123123`
3. Make sure there are no extra spaces

### Step 3: Check Error Message
Look at the specific error message displayed in the app:
- "No user found with this email" - User doesn't exist
- "Incorrect password" - Wrong password
- "Firebase API key is not valid" - Configuration issue
- "Network error" - Internet connection problem

### Step 4: Test with Create Account
1. Use the "Create New Account" button
2. Create a test account:
   - Email: testuser@tracklet.com
   - Password: test1234
3. Try logging in with those credentials

## Quick Fixes

### Create the Required User
If "agha@tracklet.com" doesn't exist:
1. Open Firebase Console
2. Go to Authentication > Users
3. Click "Add user"
4. Enter:
   - Email: agha@tracklet.com
   - Password: 123123
5. Click "Add user"

### Enable Authentication
If Email/Password is not enabled:
1. Firebase Console > Authentication > Sign-in method
2. Click "Email/Password" provider
3. Enable it and save

### Test with Different Credentials
Try these test credentials:
- Email: testuser@tracklet.com
- Password: test1234

If this works, the issue is with the specific account you were trying to use.

## If Issues Persist

1. **Restart the App**: Completely close and reopen
2. **Check Internet**: Ensure stable connection
3. **Verify Configuration**: Check firebase_options.dart
4. **Contact Support**: Firebase support can help diagnose deeper issues