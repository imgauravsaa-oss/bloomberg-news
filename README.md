# Claude Terminal — Bloomberg News App (Flutter)

A Bloomberg Terminal-style live world news Android app powered by Claude AI + web search.

---

## Setup

### 1. Prerequisites
- Flutter SDK 3.0+
- Android Studio / VS Code
- Anthropic API key

### 2. Add Your API Key
Open `lib/services/news_service.dart` and replace:
```dart
static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY';
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run
```bash
flutter run
```

### 5. Build APK
```bash
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## Features

| Feature | Details |
|---|---|
| **Live News** | Claude searches the web for real breaking news |
| **Auto Refresh** | Configurable 1–30 min interval |
| **Region Filters** | ALL / EUROPE / ASIA / AMERICAS / MIDDLE EAST / AFRICA |
| **Category Tags** | POLITICS / CONFLICT / ECONOMY / CLIMATE / DIPLOMACY / TECH / HEALTH |
| **Breaking Feed** | Dedicated screen for high-urgency stories |
| **Scrolling Ticker** | Live headline ticker at the top |
| **Story Detail** | Full summary + urgency meter |
| **Settings** | Refresh interval, stats, API info |

---

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/
│   └── news_article.dart      # Data model
├── services/
│   ├── news_service.dart      # Claude API calls
│   └── news_provider.dart     # State management
├── screens/
│   ├── home_screen.dart       # Main feed
│   ├── detail_screen.dart     # Story detail
│   └── settings_screen.dart   # Settings
├── widgets/
│   ├── news_card.dart         # Headline row card
│   └── ticker_tape.dart       # Scrolling ticker
└── theme/
    └── terminal_theme.dart    # Colors, fonts, styles
```

---

## Design
- **Dark terminal aesthetic** — `#0A0C0F` background, amber `#FF8C00` accents
- **Monospace typography** throughout for terminal feel
- **Animated urgency dots** pulse red for breaking stories
- **Category color coding** — each topic has its own color chip
- **Left urgency border** — red/amber/dim based on urgency level
