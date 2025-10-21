# Account Creation Debugging Guide

## Common Account Creation Issues and Solutions

### 1. Firebase Authentication Not Enabled
- Go to Firebase Console > Authentication > Get Started
- Enable Email/Password sign-in method
- Click "Save"

### 2. Weak Password
- Firebase requires passwords to be at least 6 characters
- Make sure to use a strong password

### 3. Email Already in Use
- Try using a different email address
- Check if the email is already registered in Firebase Authentication

### 4. Network Issues
- Check internet connectivity
- Try on a different network if possible

### 5. API Key Issues
- Verify API key in Firebase Console
- Check that google-services.json is in the correct location

## Debugging Steps

1. **Check Firebase Console**:
   - Go to Firebase Console > Authentication > Users
   - Verify if the email you're trying to use already exists

2. **Enable Authentication**:
   - Firebase Console > Authentication > Get Started
   - Enable Email/Password sign-in method

3. **Verify API Key**:
   - Go to Firebase Console > Project Settings > General
   - Check Web API Key matches the one in your app

4. **Test with Different Credentials**:
   - Try creating an account with a completely new email
   - Use a strong password (at least 6 characters)

## Error Code Meanings

- **email-already-in-use**: The email is already registered
- **invalid-email**: The email format is incorrect
- **operation-not-allowed**: Email/password authentication is not enabled
- **weak-password**: Password is less than 6 characters
- **network-request-failed**: Internet connection issue

## Quick Fixes

1. **Enable Email/Password Authentication**:
   - Firebase Console > Authentication > Sign-in method
   - Enable Email/Password provider

2. **Use a Different Email**:
   - Try user1@tracklet.com, user2@tracklet.com, etc.

3. **Check Internet Connection**:
   - Ensure stable internet connectivity

4. **Verify Firebase Configuration**:
   - Check that google-services.json is in android/app/
   - Verify API key in firebase_options.dart