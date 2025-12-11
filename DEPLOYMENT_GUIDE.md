# LensGuard App Deployment Guide

## Prerequisites

Before you can build and deploy the LensGuard app to the Google Play Store, ensure you have:

1. **Flutter SDK** installed (latest stable version)
2. **Java Development Kit (JDK)** 11 or higher
3. **Android Studio** or Android SDK command-line tools
4. **Firebase Project** fully configured
5. **Google Play Console** account ($25 one-time registration fee)

## Step 1: Generate Production Keystore

⚠️ **IMPORTANT**: The current keystore is for DEVELOPMENT ONLY. For production, generate a secure keystore:

```bash
# Navigate to android/app directory
cd android/app

# Generate production keystore
keytool -genkey -v -keystore upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# You will be prompted for:
# - Keystore password (choose a strong password)
# - Key password (can be same as keystore password)
# - Your name, organization, city, state, country

# CRITICAL: Store your passwords securely!
# You cannot recover them if lost, and you cannot update your app without them!
```

### Update key.properties

Edit `android/key.properties` with your production credentials:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

⚠️ **Security Notes**:
- NEVER commit `key.properties` or `*.jks` files to git (already in .gitignore)
- Store keystore file and passwords in a secure location (password manager, encrypted drive)
- Create a backup of your keystore - losing it means you cannot update your app!

## Step 2: Install Dependencies

```bash
# From project root
flutter pub get

# Verify Flutter installation
flutter doctor

# Ensure Android toolchain is properly set up
```

## Step 3: Build Release AAB

Google Play requires Android App Bundle (.aab) format since August 2021:

```bash
# Build release app bundle
flutter build appbundle --release

# Output location:
# build/app/outputs/bundle/release/app-release.aab
```

### Verify Build

```bash
# Install bundletool (if not already installed)
# Download from: https://github.com/google/bundletool/releases

# Generate APKs from AAB for testing
java -jar bundletool.jar build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=app.apks --mode=universal

# Install on connected device
java -jar bundletool.jar install-apks --apks=app.apks
```

## Step 4: Prepare Play Store Assets

### Required Assets

1. **App Icon** (already in project, but verify):
   - Location: `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - Sizes: hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi
   - High-res icon: 512x512 PNG (upload to Play Console)

2. **Screenshots** (minimum 2, maximum 8):
   - Phone: minimum 320px on shortest side
   - Recommended: 1080x1920 (portrait) or 1920x1080 (landscape)
   - Show key features: Dashboard, Reminders, Price Tracking, Profile

3. **Feature Graphic**:
   - Size: 1024x500 pixels
   - PNG or JPEG format
   - Showcases app name and key benefit

4. **Privacy Policy**:
   - Host on publicly accessible URL
   - Include in Play Console listing
   - See `docs/privacy_policy.md`

### Create Screenshots

```bash
# Run app on emulator or physical device
flutter run --release

# Use Android Studio's screenshot tool or:
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png

# Take screenshots of:
# 1. Splash/Login screen
# 2. Dashboard with wear tracking
# 3. Reminder settings
# 4. Price tracking/alerts
# 5. User profile
```

## Step 5: Google Play Console Setup

### Create Application

1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app"
3. Fill in:
   - App name: **LensGuard**
   - Default language: German / English
   - App or game: **App**
   - Free or paid: **Free** (or Paid if monetizing)
4. Accept declarations

### Store Listing

Navigate to **Store presence > Main store listing**:

**App name**: LensGuard

**Short description** (80 chars max):
```
Smart contact lens assistant - reminders, wear tracking & price alerts
```

**Full description** (4000 chars max):
```
LensGuard is your personal contact lens assistant that helps you maintain healthy lens-wearing habits and save money.

🏥 HEALTH REMINDERS
• Daily notifications for lens insertion and removal
• Customizable reminder times for your schedule
• Never forget to take out your lenses before bed

