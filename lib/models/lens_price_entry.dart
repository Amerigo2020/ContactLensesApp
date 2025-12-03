import 'package:cloud_firestore/cloud_firestore.dart';

class PriceEntry {
  final String shop;
  final String diopter;
  final double price;
  final Timestamp lastChecked;

  PriceEntry({
    required this.shop,
    required this.diopter,
    required this.price,
    required this.lastChecked,
  });

  factory PriceEntry.fromMap(Map<String, dynamic> map) {
    return PriceEntry(
      shop: map['shop'] ?? '',
      diopter: map['diopter'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      lastChecked: map['last_checked'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shop': shop,
      'diopter': diopter,
      'price': price,
      'last_checked': lastChecked,
    };
  }
}

class LensPriceCatalog {
  final String id;
  final String brand;
  final String model;
  final List<PriceEntry> prices;
  final Timestamp lastUpdated;

  LensPriceCatalog({
    required this.id,
    required this.brand,
    required this.model,
    required this.prices,
    required this.lastUpdated,
  });

  factory LensPriceCatalog.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final pricesList = data['prices'] as List<dynamic>? ?? [];
    return LensPriceCatalog(
      id: doc.id,
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      prices: pricesList
          .map((priceMap) => PriceEntry.fromMap(priceMap as Map<String, dynamic>))
          .toList(),
      lastUpdated: data['last_updated'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'prices': prices.map((price) => price.toMap()).toList(),
      'last_updated': lastUpdated,
    };
  }

  double? getPriceForDiopter(String diopter) {
    try {
      final matchingEntry = prices.firstWhere(
        (entry) => entry.diopter == diopter,
      );
      return matchingEntry.price;
    } catch (e) {
      return null;
    }
  }

  double getLowestPrice() {
    if (prices.isEmpty) return 0.0;
    return prices.map((entry) => entry.price).reduce((a, b) => a < b ? a : b);
  }
}
