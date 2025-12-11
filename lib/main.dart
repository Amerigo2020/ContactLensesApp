import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/app_config.dart';
import 'services/notification_service.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/reminder_provider.dart';
import 'features/authentication/screens/login_screen.dart';
import 'features/authentication/screens/signup_screen.dart';
import 'features/authentication/screens/forgot_password_screen.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/onboarding/screens/prescription_setup_screen.dart';
import 'features/onboarding/screens/reminder_setup_screen.dart';
import 'features/onboarding/screens/lens_pair_setup_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/edit_prescription_screen.dart';
import 'features/reminders/screens/reminders_screen.dart';
import 'features/price_tracking/screens/price_tracking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  // Pass all uncaught async errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize Analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);

  // Initialize local notifications
  await NotificationService.initialize();

  runApp(const LensGuardApp());
}

class LensGuardApp extends StatelessWidget {
  const LensGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()..init()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3), // LensGuard Blue
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/onboarding': (context) => const WelcomeScreen(),
          '/onboarding/prescription': (context) => const PrescriptionSetupScreen(),
          '/onboarding/reminders': (context) => const ReminderSetupScreen(),
          '/onboarding/lens-pair': (context) => const LensPairSetupScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/reminders': (context) => const RemindersScreen(),
          '/price-tracking': (context) => const PriceTrackingScreen(),
          '/edit-prescription': (context) => const EditPrescriptionScreen(),
        },
      ),
    );
  }
}

/// Wrapper to handle authentication state and routing
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Show loading while checking auth state
    if (authProvider.firebaseUser == null) {
      return const LoginScreen();
    }

    // Check if user completed onboarding
    final hasCompletedOnboarding = 
        authProvider.userProfile?.diopterLeft != null &&
        authProvider.userProfile?.diopterRight != null;

    if (!hasCompletedOnboarding) {
      return const WelcomeScreen();
    }

    return const DashboardScreen();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate to authentication or dashboard based on login state
    // This will be implemented in the authentication service
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const AuthenticationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.visibility,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              Text(
                'LensGuard',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your Smart Contact Lens Assistant',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 48),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Authentication Screen - To be implemented'),
      ),
    );
  }
}
