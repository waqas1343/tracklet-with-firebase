# Account Creation Troubleshooting Guide

## Common Issues and Solutions

### 1. Firebase Authentication Not Enabled
**Problem**: Email/Password authentication is not enabled in Firebase Console
**Solution**: 
- Go to Firebase Console > Authentication > Sign-in method
- Enable "Email/Password" provider
- Click "Save"

### 2. Network Connectivity Issues
**Problem**: Poor internet connection preventing Firebase requests
**Solution**:
- Check your internet connection
- Try on a different network
- Ensure no firewall is blocking Firebase connections

### 3. Invalid Email Format
**Problem**: Email address doesn't match valid format
**Solution**:
- Use a valid email format (e.g., user@domain.com)
- Avoid special characters that might cause issues

### 4. Weak Password
**Problem**: Password less than 6 characters
**Solution**:
- Use a password with at least 6 characters
- Include a mix of letters, numbers, and symbols for better security

### 5. Email Already Registered
**Problem**: Trying to create an account with an email that already exists
**Solution**:
- Use a different email address
- Check Firebase Authentication in Console to see existing users

### 6. Firebase Not Initialized
**Problem**: Firebase app not properly initialized
**Solution**:
- Restart the app completely
- Check that google-services.json is in the correct location
- Verify Firebase configuration in firebase_options.dart

## Debugging Steps

### Step 1: Check Firebase Console
1. Go to Firebase Console > Authentication > Users
2. Verify if the email you're trying to use already exists
3. Check that Email/Password authentication is enabled

### Step 2: Verify Internet Connection
1. Ensure you have a stable internet connection
2. Try accessing other websites/apps to confirm connectivity

### Step 3: Test with Different Credentials
1. Try creating an account with a completely new email
2. Use a strong password (at least 6 characters)
3. Example: testuser123@tracklet.com / password123

### Step 4: Check Error Messages
1. Look at the specific error message displayed
2. Common error codes:
   - "email-already-in-use": Email already registered
   - "invalid-email": Email format is incorrect
   - "operation-not-allowed": Authentication method not enabled
   - "weak-password": Password too short

## Quick Fixes

### Enable Email/Password Authentication
1. Open Firebase Console
2. Select your project
3. Click "Authentication" in the left sidebar
4. Click "Sign-in method" tab
5. Click "Email/Password" provider
6. Enable it and save

### Create Test Users
Try these test credentials:
- Email: testuser1@tracklet.com
- Password: test1234

If this works, the issue is with the specific email/password you were trying to use.

### Restart the App
Sometimes Firebase initialization issues can be resolved by:
1. Completely closing the app
2. Reopening and trying again

## If Issues Persist

1. **Check Firebase Logs**: Look at the detailed error messages in the app
2. **Verify Configuration**: Ensure google-services.json is in android/app/
3. **Contact Support**: If all else fails, Firebase support can help diagnose deeper issues