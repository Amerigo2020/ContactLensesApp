import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/firestore_service.dart';
import '../../../models/user.dart';
import '../../../models/lens_price_entry.dart';

class PriceTrackingScreen extends StatefulWidget {
  const PriceTrackingScreen({super.key});

  @override
  State<PriceTrackingScreen> createState() => _PriceTrackingScreenState();
}

class _PriceTrackingScreenState extends State<PriceTrackingScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final User? _user = FirebaseAuth.instance.currentUser;
  UserProfile? _userProfile;
  List<LensPriceCatalog> _priceCatalogs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (_user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      _firestoreService.streamUser(_user!.uid).listen((user) {
        setState(() {
          _userProfile = user;
        });
      });

      _firestoreService.streamPriceCatalog().listen((snapshot) {
        final catalogs = snapshot.docs
            .map((doc) => LensPriceCatalog.fromDocument(doc))
            .toList();

        setState(() {
          _priceCatalogs = catalogs;
        });
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Tracking'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_userProfile != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Lens Profile',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Brand: ${_userProfile!.preferredLensBrand ?? 'Not set'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Model: ${_userProfile!.preferredLensModel ?? 'Not set'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Diopters: ${_userProfile!.diopterLeft ?? ''} / ${_userProfile!.diopterRight ?? ''}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_userProfile != null) ...[
                      const Text(
                        'Best Prices for Your Lenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._buildPriceCards(),
                    ] else ...[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Complete your lens profile to see prices',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/profile');
                                },
                                child: const Text('Update Profile'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'How Price Alerts Work',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '• We scan multiple retailers every 6 hours\n'
                              '• You\'ll get a notification when prices drop\n'
                              '• Alerts are based on your exact prescription\n'
                              '• We check the specific brand and model you use\n'
                              '• Never miss a great deal again!',
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
            ),
    );
  }

  List<Widget> _buildPriceCards() {
    if (_userProfile?.preferredLensBrand == null ||
        _userProfile?.preferredLensModel == null) {
      return [];
    }

    final matchingCatalogs = _priceCatalogs.where((catalog) {
      return catalog.brand == _userProfile!.preferredLensBrand &&
          catalog.model == _userProfile!.preferredLensModel;
    }).toList();

    if (matchingCatalogs.isEmpty) {
      return [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No price data available for your lens type',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
        ),
      ];
    }

    return matchingCatalogs.map((catalog) {
      final leftPrice = _userProfile!.diopterLeft != null
          ? catalog.getPriceForDiopter(_userProfile!.diopterLeft!)
          : null;
      final rightPrice = _userProfile!.diopterRight != null
          ? catalog.getPriceForDiopter(_userProfile!.diopterRight!)
          : null;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                catalog.brand,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                catalog.model,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              if (leftPrice != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Left Eye (${_userProfile!.diopterLeft})'),
                    Text(
                      '€${leftPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
              if (rightPrice != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Right Eye (${_userProfile!.diopterRight})'),
                    Text(
                      '€${rightPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Best Overall Price'),
                  Text(
                    '€${catalog.getLowestPrice().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Last updated: ${_formatDate(catalog.lastUpdated.toDate())}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
