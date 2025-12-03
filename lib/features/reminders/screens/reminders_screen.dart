import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../services/notification_service.dart';
import '../../../utils/app_config.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _morningEnabled = false;
  bool _eveningEnabled = false;
  TimeOfDay _morningTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 22, minute: 0);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // In a real app, load from SharedPreferences
    // For now, using default values
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await NotificationService.cancelNotification(AppConfig.morningReminderId);
      await NotificationService.cancelNotification(AppConfig.eveningReminderId);

      if (_morningEnabled) {
        await NotificationService.scheduleDailyReminder(
          AppConfig.morningReminderId,
          'LensGuard Reminder',
          'Time to insert your contact lenses!',
          _morningTime,
        );
      }

      if (_eveningEnabled) {
        await NotificationService.scheduleDailyReminder(
          AppConfig.eveningReminderId,
          'LensGuard Reminder',
          'Time to remove your contact lenses!',
          _eveningTime,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reminders saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving reminders: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectTime(bool isMorning) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? _morningTime : _eveningTime,
    );

    if (picked != null && mounted) {
      setState(() {
        if (isMorning) {
          _morningTime = picked;
        } else {
          _eveningTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Reminders'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny, color: Colors.orange),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Morning Reminder',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Switch(
                          value: _morningEnabled,
                          onChanged: (value) {
                            setState(() {
                              _morningEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_morningEnabled)
                      Row(
                        children: [
                          const Text('Time: '),
                          TextButton.icon(
                            onPressed: () => _selectTime(true),
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              '${_morningTime.hour.toString().padLeft(2, '0')}:${_morningTime.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Get notified when it\'s time to insert your lenses',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.nightlight_round, color: Colors.indigo),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Evening Reminder',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Switch(
                          value: _eveningEnabled,
                          onChanged: (value) {
                            setState(() {
                              _eveningEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_eveningEnabled)
                      Row(
                        children: [
                          const Text('Time: '),
                          TextButton.icon(
                            onPressed: () => _selectTime(false),
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              '${_eveningTime.hour.toString().padLeft(2, '0')}:${_eveningTime.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Get notified when it\'s time to remove your lenses',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveSettings,
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Save Reminders'),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Reminders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Reminders will be sent daily at the specified time\n'
                      '• Reminders work even when the app is closed\n'
                      '• You can disable or modify reminders at any time\n'
                      '• Make sure to allow notifications in your device settings',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
