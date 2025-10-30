import '../l10n/app_localizations.dart';

class LocalizationUtils {
  /// Dịch một mã lỗi (error key) từ BLoC sang văn bản
  /// đã được bản địa hóa (đa ngôn ngữ).
  static String? translateError(String? errorKey, AppLocalizations language) {
    if (errorKey == null) return null;

    switch (errorKey) {
      // Lỗi chung
      case 'name_empty':
        return language.name_empty;
      case 'name_too_short':
        return language.name_too_short;
      case 'email_empty':
        return language.email_empty;
      case 'email_invalid':
        return language.email_invalid;
      case 'password_empty':
        return language.password_empty;
      case 'password_too_short':
        return language.password_too_short;
      case 'confirm_password_empty':
        return language.confirm_password_empty;
      case 'confirm_password_not_match':
        return language.confirm_password_not_match;

      // Bạn cũng có thể thêm các mã lỗi khác ở đây
      // case 'user-not-found':
      //   return 'Email không tồn tại';
      case 'invalid_credential':
        return language.invalid_credential;
      case 'email_already_in_use':
        return language.email_already_in_use;
      case 'weak_password':
        return language.weak_password;
      case 'unknown_error':
        return language.unknown_error;
      // LỖI GOOGLE (THÊM MỚI)
      case 'google_sign_in_cancelled':
        return language.google_sign_in_cancelled;
      case 'google_sign_in_failed':
        return language.google_sign_in_failed;

      default:
        // Nếu không có mã lỗi nào khớp,
        // hãy trả về chính mã lỗi đó để lập trình viên biết
        return errorKey;
    }
  }
}
