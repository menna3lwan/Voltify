/// Voltify – All user-facing strings (matched to Figma design).
abstract final class AppStrings {
  // ──── App ────
  static const String appName = 'Voltify';

  // ──── Sign Up Screen ────
  static const String createAccount = 'Create Account';
  static const String welcomeDescription = 'Join Voltify today';

  // ──── Form Labels ────
  static const String fullName = 'Full Name';
  static const String fullNameHint = 'Adham Hesham';
  static const String email = 'Email';
  static const String emailHint = 'you@example.com';
  static const String phoneNumber = 'Phone Number';
  static const String phoneNumberHint = '+1 (555) 123-4567';
  static const String password = 'Password';
  static const String passwordHint = 'Create a password';
  static const String confirmPassword = 'Confirm Password';
  static const String confirmPasswordHint = 'Confirm your password';

  // ──── Buttons ────
  static const String createAccountButton = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signIn = 'Sign In';

  // ──── Validation Messages ────
  static const String fieldRequired = 'This field is required';
  static const String nameMinLength = 'Name must be at least 3 characters';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhoneNumber =
      'Please enter a valid phone number';
  static const String passwordMinLength =
      'Password must be at least 8 characters';
  static const String passwordUppercase =
      'Password must contain an uppercase letter';
  static const String passwordLowercase =
      'Password must contain a lowercase letter';
  static const String passwordNumber = 'Password must contain a number';
  static const String passwordSpecialChar =
      'Password must contain a special character';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // ──── Firebase Error Messages ────
  static const String emailAlreadyInUse =
      'This email is already registered. Please sign in instead.';
  static const String invalidEmailFirebase =
      'The email address is not valid. Please check and try again.';
  static const String weakPasswordFirebase =
      'The password is too weak. Please choose a stronger password.';
  static const String networkError =
      'Network error. Please check your internet connection and try again.';
  static const String unexpectedError =
      'An unexpected error occurred. Please try again later.';

  // ──── Success ────
  static const String signUpSuccess =
      'Account created successfully! Welcome to Voltify.';
}
