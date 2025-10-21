# Firebase Debugging Guide

## Common Login Issues and Solutions

### 1. User Account Issues
- Make sure the user "agha@tracklet.com" exists in Firebase Authentication
- Verify the password is "123123"
- Check that Email/Password authentication is enabled in Firebase Console

### 2. Firebase Configuration Issues
- Verify API key: AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM
- Check that both apps are registered in the same Firebase project
- Ensure google-services.json is in the correct location

### 3. Network Issues
- Check internet connectivity
- Verify no firewall is blocking Firebase connections
- Try on a different network if possible

### 4. Debugging Steps

1. **Check Firebase Console**:
   - Go to Firebase Console > Authentication > Users
   - Verify user "agha@tracklet.com" exists
   - Check if Email/Password authentication is enabled

2. **Verify API Key**:
   - Go to Firebase Console > Project Settings > General
   - Check Web API Key matches the one in your app

3. **Test with Different Credentials**:
   - Try creating a new test user in Firebase Console
   - Test login with those credentials

4. **Check Error Messages**:
   - Look at the specific error message displayed
   - "user-not-found" means the email doesn't exist
   - "wrong-password" means incorrect password
   - "invalid-api-key" means Firebase configuration issue

### 5. Quick Fixes

1. **Recreate the User**:
   - Delete the existing user in Firebase Console
   - Create a new user with:
     - Email: agha@tracklet.com
     - Password: 123123

2. **Enable Authentication**:
   - Firebase Console > Authentication > Get Started
   - Enable Email/Password sign-in method

3. **Check App Registration**:
   - Firebase Console > Project Settings
   - Verify both apps are registered with correct package names