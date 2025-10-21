# VAPID Key Kaise Add Karein

## 🔑 Step 1: Firebase Console Se Key Le

1. https://console.firebase.google.com/ pe jayen
2. Project select karein
3. ⚙️ → Project settings → Cloud Messaging
4. "Web Push certificates" section mein jayen
5. "Generate key pair" click karein (agar already hai to copy karein)
6. Key copy kar lein

## 📝 Step 2: Code Mein Key Add Karein

**File:** `tracklet/lib/core/services/fcm_service.dart`

**Line Number:** ~155

**Purani Code:**
```dart
_fcmToken = await _messaging.getToken(
  vapidKey: 'YOUR_VAPID_KEY_HERE', // Replace with your actual VAPID key
);
```

**Nayi Code (Apni key se replace karein):**
```dart
_fcmToken = await _messaging.getToken(
  vapidKey: 'BKxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
);
```

## 🎯 Example:

Maan lo aapki key yeh hai:
```
BKagQIDAQABgQDEYxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

To code aisa hoga:
```dart
_fcmToken = await _messaging.getToken(
  vapidKey: 'BKagQIDAQABgQDEYxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
);
```

## ✅ Verify Karein

Code change karne ke baad:
1. App ko hot restart karein
2. Console mein dekhein:
   ```
   🔑 Getting FCM token...
   ✅ FCM Token: [your-token-will-appear-here]
   ```

## 🔍 Agar Token Nahi Mil Raha

1. Browser permissions check karein
2. Firebase project settings verify karein
3. Console mein errors dekhein
4. VAPID key sahi hai ya nahi check karein

---

## 📱 Testing Notification

Token milne ke baad Firebase Console se test notification bhej sakte hain:

1. Firebase Console → Cloud Messaging
2. "Send test message" click karein
3. Token paste karein
4. Notification bhejein
5. App mein notification aana chahiye

---

**Note:** Yeh sirf web ke liye zaroori hai. Android/iOS mein VAPID key ki zaroorat nahi.

