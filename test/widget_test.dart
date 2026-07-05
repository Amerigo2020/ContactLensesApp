// Smoke test for a Firebase-free widget; the full app needs a real
// Firebase project and can't be pumped in a plain widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lensguard/widgets/empty_state.dart';

void main() {
  testWidgets('EmptyState renders title and icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.visibility,
            title: 'No lenses yet',
          ),
        ),
      ),
    );

    expect(find.text('No lenses yet'), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });
}
