# Quick Firebase Setup Guide

## 🔥 IMPORTANT: Complete Firebase Setup Required

Your app has been successfully migrated from Supabase to Firebase! However, you need to complete the Firebase setup with your actual project credentials.

## ⚡ Quick Setup Steps

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com/
   - Create a new project or use existing one
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Enable Firebase Storage

2. **Replace Configuration Files**
   
   **Android:**
   - Download your `google-services.json` from Firebase Console
   - Replace: `android/app/google-services.json`
   
   **iOS:**
   - Download your `GoogleService-Info.plist` from Firebase Console  
   - Replace: `ios/Runner/GoogleService-Info.plist`

3. **Update Firebase Options**
   - Edit `lib/firebase_options.dart`
   - Replace all placeholder values with your actual Firebase config

4. **Run the App**
   ```bash
   flutter pub get
   flutter run
   ```

## 📱 App Features
- ✅ User Authentication (Login/Register)
- ✅ Budget Management
- ✅ Wedding Checklist
- ✅ Guest Management
- ✅ Venue Browser

## 🔍 What Changed
- **Removed:** Supabase dependencies
- **Added:** Firebase Auth, Firestore, Storage
- **Updated:** All services, models, and screens
- **Maintained:** All existing functionality

## 📚 Detailed Instructions
See `FIREBASE_MIGRATION.md` for comprehensive setup instructions and troubleshooting.

---
**Ready to plan the perfect wedding! 💒**