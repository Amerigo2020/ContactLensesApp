# Google Play Store Readiness Checklist

Use this checklist to track your progress toward Play Store deployment.

---

## ✅ Phase 1: Android Build System (COMPLETED)

- [x] **Root build configuration**
  - [x] `android/build.gradle` created
  - [x] `android/settings.gradle` created
  - [x] `android/gradle.properties` configured
  - [x] Gradle wrapper (NOTE: Will be created by Flutter on first build)

- [x] **App-level build configuration**
  - [x] `android/app/build.gradle` with SDK versions
  - [x] applicationId: `com.lensguard.app`
  - [x] minSdk: 24, targetSdk: 34
  - [x] Firebase dependencies added
  - [x] ProGuard/R8 rules configured
  - [x] Signing configuration added

- [x] **AndroidManifest.xml**
  - [x] All required permissions declared
  - [x] Notification permissions (Android 13+)
  - [x] Alarm & reminder permissions
  - [x] Firebase services configured
  - [x] MainActivity declared
  - [x] Network security config referenced

- [x] **App Signing**
  - [x] `key.properties` template created
  - [x] Keystore generation documented (requires JDK)
  - [x] Signing config in build.gradle
  - [x] `.gitignore` updated to protect secrets

---

## ✅ Phase 2: Core App Enhancements (COMPLETED)

- [x] **Error Handling & Monitoring**
  - [x] Firebase Crashlytics integrated
  - [x] Global error handlers in `main.dart`
  - [x] Analytics initialized

- [x] **Data Deletion Feature (GDPR)**
  - [x] `deleteUserAccount()` in FirestoreService
  - [x] `deleteAccount()` in FirebaseService
  - [x] Complete account deletion workflow

---

## ✅ Phase 3: Legal & Compliance (COMPLETED)

- [x] **Privacy Policy** (`docs/privacy_policy.md`)
  - [x] GDPR compliant
  - [x] Health data disclosure
  - [x] Third-party services listed (Firebase)
  - [x] User rights explained
  - [x] Data retention policy
  - [x] Contact information

- [x] **Terms of Service** (`docs/terms_of_service.md`)
  - [x] Medical disclaimer (NOT a medical device)
  - [x] User responsibilities
  - [x] Liability limitations
  - [x] Termination clauses
  - [x] Dispute resolution

- [x] **Data Safety Documentation** (`docs/data_safety.md`)
  - [x] All collected data types documented
  - [x] Third-party sharing disclosed
  - [x] Security measures listed
  - [x] User deletion rights explained
  - [x] Play Console form responses prepared

---

## ✅ Phase 4: Play Store Assets (MOSTLY COMPLETED)

- [x] **App Icons**
  - [x] High-res icon (512x512) generated
  - [x] Notification icon (white silhouette) generated
  - [ ] Icons integrated into `android/app/src/main/res/mipmap-*` folders

- [x] **Feature Graphic**
  - [x] 1024x500 banner created
  - [x] Professional design with branding

- [x] **Store Listing Texts** (`play_store/store_listing_texts.md`)
  - [x] App name & descriptions (English)
  - [x] German translations
  - [x] Release notes
  - [x] SEO keywords
  - [x] Content rating info

- [/] **Screenshots**
  - [ ] Dashboard screenshot
  - [ ] Reminders screenshot
  - [ ] Price tracking screenshot
  - [ ] Profile screenshot
  - **NOTE**: Requires running app to capture

---

## 🔄 Phase 5: Testing & Quality (PENDING)

- [ ] **Unit Tests**
  - [ ] Service tests
  - [ ] Model tests
  - [ ] Utility tests

- [ ] **Widget Tests**
  - [ ] UI component tests
  - [ ] Navigation tests

- [ ] **Integration Tests**
  - [ ] User flow tests
  - [ ] Firebase integration tests

- [ ] **Manual Testing**
  - [ ] Test on real Android device
  - [ ] Verify all features work
  - [ ] Test notifications
  - [ ] Test account deletion

---

## 🚀 Phase 6: Build & Deploy (PENDING)

