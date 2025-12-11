import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/reminder_provider.dart';
import '../../../widgets/custom_button.dart';

class ReminderSetupScreen extends StatefulWidget {
  const ReminderSetupScreen({super.key});

  @override
  State<ReminderSetupScreen> createState() => _ReminderSetupScreenState();
}

class _ReminderSetupScreenState extends State<ReminderSetupScreen> {
  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 22, minute: 0);

  Future<void> _selectTime(BuildContext context, bool isMorning) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? _morningTime : _eveningTime,
    );

    if (picked != null) {
      setState(() {
        if (isMorning) {
          _morningTime = picked;
        } else {
          _eveningTime = picked;
        }
      });
    }
  }

  Future<void> _continue() async {
    final reminderProvider = context.read<ReminderProvider>();

    // Request notification permissions
    final granted = await reminderProvider.requestPermissions();

    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification permission is required for reminders'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    // Set reminder times
    await reminderProvider.setMorningTime(_morningTime);
    await reminderProvider.setEveningTime(_eveningTime);

    // Schedule notifications
    await reminderProvider.scheduleAllReminders();

    if (mounted) {
      Navigator.of(context).pushNamed('/onboarding/lens-pair');
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminders'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Indicator
              LinearProgressIndicator(
                value: 0.66,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 32),
              
              const Text(
               'Step 2 of 3',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'When should we remind you?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Get daily notifications to maintain healthy lens-wearing habits',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Morning Reminder
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.wb_sunny,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Morning Reminder'),
                  subtitle: const Text('Time to insert your lenses'),
                  trailing: TextButton(
                    onPressed: () => _selectTime(context, true),
                    child: Text(
                      _morningTime.format(context),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Evening Reminder
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.nightlight,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Evening Reminder'),
                  subtitle: const Text('Time to remove your lenses'),
                  trailing: TextButton(
                    onPressed: () => _selectTime(context, false),
                    child: Text(
                      _eveningTime.format(context),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              CustomButton(
                text: 'Continue',
                onPressed: _continue,
                isLoading: reminderProvider.isLoading,
                icon: Icons.arrow_forward,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/onboarding/lens-pair');
                },
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
