class Validators {
  static String? validateName(String name) {
    if (name.isEmpty) return 'name_empty';
    if (name.length < 3) return 'name_too_short';
    return null;
  }

  static String? validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (email.isEmpty) return 'email_empty';
    if (!emailRegex.hasMatch(email)) return 'email_invalid';
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'password_empty';
    if (password.length < 6) return 'password_too_short';
    return null;
  }

  static String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) return 'confirm_password_empty';
    if (password != confirmPassword) return 'confirm_password_not_match';
    return null;
  }
}
