# LensGuard

A smart assistant mobile app for contact lens wearers built with Flutter and Firebase.

## Features

### 🏥 Health Reminders
- Daily notifications for lens insertion (morning) and removal (evening)
- Customizable notification times
- Persistent reminders even when the app is closed
- Uses Flutter Local Notifications for on-device scheduling

### ⏱️ Wear-Time Tracking
- Tracks the age of your current lens pair
- Visual progress indicator (e.g., "Day 4 of 14")
- Automatic notifications when it's time for a new pair
- Simple "Started a New Pair" button to reset the counter

### 💰 Price Tracking & Alerts
- Monitors prices from multiple retailers
- Sends push notifications when prices drop
- Based on your exact prescription (diopter)
- Real-time price comparison across retailers
- Get the best deals on your specific lens type

### 👤 User Profile
- Secure authentication (Email/Password & Google Sign-In)
- Store your lens prescription details
- Personalized settings and preferences
- Sync data across devices with Firebase

## Technology Stack

### Frontend
- **Flutter** (latest stable)
- **Dart** programming language
- **Material Design 3** UI components
- **Provider** for state management

### Backend (BaaS)
- **Firebase** for backend services
- **Firestore** for data storage
- **Firebase Authentication** for user management
- **Firebase Cloud Messaging (FCM)** for push notifications
- **Cloud Functions** for backend logic

### Key Packages
- `firebase_core` - Firebase integration
- `firebase_auth` - Authentication
- `cloud_firestore` - Firestore database
- `firebase_messaging` - Push notifications
- `google_sign_in` - Google Sign-In integration
- `flutter_local_notifications` - Local notifications
- `provider` - State management

## Project Structure

The app follows a **feature-first** directory structure:

```
lib/
├── features/
│   ├── authentication/         # Login & Signup
│   ├── onboarding/            # Initial user profile setup
│   ├── dashboard/             # Main app dashboard
│   ├── reminders/             # Daily reminder settings
│   ├── wear_tracking/         # Lens wear time tracking
│   └── price_tracking/        # Price alerts & tracking
├── models/                    # Data models
│   ├── user.dart             # User model
│   └── lens_price_entry.dart # Price catalog model
├── services/                  # Business logic
│   ├── firebase_service.dart # Firebase operations
│   ├── firestore_service.dart # Firestore data access
│   └── notification_service.dart # Notification management
├── utils/                     # Utilities & constants
│   ├── app_config.dart       # App configuration
│   └── constants.dart        # App constants
└── main.dart                 # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Firebase project
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ContactLensesApp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project at https://console.firebase.google.com
   - Add Android and iOS apps to your project
   - Download configuration files:
     - `google-services.json` → `android/app/`
     - `GoogleService-Info.plist` → `ios/Runner/`
   - Update API keys in `lib/firebase_options.dart`

4. **Enable Authentication**
   - In Firebase Console, go to Authentication > Sign-in method
   - Enable Email/Password authentication
   - Enable Google Sign-In

5. **Set up Firestore**
   - Create Firestore database
   - Configure security rules (see Firestore Rules section below)

6. **Run the app**
   ```bash
   flutter run
   ```

## Firestore Security Rules

Apply these rules to secure your Firestore database:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Price catalog is read-only for users
    match /price_catalog/{document} {
      allow read: if true;
      allow write: if false; // Only via Cloud Functions
    }
  }
}
```

## Cloud Functions (Backend Logic)

The app uses Firebase Cloud Functions for:

1. **Price Scraping** (runs every 6 hours)
   - Scrapes retailer websites
   - Populates `price_catalog` collection
   - Identifies product matches

2. **Price Matching & Alerting**
   - Matches user preferences with price catalog
   - Sends FCM push notifications for price drops
   - Updates user price targets

Example Cloud Function structure:

```javascript
// functions/src/priceScraper.js
exports.scrapePrices = functions.pubsub
  .schedule('every 6 hours')
  .onRun(async (context) => {
    // Scraping logic here
  });
```

## Data Models

### User Model
```dart
{
  uid: String,
  email: String,
  diopter_left: String,  // e.g., "-1.50"
  diopter_right: String, // e.g., "-1.75"
  preferred_lens_brand: String,  // e.g., "Acuvue Oasys"
  preferred_lens_model: String,  // e.g., "14-Day"
  fcm_token: String,
  last_notified_price: double,
  current_pair_start_date: Timestamp,
  created_at: Timestamp
}
```

### Price Catalog Model
```dart
{
  id: String,  // e.g., "acuvue_oasys_14day"
  brand: String,
  model: String,
  prices: [
    {
      shop: String,
      diopter: String,
      price: double,
      last_checked: Timestamp
    }
  ],
  last_updated: Timestamp
}
```

## Key Features Implementation

### 1. Daily Reminders
- Uses `flutter_local_notifications` for on-device scheduling
- Persistent across app restarts and device reboots
- Configurable times for morning and evening reminders

### 2. Wear-Time Tracking
- Timestamp-based tracking
- Calculates days from `current_pair_start_date`
- Visual progress indicator
- Automatic expiration notification

### 3. Price Alerts
- Backend price scraping via Cloud Functions
- Real-time price comparison
- Push notifications for price drops
- User-specific matching based on prescription

## Development

### Running Tests
```bash
flutter test
```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Architecture Decisions

### Why Flutter?
- Single codebase for iOS and Android
- Fast development and hot reload
- Great performance and native feel
- Strong Firebase integration

### Why Firestore?
- Real-time data synchronization
- Offline support
- Scalable NoSQL database
- Integrated with Firebase Auth

### Why feature-first structure?
- Easy to navigate and maintain
- Scalable as the app grows
- Clear separation of concerns
- Team-friendly organization

## Roadmap

- [ ] Add prescription upload/OCR
- [ ] Lens care tips and guides
- [ ] Appointment reminders
- [ ] Insurance tracking
- [ ] Bulk order discounts
- [ ] Dark mode support
- [ ] Apple Watch companion app

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Open an issue on GitHub
- Contact: support@lensguard.app

## Acknowledgments

- Flutter team for the amazing framework
- Firebase team for backend services
- All contributors who help improve this project
