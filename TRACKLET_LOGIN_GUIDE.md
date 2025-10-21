# Tracklet App Login Guide

## Overview
The Tracklet app requires users to be created through the Super Admin app before they can login. All users share the same Firebase project but have different roles (Distributor or Gas Plant).

## Prerequisites
1. Super Admin app must be set up and running
2. At least one user must be created through the Super Admin app
3. Internet connection

## How to Login to Tracklet App

### Step 1: Create a User in Super Admin App
1. Open the Super Admin app
2. Login with:
   - Email: agha@tracklet.com
   - Password: 123123
3. Go to the "Create User" tab
4. Fill in user details:
   - Email: (any valid email)
   - Name: (optional)
   - Role: Select either "Distributor" or "Gas Plant"
   - For Gas Plant users, also provide:
     - Company Name
     - Address
5. Click "Create User"
6. Note that all new users get the default password: `123123`

### Step 2: Login to Tracklet App
1. Open the Tracklet app
2. Use the email and password you just created:
   - Email: (the email you used in Super Admin)
   - Password: `123123` (default password for all new users)
3. Click "Login"

## Test Credentials
If you've already created users, try these common test credentials:

### Distributor Role:
- Email: distributor@tracklet.com
- Password: 123123

### Gas Plant Role:
- Email: gasplant@tracklet.com
- Password: 123123

## Common Issues and Solutions

### 1. "No user found with this email"
- The email doesn't exist in Firebase Authentication
- Solution: Create the user through Super Admin app

### 2. "Incorrect password"
- Wrong password entered
- Solution: Use default password `123123` or reset in Firebase Console

### 3. "Login failed: [error message]"
- Network issues or Firebase configuration problems
- Solution: Check internet connection and Firebase setup

## User Roles
The Tracklet app has two user roles:

1. **Distributor**: 
   - Access to distributor dashboard
   - Features for managing distribution operations

2. **Gas Plant**:
   - Access to gas plant dashboard
   - Features for managing gas plant operations
   - Requires company name and address

## Password Management
- All new users are created with default password: `123123`
- Users should change their password after first login
- Password reset functionality can be implemented through Firebase Console

## Troubleshooting
1. Ensure you're using the correct email that was created in Super Admin
2. Verify the default password is `123123`
3. Check internet connectivity
4. Confirm Firebase Authentication is enabled
5. Make sure the user exists in Firebase Console > Authentication > Users