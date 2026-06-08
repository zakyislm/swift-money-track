# 💰 Swift — Keuanganku

> **Neobrutalist High-Contrast Budget Tracker** built with Flutter & Dart

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📸 Preview

A bold, high-contrast financial tracking application with a **Neobrutalist** design language — featuring sharp borders, vivid colors, and a dark carbon canvas.

## ✨ Features

- **🏠 Dashboard** — Real-time balance overview, income/expense metrics, and financial trend charts
- **📊 Monthly Overview** — 12-month cashflow summary with estimation capability for future months
- **📜 Transaction History** — Searchable, filterable transaction list grouped by date
- **➕ Add Transactions** — Quick-add dialog with category selection, date/time pickers
- **🔔 Notifications** — In-app notification drawer for transaction alerts
- **💾 Local Persistence** — All data saved locally via SharedPreferences
- **📱 Responsive** — Desktop sidebar navigation + mobile bottom navigation
- **🎨 Neobrutalist UI** — Bold borders, high contrast, custom NeoCard & NeoButton widgets

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| Charts | fl_chart ^0.66.0 |
| Icons | lucide_flutter ^1.0.0 |
| Storage | shared_preferences ^2.2.0 |
| Formatting | intl ^0.19.0 |

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point & main layout
├── data/
│   └── initial_data.dart        # Seed data, categories, monthly summaries
├── models/
│   ├── transaction.dart         # Transaction model (JSON serialization)
│   └── notification_item.dart   # Notification model
├── views/
│   ├── beranda_view.dart        # Dashboard view
│   ├── ikhtisar_view.dart       # Monthly overview view
│   └── riwayat_view.dart        # Transaction history view
└── widgets/
    ├── neo_card.dart            # Neobrutalist card widget
    ├── neo_button.dart          # Neobrutalist button widget
    └── add_transaction_dialog.dart  # Transaction form dialog
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/zakyislm/swift-money-track.git
   cd flutter_keuanganku
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Web
flutter build web --release
```

## 🎨 Design System

### Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Neon Yellow | `#FFE600` | Primary accent, CTAs |
| Neon Green | `#2DE17F` | Income indicators |
| Neon Pink | `#FF2E93` | Expense indicators |
| Carbon Dark | `#121415` | Background canvas |
| Surface Dark | `#1C1E1F` | Card surfaces |

### UI Components

- **NeoCard** — Container with solid black border and hard shadow offset
- **NeoButton** — Pressable button with shadow animation on tap
- Variants: `yellow`, `green`, `pink`, `dark`, `gray`, `white`, `surface`, `bright`

## 📋 Usage Guide

### Adding a Transaction

1. Tap the yellow **FAB (+)** button (visible on all screens)
2. Select **Income** or **Outflow**
3. Fill in: Name, Amount, Category, Date, Time, and optional Notes
4. Tap **Save Transaction**

### Viewing Monthly Overview

1. Navigate to **Overview** tab
2. View active months with real data
3. Click **Estimation** on pending months to generate forecasts
4. Tap **Detail** on any month for full breakdown

### Searching Transaction History

1. Navigate to **History** tab
2. Use the search bar to filter by name, category, or notes
3. Toggle between **All**, **Income**, and **Outflow** tabs
4. Delete transactions using the trash icon

## 💾 Data Persistence

All application state is persisted locally using `SharedPreferences`:

- `keuanganku_transactions` — Transaction list (JSON)
- `keuanganku_notifications` — Notification list (JSON)
- `keuanganku_monthly_summaries` — Monthly summaries (JSON)

Data is automatically saved on every mutation (add/delete transactions, estimations).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👤 Author

**Zaky Ismail** — [github.com/zakyislm](https://github.com/zakyislm)

---

> *Track your money with brutal clarity.* 💸