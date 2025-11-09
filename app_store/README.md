lib/
├── main.dart # Entry point of your application
├── firebase_options.dart # Firebase configuration
├── l10n/ # Localization files for different languages
│ ├── app_localizations.dart # Localization logic
│ ├── vi.arb # Vietnamese language strings
│ ├── en.arb # English language strings
│ └── ja.arb # Japanese language strings
├── routes/ # App routing configuration
│ └── app_router.dart
├── core/ # Core functionalities
│ ├── constants.dart # Constants used throughout the app
│ ├── themes.dart # Theme configurations including Dark mode
│ └── localization_helper.dart # Helper functions for localization
├── data/ # Data layer
│ ├── models/ # Data models
│ ├── repositories/ # Data repositories
│ └── datasources/ # Data sources (e.g., Firestore)
└── presentation/ # Presentation layer
├── blocs/ # BLoCs for business logic
├── screens/ # Screens organized by functionality
│ ├── login/ # Login screen
│ ├── register/ # Registration screen
│ ├── home/ # Home screen
│ ├── product_detail/ # Product detail screen
│ ├── cart/ # Cart screen
│ ├── wishlist/ # Wishlist screen
│ ├── order/ # Order management screen
│ ├── chat/ # Chat with shop screen
│ └── admin/ # Admin panel screens
└── widgets/ # Reusable widgets