### Prerequisites

- [ ] **Java Development Kit (JDK) installed**
  - Required for: Keystore generation, building AAB
  - Version: JDK 11 or higher
  - Download: https://adoptium.net/

- [ ] **Flutter dependencies installed**
  ```bash
  flutter pub get
  ```

- [ ] **Firebase fully configured**
  - [ ] `google-services.json` in `android/app/`
  - [ ] `firebase_options.dart` configured
  - [ ] Firebase project created
  - [ ] Authentication enabled
  - [ ] Firestore created
  - [ ] FCM enabled

### Build Steps

1. **Generate Production Keystore**
   ```bash
   cd android/app
   keytool -genkey -v -keystore upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   - [ ] Keystore generated
   - [ ] `key.properties` updated with real credentials
   - [ ] Keystore backed up securely

2. **Build Release AAB**
   ```bash
   flutter build appbundle --release
   ```
   - [ ] Build successful
   - [ ] AAB located at `build/app/outputs/bundle/release/app-release.aab`
   - [ ] AAB size reasonable (< 150MB)

3. **Test AAB**
   ```bash
   bundletool build-apks --bundle=app-release.aab --output=app.apks --mode=universal
   bundletool install-apks --apks=app.apks
   ```
   - [ ] App installs successfully
   - [ ] All features work in release mode
   - [ ] No crashes on startup

---

## 📱 Phase 7: Play Console Setup (PENDING)

### Account Setup

- [ ] **Google Play Console account created** ($25 fee)
- [ ] **Developer profile completed**
  - [ ] Developer name
  - [ ] Email address
  - [ ] Website (optional)

### Create Application

- [ ] **App created in Play Console**
  - [ ] App name: LensGuard
  - [ ] Default language: English or German
  - [ ] App/Game: App
  - [ ] Free/Paid: Free

### Store Listing

- [ ] **Main Store Listing completed**
  - [ ] App name
  - [ ] Short description (80 chars)
  - [ ] Full description (4000 chars)
  - [ ] App icon (512x512)
  - [ ] Feature graphic (1024x500)
  - [ ] Screenshots (minimum 2)
  - [ ] Category: Health & Fitness
  - [ ] Contact email
  - [ ] Privacy policy URL (must be publicly hosted!)

### App Content

- [ ] **Privacy Policy** 
  - [ ] Hosted at public URL
  - [ ] URL added to Play Console
  - [ ] Accessible without login

- [ ] **Data Safety**
  - [ ] Form completed (use `docs/data_safety.md`)
  - [ ] All data collection disclosed
  - [ ] Third-party sharing declared
  - [ ] Security measures confirmed
  - [ ] Deletion method provided

- [ ] **Content Rating**
  - [ ] Questionnaire completed
  - [ ] Rating received (expected: PEGI 3 / Everyone)

- [ ] **Target Audience**
  - [ ] Age groups selected (18+)
  - [ ] Appeal to children: No
  - [ ] Store presence: Main store

- [ ] **App Access**
  - [ ] Special access requirements declared
  - [ ] Test account provided (if login required)
  - [ ] Instructions for reviewers

### Release Setup

- [ ] **Internal Testing** (recommended first)
  - [ ] Testing track created
  - [ ] AAB uploaded
  - [ ] Release notes written
  - [ ] Internal testers added
  - [ ] Release started

- [ ] **Production Release**
  - [ ] AAB uploaded
  - [ ] Release notes written (all languages)
  - [ ] Rollout percentage selected (start with 10-20%)
  - [ ] Countries/regions selected
  - [ ] Submitted for review

---

## 📋 Pre-Submission Checklist

**Before clicking "Submit for Review":**

### Technical

- [ ] App builds successfully in release mode
- [ ] No debug code or logging in release
- [ ] All features tested on real device
- [ ] Notifications work correctly
- [ ] Firebase integration works
- [ ] Account deletion works
- [ ] No crashes or major bugs
- [ ] App size is reasonable
- [ ] ProGuard doesn't break functionality

### Assets

- [ ] All images meet size requirements
- [ ] Screenshots show actual app (not mockups)
- [ ] No placeholder text in screenshots
- [ ] Feature graphic is eye-catching
- [ ] App icon is clear at all sizes
- [ ] All text is professional and error-free

### Legal & Compliance

- [ ] Privacy policy is publicly accessible
- [ ] Privacy policy URL works
- [ ] Terms of Service complete
- [ ] Data Safety form accurate and complete
- [ ] Medical disclaimer included
- [ ] GDPR compliance verified
- [ ] User data deletion available

### Store Listing

- [ ] App name is correct
- [ ] Descriptions are compelling
- [ ] Category is appropriate
- [ ] Keywords are relevant
- [ ] Contact information is correct
- [ ] Support email is monitored
- [ ] Release notes are clear

---

## 🎯 Post-Launch Checklist

**After app is live:**

### Week 1
- [ ] Monitor crash reports (Crashlytics)
- [ ] Check Play Console crash analytics
- [ ] Respond to user reviews
- [ ] Monitor app ratings
- [ ] Check Analytics for usage patterns
- [ ] Verify notifications are working
- [ ] Test on additional devices if needed

### Ongoing
- [ ] Weekly review monitoring
- [ ] Monthly analytics review
- [ ] Update app every 2-3 months
- [ ] Address critical bugs immediately
- [ ] Plan new features based on feedback
- [ ] Keep dependencies updated
- [ ] Monitor Play Policy changes

---

## 🔧 Troubleshooting Common Issues

### Build Issues

**Problem**: `keytool` not found
- **Solution**: Install JDK 11+ and add to PATH

**Problem**: Build fails with Firebase errors
- **Solution**: Verify `google-services.json` is in `android/app/`

**Problem**: R8/ProGuard breaks app
- **Solution**: Add keep rules in `proguard-rules.pro`

### Play Console Issues

**Problem**: "Privacy policy not accessible"
- **Solution**: Host on public URL (GitHub Pages, Firebase Hosting, or website)

**Problem**: "Upload rejected - duplicate version"
- **Solution**: Increment versionCode in `pubspec.yaml`

**Problem**: "App not using target API level 34"
- **Solution**: Verify `targetSdk = 34` in `android/app/build.gradle`

### Review Rejection Reasons

Common reasons and solutions:

1. **Insufficient screenshots**
   - Upload at least 2, recommended 4-8

2. **Privacy policy issues**
   - Ensure it's comprehensive and publicly accessible

3. **Misleading description**
   - Be accurate about app functionality
   - Don't claim medical benefits

4. **Data Safety inaccuracies**
   - Declare ALL data collection honestly

5. **App crashes on startup**
   - Test thoroughly before submission

---

## 📚 Resources

### Documentation
- **Google Play Console**: https://play.google.com/console
- **Flutter Deployment**: https://docs.flutter.dev/deployment/android
- **Firebase Setup**: https://firebase.google.com/docs/flutter/setup
- **Play Console Help**: https://support.google.com/googleplay/android-developer

### Tools
- **Bundletool**: https://github.com/google/bundletool
- **Android Studio**: https://developer.android.com/studio
- **Firebase Console**: https://console.firebase.google.com

### Project Files
- **Deployment Guide**: `DEPLOYMENT_GUIDE.md`
- **Privacy Policy**: `docs/privacy_policy.md`
- **Terms of Service**: `docs/terms_of_service.md`
- **Data Safety**: `docs/data_safety.md`
- **Store Listing**: `play_store/store_listing_texts.md`
- **Assets Guide**: `play_store/README.md`

---

## ✉️ Need Help?

**Before submitting:**
1. Review all checklist items above
2. Test on a real Android device
3. Have someone else review your store listing
4. Double-check all URLs are accessible

**Contacts:**
- Technical issues: dev@lensguard.app
- Legal questions: legal@lensguard.app
- General support: support@lensguard.app

---

**Last Updated**: December 10, 2024  
**App Version**: 1.0.0  
**Status**: Ready for build phase (JDK required)

**Estimated Time to Launch**: 1-2 weeks (including testing and review)
