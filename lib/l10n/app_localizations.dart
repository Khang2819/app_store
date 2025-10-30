import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('vi')
  ];

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ShopApp'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Explore thousands of quality products'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Easy Search'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Filter, search and view product details'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Safe Shopping'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Fast and secure payment'**
  String get onboardingDesc3;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping App'**
  String get appTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @or_login_with.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get or_login_with;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reset_password;

  /// No description provided for @send_request.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get send_request;

  /// No description provided for @reset_password_description.
  ///
  /// In en, this message translates to:
  /// **'Please enter your registered email to receive the password reset link.'**
  String get reset_password_description;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get dont_have_account;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_account;

  /// No description provided for @name_empty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get name_empty;

  /// No description provided for @name_too_short.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get name_too_short;

  /// No description provided for @email_empty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get email_empty;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get email_invalid;

  /// No description provided for @password_empty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get password_empty;

  /// No description provided for @password_too_short.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_too_short;

  /// No description provided for @confirm_password_empty.
  ///
  /// In en, this message translates to:
  /// **'Confirm password cannot be empty'**
  String get confirm_password_empty;

  /// No description provided for @reset_password_email_sent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email has been sent!'**
  String get reset_password_email_sent;

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get login_success;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success 🎉'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error ❌'**
  String get error;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get register_success;

  /// No description provided for @forgot_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password reset email has been sent!'**
  String get forgot_password_success;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknown_error;

  /// No description provided for @google_sign_in_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was cancelled.'**
  String get google_sign_in_cancelled;

  /// No description provided for @google_sign_in_failed.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during Google sign-in.'**
  String get google_sign_in_failed;

  /// No description provided for @invalid_credential.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get invalid_credential;

  /// No description provided for @email_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'This email address is already in use.'**
  String get email_already_in_use;

  /// No description provided for @weak_password.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get weak_password;

  /// No description provided for @confirm_password_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get confirm_password_not_match;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search for product...'**
  String get searchProduct;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @cart_empty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cart_empty;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
