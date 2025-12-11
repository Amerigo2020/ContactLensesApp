import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.visibility,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome to LensGuard',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your personal contact lens assistant',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              // Features List
              _buildFeature(
                context,
                Icons.alarm,
                'Daily Reminders',
                'Never forget to insert or remove your lenses',
              ),
              const SizedBox(height: 24),
              _buildFeature(
                context,
                Icons.calendar_today,
                'Wear Tracking',
                'Know exactly when to replace your lenses',
              ),
              const SizedBox(height: 24),
              _buildFeature(
                context,
                Icons.price_check,
                'Price Alerts',
                'Get notified when your lenses go on sale',
              ),
              const SizedBox(height: 60),
              
              CustomButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/onboarding/prescription');
                },
                icon: Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(BuildContext context, IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
