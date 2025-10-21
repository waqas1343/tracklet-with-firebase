# Create Super Admin User

To set up the Super Admin user with the fixed credentials (agha@gmail.com / 123123), you need to create this user in Firebase Authentication.

## Option 1: Manual Creation (Recommended for Development)

1. Go to the Firebase Console: https://console.firebase.google.com/
2. Select your project
3. Click on "Authentication" in the left sidebar
4. Click on the "Users" tab
5. Click "Add user"
6. Enter the following details:
   - Email: agha@gmail.com
   - Password: 123123
7. Click "Add user"

## Option 2: Using Firebase Admin SDK (For Production)

If you want to create the user programmatically, you can use the Firebase Admin SDK:

### Node.js Example:
```javascript
const admin = require('firebase-admin');

// Initialize the Admin SDK (you'll need to download your service account key)
const serviceAccount = require('./path/to/serviceAccountKey.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Create the admin user
admin.auth().createUser({
  email: 'agha@gmail.com',
  password: '123123',
  displayName: 'Super Admin'
})
.then((userRecord) => {
  console.log('Successfully created new user:', userRecord.uid);
})
.catch((error) => {
  console.log('Error creating new user:', error);
});
```

## Option 3: Using Firebase CLI (Alternative)

You can also use the Firebase CLI to create users:

```bash
# Install Firebase CLI if you haven't already
npm install -g firebase-tools

# Login to Firebase
firebase login

# Create user (Note: Firebase CLI doesn't directly support creating users with passwords)
# You would still need to use the manual method or Admin SDK
```

## Security Considerations

For production use, consider these security improvements:

1. **Use a stronger password**: "123123" is not secure for production
2. **Enable email verification**: Require the admin to verify their email
3. **Use custom claims**: Assign an "admin" custom claim to this user
4. **Implement proper role-based access control**: Check for admin privileges in your app

## Testing the Setup

After creating the user:

1. Run the Super Admin app:
```bash
cd super_admin
flutter run
```

2. The login screen should be pre-filled with:
   - Email: agha@gmail.com
   - Password: 123123

3. Click "Login" to access the admin dashboard

## Troubleshooting

If you encounter issues:

1. **Invalid credentials**: Double-check the email and password
2. **User not found**: Make sure you created the user in Firebase Authentication
3. **Permission denied**: Ensure your Firestore security rules allow admin access

## Next Steps

1. Create additional users through the Super Admin dashboard
2. Set up proper Firestore security rules
3. Implement additional admin features as needed