// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get onboardingTitle1 => 'ShopAppへようこそ';

  @override
  String get onboardingDesc1 => '何千もの高品質な商品を探索';

  @override
  String get onboardingTitle2 => '簡単検索';

  @override
  String get onboardingDesc2 => 'フィルター、検索、商品の詳細を確認';

  @override
  String get onboardingTitle3 => '安全なショッピング';

  @override
  String get onboardingDesc3 => '迅速かつ安全な支払い';

  @override
  String get appTitle => 'ショッピングアプリ';

  @override
  String get login => 'ログイン';

  @override
  String get register => '登録';

  @override
  String get searchProduct => '商品を検索...';

  @override
  String get addToCart => 'カートに追加';

  @override
  String get orderNow => '今すぐ注文';
}
