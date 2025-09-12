// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingTitle1 => 'Welcome to ShopApp';

  @override
  String get onboardingDesc1 => 'Explore thousands of quality products';

  @override
  String get onboardingTitle2 => 'Easy Search';

  @override
  String get onboardingDesc2 => 'Filter, search and view product details';

  @override
  String get onboardingTitle3 => 'Safe Shopping';

  @override
  String get onboardingDesc3 => 'Fast and secure payment';

  @override
  String get appTitle => 'Shopping App';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get searchProduct => 'Search for product...';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get orderNow => 'Order Now';
}
