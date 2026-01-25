import 'package:flutter/material.dart';
import '../../../widgets/empty_state.dart';

class PriceTrackingScreen extends StatelessWidget {
  const PriceTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Tracking'),
      ),
      body: const EmptyState(
        icon: Icons.price_check,
        title: 'Price Tracking Coming Soon',
        description:
            'We\'re working on bringing you the best prices for your contact lenses. Stay tuned!',
      ),
    );
  }
}
