import 'package:flutter_test/flutter_test.dart';
import 'package:lensguard/utils/validators.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Validators.email
  // ---------------------------------------------------------------------------
  group('Validators.email', () {
    test('returns error when value is null', () {
      expect(Validators.email(null), 'Please enter your email');
    });

    test('returns error when value is empty string', () {
      expect(Validators.email(''), 'Please enter your email');
    });

    test('returns null for a valid simple email', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('returns null for email with dots in local part', () {
      expect(Validators.email('first.last@example.com'), isNull);
    });

    test('returns null for email with plus in local part', () {
      expect(Validators.email('user+tag@example.com'), isNull);
    });

    test('returns null for email with underscores', () {
      expect(Validators.email('user_name@example.com'), isNull);
    });

    test('returns null for email with percent', () {
      expect(Validators.email('user%name@example.com'), isNull);
    });

    test('returns null for email with hyphen in domain', () {
      expect(Validators.email('user@my-domain.com'), isNull);
    });

    test('returns null for email with subdomain', () {
      expect(Validators.email('user@mail.example.com'), isNull);
    });

    test('returns null for email with two-letter TLD', () {
      expect(Validators.email('user@example.de'), isNull);
    });

    test('returns null for email with long TLD', () {
      expect(Validators.email('user@example.museum'), isNull);
    });

    test('returns null for email with numeric local part', () {
      expect(Validators.email('12345@example.com'), isNull);
    });

    test('returns error when @ is missing', () {
      expect(Validators.email('userexample.com'),
          'Please enter a valid email address');
    });

    test('returns error when domain is missing', () {
      expect(
          Validators.email('user@'), 'Please enter a valid email address');
    });

    test('returns error when TLD is missing', () {
      expect(Validators.email('user@example'),
          'Please enter a valid email address');
    });

    test('returns error when TLD is single character', () {
      expect(Validators.email('user@example.c'),
          'Please enter a valid email address');
    });

    test('returns error when local part is missing', () {
      expect(Validators.email('@example.com'),
          'Please enter a valid email address');
    });

    test('returns error for double @ sign', () {
      expect(Validators.email('user@@example.com'),
          'Please enter a valid email address');
    });

    test('returns error for spaces in email', () {
      expect(Validators.email('user @example.com'),
          'Please enter a valid email address');
    });

    test('returns error for whitespace-only input', () {
      expect(
          Validators.email('   '), 'Please enter a valid email address');
    });

    test('returns error when domain starts with dot', () {
      expect(Validators.email('user@.example.com'),
          'Please enter a valid email address');
    });
  });

  // ---------------------------------------------------------------------------
  // Validators.password
  // ---------------------------------------------------------------------------
  group('Validators.password', () {
    test('returns error when value is null', () {
      expect(Validators.password(null), 'Please enter a password');
    });

    test('returns error when value is empty string', () {
      expect(Validators.password(''), 'Please enter a password');
    });

    test('returns error for 1-character password', () {
      expect(Validators.password('a'),
          'Password must be at least 6 characters');
    });

    test('returns error for 5-character password (just below boundary)', () {
      expect(Validators.password('abcde'),
          'Password must be at least 6 characters');
    });

    test('returns null for exactly 6-character password (boundary)', () {
      expect(Validators.password('abcdef'), isNull);
    });

    test('returns null for 7-character password (just above boundary)', () {
      expect(Validators.password('abcdefg'), isNull);
    });

    test('returns null for long password', () {
      expect(Validators.password('a' * 100), isNull);
    });

    test('returns null for password with special characters', () {
      expect(Validators.password('!@#\$%^'), isNull);
    });

    test('returns null for password with spaces', () {
      expect(Validators.password('ab cd ef'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Validators.strongPassword
  // ---------------------------------------------------------------------------
  group('Validators.strongPassword', () {
    test('returns error when value is null', () {
      expect(Validators.strongPassword(null), 'Please enter a password');
    });

    test('returns error when value is empty string', () {
      expect(Validators.strongPassword(''), 'Please enter a password');
    });

    test('returns error for 7-character password (below 8-char minimum)', () {
      expect(Validators.strongPassword('Abcdef1'),
          'Password must be at least 8 characters');
    });

    test('returns error when missing uppercase letter', () {
      expect(Validators.strongPassword('abcdefg1'),
          'Password must contain at least one uppercase letter');
    });

    test('returns error when missing lowercase letter', () {
      expect(Validators.strongPassword('ABCDEFG1'),
          'Password must contain at least one lowercase letter');
    });

    test('returns error when missing digit', () {
      expect(Validators.strongPassword('Abcdefgh'),
          'Password must contain at least one number');
    });

    test('returns null for valid strong password', () {
      expect(Validators.strongPassword('Abcdefg1'), isNull);
    });

    test('returns null for strong password with special characters', () {
      expect(Validators.strongPassword('Abcdef1!'), isNull);
    });

    test('returns null for exactly 8-character strong password (boundary)',
        () {
      expect(Validators.strongPassword('Abc1defg'), isNull);
    });

    test('returns null for long strong password', () {
      expect(Validators.strongPassword('Abcdefghijklmnop1'), isNull);
    });

    test('checks rules in order: length before uppercase', () {
      // 7 chars, no uppercase, no digit -> should fail on length first
      expect(Validators.strongPassword('abcdefg'),
          'Password must be at least 8 characters');
    });

    test('checks rules in order: uppercase before lowercase', () {
      // 8 chars, no uppercase, has lowercase, has digit
      // Should fail on uppercase, not lowercase
      expect(Validators.strongPassword('abcdefg1'),
          'Password must contain at least one uppercase letter');
    });

    test('checks rules in order: lowercase before digit', () {
      // 8 chars, has uppercase, no lowercase, has digit
      // Should fail on lowercase
      expect(Validators.strongPassword('ABCDEFG1'),
          'Password must contain at least one lowercase letter');
    });
  });

  // ---------------------------------------------------------------------------
  // Validators.required
  // ---------------------------------------------------------------------------
  group('Validators.required', () {
    test('returns default error when value is null', () {
      expect(Validators.required(null), 'Please enter this field');
    });

    test('returns default error when value is empty string', () {
      expect(Validators.required(''), 'Please enter this field');
    });

    test('returns custom error with fieldName when value is null', () {
      expect(Validators.required(null, fieldName: 'your name'),
          'Please enter your name');
    });

    test('returns custom error with fieldName when value is empty', () {
      expect(Validators.required('', fieldName: 'your name'),
          'Please enter your name');
    });

    test('returns null for non-empty value', () {
      expect(Validators.required('hello'), isNull);
    });

    test('returns null for whitespace-only value (not trimmed)', () {
      // The validator uses isEmpty, which is false for whitespace strings
      expect(Validators.required('   '), isNull);
    });

    test('returns null for value with leading/trailing spaces', () {
      expect(Validators.required('  hello  '), isNull);
    });

    test('returns null when fieldName is provided and value is valid', () {
      expect(Validators.required('value', fieldName: 'email'), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Validators.dropdown
  // ---------------------------------------------------------------------------
  group('Validators.dropdown', () {
    test('returns default error when value is null', () {
      expect(Validators.dropdown(null), 'Please select an option');
    });

    test('returns custom error with fieldName when value is null', () {
      expect(Validators.dropdown(null, fieldName: 'a color'),
          'Please select a color');
    });

    test('returns null for non-null string value', () {
      expect(Validators.dropdown('option1'), isNull);
    });

    test('returns null for non-null int value', () {
      expect(Validators.dropdown(42), isNull);
    });

    test('returns null for non-null bool value', () {
      expect(Validators.dropdown(true), isNull);
    });

    test('returns null for empty string (only null triggers error)', () {
      // dropdown checks for null only, not empty
      expect(Validators.dropdown(''), isNull);
    });

    test('returns null for zero (non-null)', () {
      expect(Validators.dropdown(0), isNull);
    });

    test('returns null for false (non-null)', () {
      expect(Validators.dropdown(false), isNull);
    });

    test('returns null for empty list (non-null)', () {
      expect(Validators.dropdown([]), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // PasswordStrength enum
  // ---------------------------------------------------------------------------
  group('PasswordStrength enum', () {
    test('has exactly three values', () {
      expect(PasswordStrength.values.length, 3);
    });

    test('values are weak, medium, strong in order', () {
      expect(PasswordStrength.values, [
        PasswordStrength.weak,
        PasswordStrength.medium,
        PasswordStrength.strong,
      ]);
    });
  });

  // ---------------------------------------------------------------------------
  // checkPasswordStrength
  // ---------------------------------------------------------------------------
  group('checkPasswordStrength', () {
    group('returns weak', () {
      test('for empty password', () {
        expect(checkPasswordStrength(''), PasswordStrength.weak);
      });

      test('for password shorter than 6 characters', () {
        expect(checkPasswordStrength('Ab1!'), PasswordStrength.weak);
      });

      test('for 5-character password (just below 6-char threshold)', () {
        expect(checkPasswordStrength('Ab1!x'), PasswordStrength.weak);
      });

      test('for 6-char lowercase-only password (strength=1)', () {
        // length>=6 but <8 so no length bonus
        // has lowercase -> strength=1
        // strength<2 -> weak
        expect(checkPasswordStrength('abcdef'), PasswordStrength.weak);
      });

      test('for 6-char uppercase-only password (strength=1)', () {
        // has uppercase -> strength=1
        expect(checkPasswordStrength('ABCDEF'), PasswordStrength.weak);
      });

      test('for 6-char digit-only password (strength=1)', () {
        // has digit -> strength=1
        expect(checkPasswordStrength('123456'), PasswordStrength.weak);
      });
    });

    group('returns medium', () {
      test('for 6-char password with lowercase + uppercase (strength=2)', () {
        // lowercase -> +1, uppercase -> +1 = 2
        expect(checkPasswordStrength('abcDEF'), PasswordStrength.medium);
      });

      test('for 6-char password with lowercase + digit (strength=2)', () {
        expect(checkPasswordStrength('abcde1'), PasswordStrength.medium);
      });

      test('for 6-char password with uppercase + digit (strength=2)', () {
        expect(checkPasswordStrength('ABCDE1'), PasswordStrength.medium);
      });

      test('for 6-char password with lowercase + special char (strength=2)',
          () {
        expect(checkPasswordStrength('abcde!'), PasswordStrength.medium);
      });

      test(
          'for 8-char lowercase-only password (strength=2: length+lowercase)',
          () {
        // length>=8 -> +1, lowercase -> +1 = 2
        expect(checkPasswordStrength('abcdefgh'), PasswordStrength.medium);
      });

      test('for 6-char password with 3 criteria met (strength=3)', () {
        // lowercase + uppercase + digit = 3
        expect(checkPasswordStrength('abcD1f'), PasswordStrength.medium);
      });
    });

    group('returns strong', () {
      test('for password meeting 4 criteria (strength=4)', () {
        // length>=8 -> +1, uppercase -> +1, lowercase -> +1, digit -> +1 = 4
        expect(checkPasswordStrength('Abcdefg1'), PasswordStrength.strong);
      });

      test('for password meeting all 5 criteria (strength=5)', () {
        // length>=8 -> +1, uppercase -> +1, lowercase -> +1, digit -> +1,
        // special -> +1 = 5
        expect(
            checkPasswordStrength('Abcdefg1!'), PasswordStrength.strong);
      });

      test(
          'for 8-char password with uppercase + lowercase + digit (strength=4)',
          () {
        // length>=8 + uppercase + lowercase + digit
        expect(checkPasswordStrength('Password1'), PasswordStrength.strong);
      });

      test(
          'for 8-char password with uppercase + lowercase + special (strength=4)',
          () {
        // length>=8 + uppercase + lowercase + special
        expect(
            checkPasswordStrength('Password!'), PasswordStrength.strong);
      });

      test('for long complex password', () {
        expect(
            checkPasswordStrength('MyStr0ng!Pass'), PasswordStrength.strong);
      });
    });

    group('boundary between weak and medium', () {
      test('strength=1 is weak', () {
        // 6-char, only lowercase: strength=1
        expect(checkPasswordStrength('abcdef'), PasswordStrength.weak);
      });

      test('strength=2 is medium', () {
        // 6-char, lowercase + uppercase: strength=2
        expect(checkPasswordStrength('abcDEF'), PasswordStrength.medium);
      });
    });

    group('boundary between medium and strong', () {
      test('strength=3 is medium', () {
        // 6-char, lowercase + uppercase + digit: strength=3
        expect(checkPasswordStrength('abcD1f'), PasswordStrength.medium);
      });

      test('strength=4 is strong', () {
        // 8-char (length>=8 bonus), lowercase + uppercase + digit: strength=4
        expect(checkPasswordStrength('Abcdefg1'), PasswordStrength.strong);
      });
    });

    group('special characters recognition', () {
      test('recognizes exclamation mark', () {
        // 6-char, lowercase + special = 2 -> medium
        expect(checkPasswordStrength('abcde!'), PasswordStrength.medium);
      });

      test('recognizes at sign', () {
        expect(checkPasswordStrength('abcde@'), PasswordStrength.medium);
      });

      test('recognizes hash', () {
        expect(checkPasswordStrength('abcde#'), PasswordStrength.medium);
      });

      test('recognizes dollar sign', () {
        expect(checkPasswordStrength('abcde\$'), PasswordStrength.medium);
      });

      test('recognizes percent', () {
        expect(checkPasswordStrength('abcde%'), PasswordStrength.medium);
      });

      test('recognizes caret', () {
        expect(checkPasswordStrength('abcde^'), PasswordStrength.medium);
      });

      test('recognizes ampersand', () {
        expect(checkPasswordStrength('abcde&'), PasswordStrength.medium);
      });

      test('recognizes asterisk', () {
        expect(checkPasswordStrength('abcde*'), PasswordStrength.medium);
      });

      test('recognizes angle brackets', () {
        expect(checkPasswordStrength('abcde<'), PasswordStrength.medium);
        expect(checkPasswordStrength('abcde>'), PasswordStrength.medium);
      });
    });

    group('length threshold at 6 characters', () {
      test('5-char password always returns weak regardless of complexity',
          () {
        // Even with uppercase + lowercase + digit + special, under 6 = weak
        expect(checkPasswordStrength('Ab1!x'), PasswordStrength.weak);
      });

      test('6-char password can be medium with 2+ criteria', () {
        expect(checkPasswordStrength('abcD1f'), PasswordStrength.medium);
      });
    });
  });
}
