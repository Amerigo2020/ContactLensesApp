import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lensguard/models/lens_price_entry.dart';

void main() {
  // ---------------------------------------------------------------------------
  // PriceEntry
  // ---------------------------------------------------------------------------
  group('PriceEntry', () {
    group('fromMap()', () {
      test('parses a complete map correctly', () {
        final now = Timestamp.now();
        final entry = PriceEntry.fromMap({
          'shop': 'Lens4U',
          'diopter': '-2.50',
          'price': 29.99,
          'last_checked': now,
        });

        expect(entry.shop, 'Lens4U');
        expect(entry.diopter, '-2.50');
        expect(entry.price, 29.99);
        expect(entry.lastChecked, now);
      });

      test('defaults shop to empty string when missing', () {
        final entry = PriceEntry.fromMap({
          'diopter': '-1.00',
          'price': 10.0,
          'last_checked': Timestamp.now(),
        });

        expect(entry.shop, '');
      });

      test('defaults diopter to empty string when missing', () {
        final entry = PriceEntry.fromMap({
          'shop': 'Store',
          'price': 10.0,
          'last_checked': Timestamp.now(),
        });

        expect(entry.diopter, '');
      });

      test('defaults price to 0.0 when missing', () {
        final entry = PriceEntry.fromMap({
          'shop': 'Store',
          'diopter': '-1.00',
          'last_checked': Timestamp.now(),
        });

        expect(entry.price, 0.0);
      });

      test('defaults price to 0.0 when null', () {
        final entry = PriceEntry.fromMap({
          'shop': 'Store',
          'diopter': '-1.00',
          'price': null,
          'last_checked': Timestamp.now(),
        });

        expect(entry.price, 0.0);
      });

      test('converts integer price to double', () {
        final entry = PriceEntry.fromMap({
          'shop': 'Store',
          'diopter': '-1.00',
          'price': 25,
          'last_checked': Timestamp.now(),
        });

        expect(entry.price, 25.0);
        expect(entry.price, isA<double>());
      });
    });

    group('toMap()', () {
      test('produces a map with all fields', () {
        final now = Timestamp.now();
        final entry = PriceEntry(
          shop: 'ContactLensKing',
          diopter: '-3.00',
          price: 45.50,
          lastChecked: now,
        );

        final map = entry.toMap();

        expect(map['shop'], 'ContactLensKing');
        expect(map['diopter'], '-3.00');
        expect(map['price'], 45.50);
        expect(map['last_checked'], now);
      });

      test('round-trips through fromMap/toMap', () {
        final now = Timestamp.now();
        final original = PriceEntry(
          shop: 'LensCrafters',
          diopter: '-5.25',
          price: 67.00,
          lastChecked: now,
        );

        final roundTripped = PriceEntry.fromMap(original.toMap());

        expect(roundTripped.shop, original.shop);
        expect(roundTripped.diopter, original.diopter);
        expect(roundTripped.price, original.price);
        expect(roundTripped.lastChecked, original.lastChecked);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // LensPriceCatalog
  // ---------------------------------------------------------------------------
  group('LensPriceCatalog', () {
    late Timestamp now;

    setUp(() {
      now = Timestamp.now();
    });

    LensPriceCatalog makeCatalog({List<PriceEntry>? prices}) {
      return LensPriceCatalog(
        id: 'acuvue_oasys',
        brand: 'Acuvue',
        model: 'Oasys',
        prices: prices ??
            [
              PriceEntry(
                  shop: 'Store A',
                  diopter: '-2.50',
                  price: 29.99,
                  lastChecked: now),
              PriceEntry(
                  shop: 'Store B',
                  diopter: '-2.50',
                  price: 34.99,
                  lastChecked: now),
              PriceEntry(
                  shop: 'Store A',
                  diopter: '-3.00',
                  price: 31.50,
                  lastChecked: now),
            ],
        lastUpdated: now,
      );
    }

    group('getPriceForDiopter()', () {
      test('returns price when diopter matches', () {
        final catalog = makeCatalog();

        // -2.50 appears twice; firstWhere returns the first match (Store A at 29.99)
        expect(catalog.getPriceForDiopter('-2.50'), 29.99);
      });

      test('returns price for a different diopter', () {
        final catalog = makeCatalog();

        expect(catalog.getPriceForDiopter('-3.00'), 31.50);
      });

      test('returns null when diopter is not found', () {
        final catalog = makeCatalog();

        expect(catalog.getPriceForDiopter('-10.00'), isNull);
      });

      test('returns null for empty string diopter when no match', () {
        final catalog = makeCatalog();

        expect(catalog.getPriceForDiopter(''), isNull);
      });

      test('returns null when prices list is empty', () {
        final catalog = makeCatalog(prices: []);

        expect(catalog.getPriceForDiopter('-2.50'), isNull);
      });

      test('returns exact match — does not do partial matching', () {
        final catalog = makeCatalog(prices: [
          PriceEntry(
              shop: 'X', diopter: '-2.5', price: 20.0, lastChecked: now),
        ]);

        // '-2.50' != '-2.5' — exact string comparison
        expect(catalog.getPriceForDiopter('-2.50'), isNull);
        expect(catalog.getPriceForDiopter('-2.5'), 20.0);
      });
    });

    group('getLowestPrice()', () {
      test('returns lowest price across all entries', () {
        final catalog = makeCatalog();

        expect(catalog.getLowestPrice(), 29.99);
      });

      test('returns the price when there is a single entry', () {
        final catalog = makeCatalog(prices: [
          PriceEntry(
              shop: 'Only', diopter: '-1.00', price: 50.0, lastChecked: now),
        ]);

        expect(catalog.getLowestPrice(), 50.0);
      });

      test('returns 0.0 when prices list is empty — documents potentially misleading behavior', () {
        // BUG/RISK: An empty price list returns 0.0, which could display
        // "$0.00" in the UI and mislead users into thinking lenses are free.
        final catalog = makeCatalog(prices: []);

        expect(catalog.getLowestPrice(), 0.0);
      });

      test('handles entries with 0.0 price', () {
        final catalog = makeCatalog(prices: [
          PriceEntry(
              shop: 'Free', diopter: '-1.00', price: 0.0, lastChecked: now),
          PriceEntry(
              shop: 'Paid', diopter: '-1.00', price: 25.0, lastChecked: now),
        ]);

        expect(catalog.getLowestPrice(), 0.0);
      });

      test('handles all same prices', () {
        final catalog = makeCatalog(prices: [
          PriceEntry(
              shop: 'A', diopter: '-1.00', price: 30.0, lastChecked: now),
          PriceEntry(
              shop: 'B', diopter: '-2.00', price: 30.0, lastChecked: now),
          PriceEntry(
              shop: 'C', diopter: '-3.00', price: 30.0, lastChecked: now),
        ]);

        expect(catalog.getLowestPrice(), 30.0);
      });

      test('picks the lowest among many prices', () {
        final catalog = makeCatalog(prices: [
          PriceEntry(
              shop: 'A', diopter: '-1.00', price: 100.0, lastChecked: now),
          PriceEntry(
              shop: 'B', diopter: '-2.00', price: 5.99, lastChecked: now),
          PriceEntry(
              shop: 'C', diopter: '-3.00', price: 50.0, lastChecked: now),
          PriceEntry(
              shop: 'D', diopter: '-4.00', price: 75.0, lastChecked: now),
        ]);

        expect(catalog.getLowestPrice(), 5.99);
      });
    });

    group('toMap()', () {
      test('serializes all fields', () {
        final catalog = makeCatalog();
        final map = catalog.toMap();

        expect(map['brand'], 'Acuvue');
        expect(map['model'], 'Oasys');
        expect(map['prices'], isA<List>());
        expect((map['prices'] as List).length, 3);
        expect(map['last_updated'], now);
      });

      test('serializes nested PriceEntry objects via toMap', () {
        final catalog = makeCatalog(prices: [
          PriceEntry(
              shop: 'TestShop',
              diopter: '-1.00',
              price: 22.0,
              lastChecked: now),
        ]);
        final map = catalog.toMap();
        final pricesList = map['prices'] as List;

        expect(pricesList.length, 1);
        expect(pricesList[0]['shop'], 'TestShop');
        expect(pricesList[0]['diopter'], '-1.00');
        expect(pricesList[0]['price'], 22.0);
      });
    });
  });
}
