import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/firestore_service.dart';
import '../../../services/notification_service.dart';
import '../../../utils/app_config.dart';

class WearTrackingScreen extends StatefulWidget {
  const WearTrackingScreen({super.key});

  @override
  State<WearTrackingScreen> createState() => _WearTrackingScreenState();
}

class _WearTrackingScreenState extends State<WearTrackingScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final User? _user = FirebaseAuth.instance.currentUser;
  int _currentWearDays = 0;
  final int _totalLensDays = 14;
  Timestamp? _startDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWearData();
  }

  Future<void> _loadWearData() async {
    if (_user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();

    final data = doc.data();

    if (data != null && data['current_pair_start_date'] != null) {
      final startDate = data['current_pair_start_date'] as Timestamp;
      final now = DateTime.now();
      final duration = now.difference(startDate.toDate());
      final days = duration.inDays;

      setState(() {
        _startDate = startDate;
        _currentWearDays = days;
      });

      if (days >= _totalLensDays) {
        await NotificationService.scheduleLensReplacementReminder(
          AppConfig.lensReplacementId,
          'LensGuard',
          'Time for a fresh pair of lenses! Your current pair has reached its maximum wear time.',
        );
      }
    }
  }

  Future<void> _startNewPair() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Start New Pair'),
          content: const Text(
            'Are you sure you want to start tracking a new pair of lenses? '
            'This will reset your current wear counter.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .update({
          'current_pair_start_date': FieldValue.serverTimestamp(),
        });

        setState(() {
          _currentWearDays = 0;
          _startDate = Timestamp.now();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New pair tracking started!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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

  @override
  Widget build(BuildContext context) {
    final progress = (_currentWearDays / _totalLensDays).clamp(0.0, 1.0);
    final isExpired = _currentWearDays >= _totalLensDays;
    final daysLeft = _totalLensDays - _currentWearDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wear Tracking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    if (isExpired) ...[
                      Icon(
                        Icons.warning,
                        size: 80,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Replace Your Lenses!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.visibility,
                        size: 80,
                        color: Color(0xFF2196F3),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Current Pair',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      'Day $_currentWearDays of $_totalLensDays',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: isExpired ? Colors.red : const Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isExpired ? Colors.red : const Color(0xFF2196F3),
                      ),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isExpired
                          ? 'Time for a fresh pair!'
                          : daysLeft == 1
                              ? '1 day left'
                              : '$daysLeft days left',
                      style: TextStyle(
                        fontSize: 18,
                        color: isExpired ? Colors.red : Colors.grey[600],
                        fontWeight:
                            isExpired ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (_startDate != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Started: ${_formatDate(_startDate!.toDate())}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                    const Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: Icon(
                        Icons.play_circle,
                        color: Colors.green[600],
                      ),
                      title: const Text('Started a New Pair'),
                      subtitle: const Text('Reset counter for a new pair'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _isLoading ? null : _startNewPair,
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
                    const Text(
                      'Wear Time Guide',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• 1-Day lenses: Replace every day\n'
                      '• Weekly lenses: Replace after 7 days\n'
                      '• 14-Day lenses: Replace after 14 days\n'
                      '• Monthly lenses: Replace after 30 days\n\n'
                      'Never wear lenses longer than recommended!',
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
