import 'package:bloc_app/l10n/app_localizations.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnboardingItem> getOnboardingItems(AppLocalizations language) {
  return [
    OnboardingItem(
      title: language.onboardingTitle1,
      description: language.onboardingDesc1,
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingItem(
      title: language.onboardingTitle2,
      description: language.onboardingDesc2,
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingItem(
      title: language.onboardingTitle3,
      description: language.onboardingDesc3,
      image: 'assets/images/onboarding3.png',
    ),
  ];
}