⏱️ WEAR-TIME TRACKING
• Track the age of your current lens pair
• Visual progress indicator (e.g., "Day 4 of 14")
• Automatic alerts when it's time for a new pair
• Simple reset button when you start fresh lenses

💰 PRICE TRACKING & ALERTS
• Monitor prices from multiple retailers
• Get notified when prices drop
• Based on your exact prescription
• Real-time price comparison
• Find the best deals for your specific lens type

👤 SECURE PROFILE
• Store lens prescription details safely
• Sync data across devices
• Privacy-focused design
• Google Sign-In supported

PERFECT FOR:
✓ Daily disposable wearers
✓ 2-week / monthly lens users
✓ Anyone who wants to save money on contacts
✓ People who forget to remove their lenses

YOUR DATA, YOUR CONTROL:
• All health data encrypted and secured with Firebase
• GDPR compliant
• Account deletion available anytime
• No data sold to third parties

Download LensGuard today and take control of your contact lens routine!
```

**App category**: Medical (or Health & Fitness)

**Contact details**:
- Email: support@lensguard.app (or your email)
- Website (optional): Your website URL
- Phone (optional)

### Upload Assets

1. **High-res icon**: 512x512 PNG
2. **Feature graphic**: 1024x500 PNG
3. **Phone screenshots**: Upload 2-8 images
4. **7-inch tablet screenshots** (optional but recommended)
5. **10-inch tablet screenshots** (optional)

### Privacy Policy

**Privacy Policy URL**: 
```
https://yourdomain.com/privacy-policy
```

Host the `docs/privacy_policy.md` content on a public URL. Options:
- GitHub Pages
- Firebase Hosting
- Your own website

## Step 6: Content Rating

Navigate to **Policy > App content > Content rating**:

1. Click "Start questionnaire"
2. Enter email address
3. Select category: **Utility, Productivity, Communication, or Other**
4. Answer questions honestly:
   - Violence: No
   - Sexual content: No
   - Language: No
   - Drugs, alcohol, tobacco: No
   - Gambling: No
   - Controlled substances: No

5. Submit and receive rating (usually PEGI 3, Everyone)

## Step 7: Target Audience & Content

Navigate to **Policy > App content > Target audience**:

1. **Target age groups**: 18 and over (health data)
2. **Appeal to children**: No
3. **Store presence**: Main store only

## Step 8: Data Safety

Navigate to **Policy > App content > Data safety**:

⚠️ **Critical section** - Answer truthfully based on your app's behavior:

### Data Collection

**Does your app collect or share user data?**: Yes

**Data types collected**:
1. **Personal Info**:
   - ✓ Email address
   - ✓ Name (if collected)

2. **Health & Fitness**:
   - ✓ Health info (contact lens prescription)

3. **App activity**:
   - ✓ App interactions

**Data usage**:
- App functionality
- Analytics
- Personalization

**Data security**:
- ✓ Data is encrypted in transit (HTTPS)
- ✓ Data is encrypted at rest (Firebase)
- ✓ Users can request data deletion
- ✓ You follow the Families Policy (if targeting children - NOT recommended)

**Data retention and deletion**:
- Users can request account deletion through app settings
- Data deleted within 30 days of request

## Step 9: App Access

If your app requires login (it does):

1. Provide test account credentials for Google reviewers:
   ```
   Email: test@lensguard.app
   Password: TestAccount123!
   ```

2. Or enable sign-up during review

## Step 10: Create Release

Navigate to **Release > Production** (or start with **Internal testing**):

### Recommended: Start with Internal Testing

1. **Production > Internal testing > Create new release**
2. Upload `app-release.aab`
3. Release name: `1.0.0 (1)` - Initial Release
4. Release notes (in all supported languages):
   ```
   🎉 Welcome to LensGuard v1.0!

   Features:
   • Daily lens insertion/removal reminders
   • Wear-time tracking for your lens pairs
   • Price alerts from multiple retailers
   • Secure profile with prescription storage
   • Google Sign-In support

   This is our initial release. We'd love your feedback!
   ```

5. Add internal testers (email addresses)
6. Save and review release
7. **Start rollout to Internal testing**

### Test Internal Release

1. Testers receive invitation email
2. Install app via Play Store link
3. Test all features for 1-2 weeks
4. Gather feedback and fix bugs

### Promote to Production

Once testing is complete:

1. Navigate to **Production > Create new release**
2. Promote internal testing release or upload same AAB
3. Choose rollout percentage:
   - Start with 10% rollout
   - Monitor crash reports and reviews
   - Increase to 50%, then 100%

4. Release notes (localize if supporting multiple languages)
5. **Start rollout to Production**

## Step 11: Pre-Launch Report

After upload, Google automatically tests your app:

- Tests on various devices
- Checks for crashes
- Security scans
- Accessibility checks

Review results and fix any critical issues before publishing.

## Step 12: Review & Publish

1. Review all sections for completion (green checkmarks)
2. Submit for review
3. Review process typically takes 1-7 days
4. You'll receive email when approved or if changes needed

## Post-Launch Checklist

After your app is live:

- [ ] Monitor crash reports in Firebase Crashlytics
- [ ] Check Play Console crash reports
- [ ] Monitor user reviews and ratings
- [ ] Track analytics in Firebase Analytics
- [ ] Respond to user reviews (especially critical ones)
- [ ] Plan updates and new features
- [ ] Monitor app size and performance metrics

## Version Updates

For future updates:

```bash
# Update version in pubspec.yaml
# version: 1.1.0+2  (version name + build number)

