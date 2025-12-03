class AppConfig {
  static const String appName = 'LensGuard';
  static const String appVersion = '1.0.0';

  // Notification IDs
  static const int morningReminderId = 1;
  static const int eveningReminderId = 2;
  static const int lensReplacementId = 3;
  static const int priceAlertId = 4;

  // Collection names
  static const String usersCollection = 'users';
  static const String priceCatalogCollection = 'price_catalog';

  // Default values
  static const List<String> commonLensBrands = [
    'Acuvue Oasys',
    'Acuvue Moist',
    'Biofinity',
    'Air Optix',
    'Dailies Total 1',
    'MyDay',
    'Proclear',
    'Ultra',
  ];

  static const List<String> commonLensModels = [
    '1-Day',
    '14-Day',
    '30-Day',
    'Monthly',
    'Weekly',
    'Daily',
  ];

  // Retailers for price tracking
  static const List<String> retailers = [
    'Lens4U',
    'ContactLensKing',
    'DiscountContactLenses',
    'LensCrafters',
  ];

  // Common diopter values
  static const List<String> commonDioters = [
    '-12.00',
    '-11.50',
    '-11.00',
    '-10.50',
    '-10.00',
    '-9.50',
    '-9.00',
    '-8.50',
    '-8.00',
    '-7.50',
    '-7.00',
    '-6.50',
    '-6.00',
    '-5.75',
    '-5.50',
    '-5.25',
    '-5.00',
    '-4.75',
    '-4.50',
    '-4.25',
    '-4.00',
    '-3.75',
    '-3.50',
    '-3.25',
    '-3.00',
    '-2.75',
    '-2.50',
    '-2.25',
    '-2.00',
    '-1.75',
    '-1.50',
    '-1.25',
    '-1.00',
    '-0.75',
    '-0.50',
    '-0.25',
    '0.00 (Plano)',
    '+0.25',
    '+0.50',
    '+0.75',
    '+1.00',
    '+1.25',
    '+1.50',
    '+1.75',
    '+2.00',
    '+2.50',
    '+3.00',
    '+3.50',
    '+4.00',
    '+4.50',
    '+5.00',
    '+5.50',
    '+6.00',
  ];
}
