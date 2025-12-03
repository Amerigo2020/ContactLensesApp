import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/firebase_service.dart';
import '../../../services/firestore_service.dart';
import '../../../models/user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseService _firebaseService = FirebaseService();
  User? _user;
  UserProfile? _userProfile;
  int _currentWearDays = 0;
  int _totalLensDays = 14;
  double? _bestPrice;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _user = user;
    });

    _firebaseService.streamUser(user.uid).listen((profile) async {
      setState(() {
        _userProfile = profile;
      });

      if (profile.preferredLensModel != null) {
        _setTotalLensDays(profile.preferredLensModel!);
      }

      await _loadWearData();
      await _loadBestPrice();
    });
  }

  void _setTotalLensDays(String model) {
    if (model.contains('1-Day')) {
      _totalLensDays = 1;
    } else if (model.contains('7') || model.contains('Weekly')) {
      _totalLensDays = 7;
    } else if (model.contains('14')) {
      _totalLensDays = 14;
    } else if (model.contains('30') || model.contains('Monthly')) {
      _totalLensDays = 30;
    } else {
      _totalLensDays = 14;
    }
  }

  Future<void> _loadWearData() async {
    if (_user == null) return;

    final duration = await _firestoreService.getCurrentLensWearDuration(_user!.uid);
    setState(() {
      _currentWearDays = duration.inDays;
    });
  }

  Future<void> _loadBestPrice() async {
    if (_userProfile?.preferredLensBrand == null ||
        _userProfile?.preferredLensModel == null ||
        _userProfile?.diopterLeft == null) {
      return;
    }

    final price = await _firestoreService.getBestPriceForUser(
      _userProfile!.preferredLensBrand!,
      _userProfile!.preferredLensModel!,
      _userProfile!.diopterLeft!,
    );

    if (mounted) {
      setState(() {
        _bestPrice = price;
      });
    }
  }

  Future<void> _startNewPair() async {
    if (_user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Pair'),
        content: const Text('Are you sure you want to start tracking a new pair of lenses?'),
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
      await _firestoreService.startNewLensPair(_user!.uid);
      await _loadWearData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LensGuard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _firebaseService.signOut();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/auth',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadUserData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_userProfile != null) ...[
                Text(
                  'Hello, ${_user!.email!.split('@')[0]}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _buildWearTimeCard(),
              const SizedBox(height: 16),
              _buildPriceCard(),
              const SizedBox(height: 16),
              _buildQuickActionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWearTimeCard() {
    final progress = (_currentWearDays / _totalLensDays).clamp(0.0, 1.0);
    final isExpired = _currentWearDays >= _totalLensDays;
    final daysLeft = _totalLensDays - _currentWearDays;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timer, color: Color(0xFF2196F3)),
                const SizedBox(width: 8),
                const Text(
                  'Current Pair',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isExpired)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'EXPIRED',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Day $_currentWearDays of $_totalLensDays',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isExpired ? Colors.red : const Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isExpired
                  ? 'Time for a fresh pair of lenses!'
                  : daysLeft == 1
                      ? '1 day left'
                      : '$daysLeft days left',
              style: TextStyle(
                color: isExpired ? Colors.red : Colors.grey[600],
                fontWeight: isExpired ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startNewPair,
                child: const Text('Started a New Pair'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Best Price',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_userProfile?.preferredLensBrand != null)
              Text(
                '${_userProfile!.preferredLensBrand!}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 8),
            if (_bestPrice != null)
              Text(
                '€${_bestPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
            else
              const Text(
                'Loading price...',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 12),
            Text(
              'for your ${_userProfile?.diopterLeft ?? ''} lenses',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.notifications, color: Color(0xFF2196F3)),
              title: const Text('Reminders'),
              subtitle: const Text('Manage daily notifications'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).pushNamed('/reminders');
              },
            ),
            ListTile(
              leading: const Icon(Icons.price_check, color: Colors.green),
              title: const Text('Price Alerts'),
              subtitle: const Text('Set up price notifications'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).pushNamed('/price-tracking');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.purple),
              title: const Text('Profile Settings'),
              subtitle: const Text('Update your lens information'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
