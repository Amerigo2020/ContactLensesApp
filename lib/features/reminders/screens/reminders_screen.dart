import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/reminder_provider.dart';
import '../../../widgets/custom_card.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Notification Permission Status
            if (!reminderProvider.hasPermission)
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.warning_amber, color: Colors.orange),
                        SizedBox(width: 12),
                        Text(
                          'Permission Required',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'To receive reminder notifications, please grant notification permissions.',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await reminderProvider.requestPermissions();
                      },
                      child: const Text('Grant Permission'),
                    ),
                  ],
                ),
              ),
            if (!reminderProvider.hasPermission) const SizedBox(height: 16),
            
            // Morning Reminder
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Morning Reminder',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Time to insert your lenses',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: reminderProvider.morningReminderEnabled,
                        onChanged: (value) {
                          reminderProvider.toggleMorningReminder(value);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Time'),
                    trailing: TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: reminderProvider.morningTime,
                        );
                        if (picked != null) {
                          reminderProvider.setMorningTime(picked);
                        }
                      },
                      child: Text(
                        reminderProvider.morningTime.format(context),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Evening Reminder
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.nightlight,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Evening Reminder',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Time to remove your lenses',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: reminderProvider.eveningReminderEnabled,
                        onChanged: (value) {
                          reminderProvider.toggleEveningReminder(value);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Time'),
                    trailing: TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: reminderProvider.eveningTime,
                        );
                        if (picked != null) {
                          reminderProvider.setEveningTime(picked);
                        }
                      },
                      child: Text(
                        reminderProvider.eveningTime.format(context),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
