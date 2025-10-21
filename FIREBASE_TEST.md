# Firebase Connection Test

## Common Causes of "API key not valid" Error

1. **Firebase Authentication not enabled**:
   - Go to Firebase Console
   - Select your project "tracklet-4db05"
   - Click "Authentication" in the left sidebar
   - Click "Get started"
   - Enable "Email/Password" sign-in method

2. **User account doesn't exist**:
   - The user "agha@gmail.com" with password "123123" must be created in Firebase Authentication
   - Go to Firebase Console > Authentication > Users
   - Click "Add user"
   - Email: agha@gmail.com
   - Password: 123123

3. **API key restrictions**:
   - Check if your API key has restrictions in Google Cloud Console
   - Go to Google Cloud Console > APIs & Services > Credentials
   - Find your API key and check restrictions

4. **Network issues**:
   - Ensure you have a stable internet connection
   - Check if your firewall/antivirus is blocking the connection

## How to Verify Firebase Setup

1. **Check Firebase Authentication**:
   - Ensure Email/Password authentication is enabled
   - Verify the user "agha@gmail.com" exists with password "123123"

2. **Test with Firebase Console**:
   - Use the Firebase Console to manually sign in with the credentials
   - This will confirm if the issue is with the app or the Firebase setup

3. **Check API Key**:
   - Verify the API key in your configuration matches the one in Firebase Console
   - Current API key: AIzaSyBUsQJqwqMNunBYxfFJmxjEfLLZodjC-gM

## Steps to Fix the Issue

1. **Enable Firebase Authentication**:
   - Go to Firebase Console > Authentication > Get Started
   - Enable Email/Password sign-in method

2. **Create the Super Admin User**:
   - Go to Firebase Console > Authentication > Users
   - Click "Add user"
   - Email: agha@gmail.com
   - Password: 123123

3. **Verify API Key**:
   - Go to Firebase Console > Project Settings > General
   - Find the Web API Key and verify it matches the one in your app

4. **Test Connection**:
   - Try logging in again with the credentials
   - Check the detailed error message for more information