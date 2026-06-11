import 'package:flutter_test/flutter_test.dart';
import 'package:voltify/core/constants/app_strings.dart';
import 'package:voltify/core/utils/validators.dart';

void main() {
  group('Validators.validateFullName', () {
    test('returns error when empty', () {
      expect(Validators.validateFullName(''), AppStrings.fieldRequired);
      expect(Validators.validateFullName(null), AppStrings.fieldRequired);
      expect(Validators.validateFullName('   '), AppStrings.fieldRequired);
    });

    test('returns error when less than 3 characters', () {
      expect(Validators.validateFullName('Ab'), AppStrings.nameMinLength);
    });

    test('returns null for valid name', () {
      expect(Validators.validateFullName('John Doe'), isNull);
      expect(Validators.validateFullName('Ana'), isNull);
    });

    test('trims whitespace before validation', () {
      expect(Validators.validateFullName('  Jo  '), AppStrings.nameMinLength);
      expect(Validators.validateFullName('  John  '), isNull);
    });
  });

  group('Validators.validateEmail', () {
    test('returns error when empty', () {
      expect(Validators.validateEmail(''), AppStrings.fieldRequired);
      expect(Validators.validateEmail(null), AppStrings.fieldRequired);
    });

    test('returns error for invalid format', () {
      expect(Validators.validateEmail('notanemail'), AppStrings.invalidEmail);
      expect(Validators.validateEmail('missing@'), AppStrings.invalidEmail);
      expect(Validators.validateEmail('@domain.com'), AppStrings.invalidEmail);
    });

    test('returns null for valid email', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
      expect(Validators.validateEmail('name.last@domain.co'), isNull);
    });
  });

  group('Validators.validatePhoneNumber', () {
    test('returns null when empty (optional field)', () {
      expect(Validators.validatePhoneNumber(''), isNull);
      expect(Validators.validatePhoneNumber(null), isNull);
    });

    test('returns error for invalid format', () {
      expect(
        Validators.validatePhoneNumber('abc'),
        AppStrings.invalidPhoneNumber,
      );
      expect(
        Validators.validatePhoneNumber('123'),
        AppStrings.invalidPhoneNumber,
      );
    });

    test('returns null for valid phone numbers', () {
      expect(Validators.validatePhoneNumber('+1 (555) 123-4567'), isNull);
      expect(Validators.validatePhoneNumber('+201234567890'), isNull);
      expect(Validators.validatePhoneNumber('01234567890'), isNull);
    });
  });

  group('Validators.validatePassword', () {
    test('returns error when empty', () {
      expect(Validators.validatePassword(''), AppStrings.fieldRequired);
      expect(Validators.validatePassword(null), AppStrings.fieldRequired);
    });

    test('returns error when too short', () {
      expect(Validators.validatePassword('Ab1!'), AppStrings.passwordMinLength);
    });

    test('returns error when missing uppercase', () {
      expect(
        Validators.validatePassword('abcdefg1!'),
        AppStrings.passwordUppercase,
      );
    });

    test('returns error when missing lowercase', () {
      expect(
        Validators.validatePassword('ABCDEFG1!'),
        AppStrings.passwordLowercase,
      );
    });

    test('returns error when missing number', () {
      expect(
        Validators.validatePassword('Abcdefgh!'),
        AppStrings.passwordNumber,
      );
    });

    test('returns error when missing special character', () {
      expect(
        Validators.validatePassword('Abcdefg1'),
        AppStrings.passwordSpecialChar,
      );
    });

    test('returns null for strong password', () {
      expect(Validators.validatePassword('StrongP@ss1'), isNull);
      expect(Validators.validatePassword('MyP\$ssw0rd!'), isNull);
    });
  });

  group('Validators.validateConfirmPassword', () {
    test('returns error when empty', () {
      expect(
        Validators.validateConfirmPassword('', 'password'),
        AppStrings.fieldRequired,
      );
    });

    test('returns error when passwords do not match', () {
      expect(
        Validators.validateConfirmPassword('different', 'password'),
        AppStrings.passwordsDoNotMatch,
      );
    });

    test('returns null when passwords match', () {
      expect(
        Validators.validateConfirmPassword('StrongP@ss1', 'StrongP@ss1'),
        isNull,
      );
    });
  });
}
