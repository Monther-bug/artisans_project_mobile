class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password too short (min 6 chars)';
    }
    return null;
  }

  static String? validateRequired(
    String? value, {
    String message = 'Required',
  }) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
