# User Creation and Login Process Guide

## Overview
This guide explains how to create a new user account using the Super Admin app and then login with that account.

## Prerequisites
- Super Admin app installed and running
- Internet connection
- Super Admin credentials (agha@tracklet.com / 123123)

## Step-by-Step Process

### Step 1: Login as Super Admin
1. Open the Super Admin app
2. Enter credentials:
   - Email: `agha@tracklet.com`
   - Password: `123123`
3. Click "Login"
4. You should be redirected to the Super Admin Dashboard

### Step 2: Create a New User Account
1. In the dashboard, you'll see two tabs: "Create User" and "User List"
2. Make sure you're on the "Create User" tab
3. Fill in the user details:
   - **Email**: Enter the email address for the new user (required)
   - **Name**: Enter the user's name (optional)
   - **Role**: Select either:
     - `Distributor` - For distributor company users
     - `Gas Plant` - For gas plant company users
   - **For Gas Plant users only**:
     - **Company Name**: Enter the gas plant company name
     - **Address**: Enter the company address
4. Click the "Create User" button
5. If successful, you'll see a success message:
   "User created successfully with default password: 123123"
6. The new user is now created in both Firebase Authentication and Firestore

### Step 3: Login with the New Account
1. Logout from the Super Admin account
2. On the login screen, enter the credentials for your newly created user:
   - **Email**: The email address you used in Step 2
   - **Password**: `123123` (this is the default password for all new users)
3. Click "Login"
4. You should now be logged in as the new user

## Important Notes
- All new users are created with the default password: `123123`
- Users should change their password after first login for security
- The Super Admin can create unlimited users
- Each user's role determines which dashboard they see in the Tracklet app

## Troubleshooting
- If login fails, verify the email exists in Firebase Authentication
- Check that Firebase Authentication is enabled in the Firebase Console
- Ensure you're using the correct default password (123123)
- Verify internet connectivity