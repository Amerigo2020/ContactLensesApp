import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_button.dart';

class WearTimeCard extends StatelessWidget {
  const WearTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final authProvider = context.watch<AuthProvider>();

    // Mock data for now - in real app, this comes from Firestore
    final daysWorn = 4;
    final totalDays = userProvider.getExpectedDuration();
    final progress = daysWorn / totalDays;
    final daysRemaining = totalDays - daysWorn;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Lens Pair',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  userProvider.currentUser?.preferredLensModel ?? 'Monthly',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Progress Circle
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 0.8
                          ? Colors.orange
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Day $daysWorn',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'of $totalDays',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Days Remaining
          if (daysRemaining > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: progress >= 0.8
                    ? Colors.orange.withOpacity(0.1)
                    : Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    progress >= 0.8 ? Icons.warning_amber : Icons.info_outline,
                    size: 20,
                    color: progress >= 0.8
                        ? Colors.orange
                        : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    progress >= 0.8
                        ? 'Replace soon! $daysRemaining ${daysRemaining == 1 ? 'day' : 'days'} left'
                        : '$daysRemaining ${daysRemaining == 1 ? 'day' : 'days'} remaining',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: progress >= 0.8
                          ? Colors.orange
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Time to replace your lenses!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Start New Pair Button
          CustomButton(
            text: 'Start New Pair',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Start New Lens Pair?'),
                  content: const Text(
                    'This will reset your wear tracking. Make sure you\'ve actually started a new pair of lenses.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                final uid = authProvider.firebaseUser?.uid;
                if (uid != null) {
                  await userProvider.startNewLensPair(uid);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New lens pair started!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              }
            },
            isLoading: userProvider.isLoading,
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }
}
