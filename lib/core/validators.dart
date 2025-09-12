class Validators {
  static String? validateName(String name) {
    if (name.isEmpty) return "Tên không được để trống";
    if (name.length < 3) return "Tên phải có ít nhất 3 ký tự";
    return null;
  }

  static String? validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (email.isEmpty) return "Email không được để trống";
    if (!emailRegex.hasMatch(email)) return "Email không hợp lệ";
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return "Mật khẩu không được để trống";
    if (password.length < 6) return "Mật khẩu phải có ít nhất 6 ký tự";
    return null;
  }

  static String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) return "Xác nhận mật khẩu không được để trống";
    if (password != confirmPassword) return "Mật khẩu xác nhận không khớp";
    return null;
  }
}
