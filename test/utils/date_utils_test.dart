import 'package:flutter_test/flutter_test.dart';
import 'package:lensguard/utils/date_utils.dart' as app_date_utils;

void main() {
  group('formatDate', () {
    test('formats a typical date correctly', () {
      final date = DateTime(2024, 12, 10);
      expect(app_date_utils.DateUtils.formatDate(date), 'Dec 10, 2024');
    });

    test('formats January 1st correctly', () {
      final date = DateTime(2025, 1, 1);
      expect(app_date_utils.DateUtils.formatDate(date), 'Jan 01, 2025');
    });

    test('formats a leap day correctly', () {
      final date = DateTime(2024, 2, 29);
      expect(app_date_utils.DateUtils.formatDate(date), 'Feb 29, 2024');
    });

    test('formats last day of year correctly', () {
      final date = DateTime(2024, 12, 31);
      expect(app_date_utils.DateUtils.formatDate(date), 'Dec 31, 2024');
    });
  });

  group('formatDateShort', () {
    test('formats a typical date correctly', () {
      final date = DateTime(2024, 12, 10);
      expect(app_date_utils.DateUtils.formatDateShort(date), '12/10/2024');
    });

    test('pads single-digit month and day', () {
      final date = DateTime(2025, 3, 5);
      expect(app_date_utils.DateUtils.formatDateShort(date), '03/05/2025');
    });

    test('formats January 1st correctly', () {
      final date = DateTime(2025, 1, 1);
      expect(app_date_utils.DateUtils.formatDateShort(date), '01/01/2025');
    });
  });

  group('formatTime', () {
    test('formats morning time correctly', () {
      final time = DateTime(2024, 1, 1, 8, 30);
      expect(app_date_utils.DateUtils.formatTime(time), '08:30 AM');
    });

    test('formats afternoon time correctly', () {
      final time = DateTime(2024, 1, 1, 14, 45);
      expect(app_date_utils.DateUtils.formatTime(time), '02:45 PM');
    });

    test('formats midnight correctly', () {
      final time = DateTime(2024, 1, 1, 0, 0);
      expect(app_date_utils.DateUtils.formatTime(time), '12:00 AM');
    });

    test('formats noon correctly', () {
      final time = DateTime(2024, 1, 1, 12, 0);
      expect(app_date_utils.DateUtils.formatTime(time), '12:00 PM');
    });

    test('formats 11:59 PM correctly', () {
      final time = DateTime(2024, 1, 1, 23, 59);
      expect(app_date_utils.DateUtils.formatTime(time), '11:59 PM');
    });
  });

  group('daysBetween', () {
    test('returns 0 for the same day', () {
      final date = DateTime(2024, 6, 15);
      expect(app_date_utils.DateUtils.daysBetween(date, date), 0);
    });

    test('returns 1 for consecutive days', () {
      final from = DateTime(2024, 6, 15);
      final to = DateTime(2024, 6, 16);
      expect(app_date_utils.DateUtils.daysBetween(from, to), 1);
    });

    test('returns negative value for reverse direction', () {
      final from = DateTime(2024, 6, 16);
      final to = DateTime(2024, 6, 15);
      expect(app_date_utils.DateUtils.daysBetween(from, to), -1);
    });

    test('ignores time component', () {
      final from = DateTime(2024, 6, 15, 23, 59, 59);
      final to = DateTime(2024, 6, 16, 0, 0, 1);
      expect(app_date_utils.DateUtils.daysBetween(from, to), 1);
    });

    test('returns 0 for same day with different times', () {
      final from = DateTime(2024, 6, 15, 1, 0);
      final to = DateTime(2024, 6, 15, 23, 0);
      expect(app_date_utils.DateUtils.daysBetween(from, to), 0);
    });

    test('works across month boundaries', () {
      final from = DateTime(2024, 1, 31);
      final to = DateTime(2024, 2, 1);
      expect(app_date_utils.DateUtils.daysBetween(from, to), 1);
    });

    test('works across year boundaries', () {
      final from = DateTime(2024, 12, 31);
      final to = DateTime(2025, 1, 1);
      expect(app_date_utils.DateUtils.daysBetween(from, to), 1);
    });

    test('calculates large spans correctly', () {
      final from = DateTime(2024, 1, 1);
      final to = DateTime(2024, 12, 31);
      // 2024 is a leap year: Jan 1 to Dec 31 = 365 days
      expect(app_date_utils.DateUtils.daysBetween(from, to), 365);
    });
  });

  group('daysSince', () {
    test('returns positive value for a past date', () {
      final now = DateTime.now();
      final pastDate = now.subtract(const Duration(days: 5));
      final result = app_date_utils.DateUtils.daysSince(pastDate);
      expect(result, inInclusiveRange(4, 6));
    });

    test('returns 0 for today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      expect(app_date_utils.DateUtils.daysSince(today), 0);
    });

    test('returns negative value for a future date', () {
      final now = DateTime.now();
      final futureDate = now.add(const Duration(days: 10));
      final result = app_date_utils.DateUtils.daysSince(futureDate);
      expect(result, isNegative);
    });
  });

  group('daysUntil', () {
    test('returns positive value for a future date', () {
      final now = DateTime.now();
      final futureDate = now.add(const Duration(days: 7));
      final result = app_date_utils.DateUtils.daysUntil(futureDate);
      expect(result, inInclusiveRange(6, 8));
    });

    test('returns 0 for today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      expect(app_date_utils.DateUtils.daysUntil(today), 0);
    });

    test('returns negative value for a past date', () {
      final now = DateTime.now();
      final pastDate = now.subtract(const Duration(days: 3));
      final result = app_date_utils.DateUtils.daysUntil(pastDate);
      expect(result, isNegative);
    });
  });

  group('getReplacementDate', () {
    test('adds 1 day correctly', () {
      final start = DateTime(2024, 6, 15);
      final result = app_date_utils.DateUtils.getReplacementDate(start, 1);
      expect(result, DateTime(2024, 6, 16));
    });

    test('adds 14 days correctly', () {
      final start = DateTime(2024, 6, 15);
      final result = app_date_utils.DateUtils.getReplacementDate(start, 14);
      expect(result, DateTime(2024, 6, 29));
    });

    test('adds 30 days correctly', () {
      final start = DateTime(2024, 6, 1);
      final result = app_date_utils.DateUtils.getReplacementDate(start, 30);
      expect(result, DateTime(2024, 7, 1));
    });

    test('handles crossing month boundary', () {
      final start = DateTime(2024, 1, 20);
      final result = app_date_utils.DateUtils.getReplacementDate(start, 14);
      expect(result, DateTime(2024, 2, 3));
    });

    test('handles crossing year boundary', () {
      final start = DateTime(2024, 12, 20);
      final result = app_date_utils.DateUtils.getReplacementDate(start, 30);
      expect(result, DateTime(2025, 1, 19));
    });

    test('adds 0 days returns same date', () {
      final start = DateTime(2024, 6, 15);
      final result = app_date_utils.DateUtils.getReplacementDate(start, 0);
      expect(result, DateTime(2024, 6, 15));
    });
  });

  group('shouldReplace', () {
    test('returns true when start date is far in the past', () {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 60));
      expect(app_date_utils.DateUtils.shouldReplace(startDate, 30), isTrue);
    });

    test('returns false when start date is today with 30-day duration', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day);
      expect(app_date_utils.DateUtils.shouldReplace(startDate, 30), isFalse);
    });

    test('returns true when start date is exactly durationDays ago', () {
      final now = DateTime.now();
      // Set startDate to exactly durationDays ago at midnight so the
      // replacement date is today at midnight, which is at or before now.
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));
      expect(app_date_utils.DateUtils.shouldReplace(startDate, 30), isTrue);
    });

    test('returns false when still within duration', () {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 10));
      expect(app_date_utils.DateUtils.shouldReplace(startDate, 30), isFalse);
    });

    test('returns true for 1-day lens started yesterday', () {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 1));
      expect(app_date_utils.DateUtils.shouldReplace(startDate, 1), isTrue);
    });
  });

  group('daysRemaining', () {
    test('returns positive days for future replacement date', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day);
      final result = app_date_utils.DateUtils.daysRemaining(startDate, 30);
      expect(result, inInclusiveRange(29, 31));
    });

    test('clamps to 0 for past replacement date', () {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 60));
      expect(app_date_utils.DateUtils.daysRemaining(startDate, 30), 0);
    });

    test('returns 0 when replacement date is today', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));
      expect(app_date_utils.DateUtils.daysRemaining(startDate, 30), 0);
    });

    test('returns correct days for mid-duration lens', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 10));
      final result = app_date_utils.DateUtils.daysRemaining(startDate, 30);
      expect(result, inInclusiveRange(19, 21));
    });
  });

  group('getWearProgress', () {
    test('returns 0.0 on day 0 of 30', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day);
      expect(app_date_utils.DateUtils.getWearProgress(startDate, 30), 0.0);
    });

    test('returns approximately 0.5 at day 15 of 30', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 15));
      expect(
        app_date_utils.DateUtils.getWearProgress(startDate, 30),
        closeTo(0.5, 0.05),
      );
    });

    test('returns 1.0 at day 30 of 30', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));
      expect(app_date_utils.DateUtils.getWearProgress(startDate, 30), 1.0);
    });

    test('clamps to 1.0 when past duration (day 45 of 30)', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 45));
      expect(app_date_utils.DateUtils.getWearProgress(startDate, 30), 1.0);
    });

    test('returns 0.0 for future start date', () {
      final now = DateTime.now();
      final startDate = now.add(const Duration(days: 5));
      expect(app_date_utils.DateUtils.getWearProgress(startDate, 30), 0.0);
    });

    test('returns approximately 1/3 at day 10 of 30', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 10));
      expect(
        app_date_utils.DateUtils.getWearProgress(startDate, 30),
        closeTo(1.0 / 3.0, 0.05),
      );
    });
  });

  group('isInWarningZone', () {
    test('returns false at day 23 of 30 (~77%)', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 23));
      expect(
        app_date_utils.DateUtils.isInWarningZone(startDate, 30),
        isFalse,
      );
    });

    test('returns true at day 24 of 30 (80%)', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 24));
      expect(
        app_date_utils.DateUtils.isInWarningZone(startDate, 30),
        isTrue,
      );
    });

    test('returns true at day 30 of 30 (100%)', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));
      expect(
        app_date_utils.DateUtils.isInWarningZone(startDate, 30),
        isTrue,
      );
    });

    test('returns false at day 0 of 30 (0%)', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day);
      expect(
        app_date_utils.DateUtils.isInWarningZone(startDate, 30),
        isFalse,
      );
    });

    test('returns true when past duration (day 45 of 30)', () {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 45));
      expect(
        app_date_utils.DateUtils.isInWarningZone(startDate, 30),
        isTrue,
      );
    });
  });

  group('formatRelativeDate', () {
    test('returns "Today" for today', () {
      final now = DateTime.now();
      expect(app_date_utils.DateUtils.formatRelativeDate(now), 'Today');
    });

    test('returns "Yesterday" for yesterday', () {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 1));
      expect(
        app_date_utils.DateUtils.formatRelativeDate(yesterday),
        'Yesterday',
      );
    });

    test('returns "Tomorrow" for tomorrow', () {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day)
          .add(const Duration(days: 1));
      expect(
        app_date_utils.DateUtils.formatRelativeDate(tomorrow),
        'Tomorrow',
      );
    });

    test('returns "3 days ago" for 3 days ago', () {
      final now = DateTime.now();
      final threeDaysAgo = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 3));
      expect(
        app_date_utils.DateUtils.formatRelativeDate(threeDaysAgo),
        '3 days ago',
      );
    });

    test('returns "In 3 days" for 3 days from now', () {
      final now = DateTime.now();
      final inThreeDays = DateTime(now.year, now.month, now.day)
          .add(const Duration(days: 3));
      expect(
        app_date_utils.DateUtils.formatRelativeDate(inThreeDays),
        'In 3 days',
      );
    });

    test('returns "6 days ago" for 6 days ago (boundary)', () {
      final now = DateTime.now();
      final sixDaysAgo = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 6));
      expect(
        app_date_utils.DateUtils.formatRelativeDate(sixDaysAgo),
        '6 days ago',
      );
    });

    test('returns "In 6 days" for 6 days from now (boundary)', () {
      final now = DateTime.now();
      final inSixDays = DateTime(now.year, now.month, now.day)
          .add(const Duration(days: 6));
      expect(
        app_date_utils.DateUtils.formatRelativeDate(inSixDays),
        'In 6 days',
      );
    });

    test('returns formatted date for 7 days ago (falls through to formatDate)',
        () {
      final now = DateTime.now();
      final sevenDaysAgo = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 7));
      final result =
          app_date_utils.DateUtils.formatRelativeDate(sevenDaysAgo);
      // Should fall through to formatDate, so check it matches.
      expect(result, app_date_utils.DateUtils.formatDate(sevenDaysAgo));
    });

    test(
        'returns formatted date for 7 days from now (falls through to formatDate)',
        () {
      final now = DateTime.now();
      final inSevenDays = DateTime(now.year, now.month, now.day)
          .add(const Duration(days: 7));
      final result =
          app_date_utils.DateUtils.formatRelativeDate(inSevenDays);
      expect(result, app_date_utils.DateUtils.formatDate(inSevenDays));
    });

    test('returns formatted date for a date far in the past', () {
      final farPast = DateTime(2020, 1, 1);
      final result = app_date_utils.DateUtils.formatRelativeDate(farPast);
      expect(result, 'Jan 01, 2020');
    });
  });
}
