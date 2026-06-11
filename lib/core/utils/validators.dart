import '../constants/app_strings.dart';

/// Voltify – Form validation rules.
/// Returns null if valid, or an error message string.
abstract final class Validators {
  /// Full Name: required, trimmed, min 3 chars.
  static String? validateFullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.fieldRequired;
    if (trimmed.length < 3) return AppStrings.nameMinLength;
    return null;
  }

  /// Email: required, valid format.
  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.fieldRequired;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$',
    );
    if (!emailRegex.hasMatch(trimmed)) return AppStrings.invalidEmail;
    return null;
  }

  /// Phone Number: optional, but if provided must be valid format.
  static String? validatePhoneNumber(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null; // Phone is optional
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{7,20}$');
    if (!phoneRegex.hasMatch(trimmed)) return AppStrings.invalidPhoneNumber;
    return null;
  }

  /// Password: required, min 8, uppercase, lowercase, digit, special char.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (value.length < 8) return AppStrings.passwordMinLength;
    if (!value.contains(RegExp(r'[A-Z]'))) return AppStrings.passwordUppercase;
    if (!value.contains(RegExp(r'[a-z]'))) return AppStrings.passwordLowercase;
    if (!value.contains(RegExp(r'[0-9]'))) return AppStrings.passwordNumber;
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.passwordSpecialChar;
    }
    return null;
  }

  /// Confirm Password: required, must match [password].
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (value != password) return AppStrings.passwordsDoNotMatch;
    return null;
  }
}
