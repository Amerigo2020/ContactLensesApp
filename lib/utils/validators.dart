/// Form field validators
class Validators {
  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Strong password validation
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${fieldName ?? 'this field'}';
    }
    return null;
  }

  /// Dropdown validation
  static String? dropdown(dynamic value, {String? fieldName}) {
    if (value == null) {
      return 'Please select ${fieldName ?? 'an option'}';
    }
    return null;
  }
}

/// Password strength enum
enum PasswordStrength {
  weak,
  medium,
  strong,
}

/// Check password strength
PasswordStrength checkPasswordStrength(String password) {
  if (password.length < 6) return PasswordStrength.weak;

  int strength = 0;
  
  if (password.length >= 8) strength++;
  if (password.contains(RegExp(r'[A-Z]'))) strength++;
  if (password.contains(RegExp(r'[a-z]'))) strength++;
  if (password.contains(RegExp(r'[0-9]'))) strength++;
  if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

  if (strength >= 4) return PasswordStrength.strong;
  if (strength >= 2) return PasswordStrength.medium;
  return PasswordStrength.weak;
}
