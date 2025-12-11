import 'package:intl/intl.dart';

/// Date utility functions
class DateUtils {
  /// Format date to readable string (e.g., "Dec 10, 2024")  
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format date to short string (e.g., "12/10/2024")
  static String formatDateShort(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  /// Format time to readable string (e.g., "08:30 AM")
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  /// Calculate days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  /// Calculate days since a date
  static int daysSince(DateTime date) {
    return daysBetween(date, DateTime.now());
  }

  /// Calculate days until a date
  static int daysUntil(DateTime date) {
    return daysBetween(DateTime.now(), date);
  }

  /// Get replacement date based on lens model duration
  static DateTime getReplacementDate(DateTime startDate, int durationDays) {
    return startDate.add(Duration(days: durationDays));
  }

  /// Check if lens pair should be replaced
  static bool shouldReplace(DateTime startDate, int durationDays) {
    final now = DateTime.now();
    final replacementDate = getReplacementDate(startDate, durationDays);
    return now.isAfter(replacementDate) || now.isAtSameMomentAs(replacementDate);
  }

  /// Get days remaining until replacement
  static int daysRemaining(DateTime startDate, int durationDays) {
    final replacementDate = getReplacementDate(startDate, durationDays);
    final remaining = daysUntil(replacementDate);
    return remaining >= 0 ? remaining : 0;
  }

  /// Get wear progress as percentage (0.0 to 1.0)
  static double getWearProgress(DateTime startDate, int durationDays) {
    final daysWorn = daysSince(startDate);
    if (daysWorn <= 0) return 0.0;
    if (daysWorn >= durationDays) return 1.0;
    return daysWorn / durationDays;
  }

  /// Check if wear time is in warning zone (>80% used)
  static bool isInWarningZone(DateTime startDate, int durationDays) {
    return getWearProgress(startDate, durationDays) >= 0.8;
  }

  /// Format relative date (e.g., "Today", "Yesterday", "2 days ago")
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = daysBetween(date, now);

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference == -1) return 'Tomorrow';
    if (difference > 1 && difference < 7) return '$difference days ago';
    if (difference < -1 && difference > -7) return 'In ${-difference} days';

    return formatDate(date);
  }
}