# Build new AAB
flutter build appbundle --release

# Create new release in Play Console
# Upload new AAB
# Write release notes
# Start phased rollout
```

## Troubleshooting

### Build Failures

**Issue**: `Execution failed for task ':app:lintVitalRelease'`
```bash
# Disable lint errors temporarily (not recommended for production)
# Add to android/app/build.gradle:
android {
    lintOptions {
        checkReleaseBuilds false
    }
}
```

**Issue**: `Keystore file not found`
```bash
# Verify key.properties path is correct
# Ensure upload-keystore.jks is in android/app/
```

**Issue**: `Google services plugin could not detect`
```bash
# Ensure google-services.json is in android/app/
# Verify Firebase project is properly configured
```

### Play Console Issues

**Issue**: Upload rejected - "Duplicate APK"
- Increase versionCode in pubspec.yaml

**Issue**: "App not using correct target API"
- Verify targetSdk = 34 in android/app/build.gradle

**Issue**: "Missing privacy policy"
- Ensure Privacy Policy URL is public and accessible

## Security Best Practices

1. **Never commit**:
   - ✗ Keystore files (*.jks)
   - ✗ key.properties
   - ✗ API keys (use environment variables or Firebase App Check)

2. **Use environment-specific configs**:
   - Separate Firebase projects for dev/staging/production
   - Different google-services.json for each environment

3. **Enable Play App Signing**:
   - Let Google manage your signing key
   - You keep upload key
   - Google re-signs with app signing key
   - Provides extra security layer

4. **Regular security updates**:
   - Monitor dependency vulnerabilities
   - Update Flutter and packages regularly
   - Review Firebase security rules

## Resources

- [Google Play Console](https://play.google.com/console)
- [Flutter Deployment Guide](https://docs.flutter.dev/deployment/android)
- [Android App Bundles](https://developer.android.com/guide/app-bundle)
- [Firebase Console](https://console.firebase.google.com)
- [Play Console Help](https://support.google.com/googleplay/android-developer)

## Support

For deployment issues:
- Create issue in project repository
- Email: dev@lensguard.app
- Check Flutter documentation
- Review Play Console help center

---

**Next Steps**: Proceed to creating legal documents and Play Store assets in the `/docs` and `/play_store` directories.
