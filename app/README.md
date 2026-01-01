# Ledgerly Mobile App

Flutter mobile application for Ledgerly billing and payment tracking system.

## Setup

1. Install Flutter SDK (if not already installed)
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate code (for Riverpod, Retrofit, JSON serialization):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Features

- Authentication (Login/Signup)
- Dashboard with outstanding balances
- Customer management
- Bill creation and tracking
- Payment processing with OCR receipt scanning
- Multi-organization support

## API Configuration

Update the API base URL in `lib/config/api_config.dart` to point to your backend.

