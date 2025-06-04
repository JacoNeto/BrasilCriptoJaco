# Brasil Cripto

A Flutter cryptocurrency app that allows users to search and favorite cryptocurrencies using the CoinGecko API.

## Features

- 🔍 Search cryptocurrencies by name or symbol
- ⭐ Add/remove favorites with local storage
- 📱 Beautiful gradient UI with crypto-themed design
- 💾 Persistent favorites using Hive
- 🔄 Real-time synchronization between screens

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- A CoinGecko API key

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd brasil_cripto
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Create API Keys file**
   
   Create a file called `api_keys.json` in the root directory of the project:
   ```json
   {
       "COINGECKO_API_KEY": "your_api_key_here"
   }
   ```
   
   **How to get a CoinGecko API key:**
   - Visit [CoinGecko API](https://www.coingecko.com/en/api)
   - Sign up for a free account
   - Get your API key from the dashboard
   - Replace `your_api_key_here` with your actual API key

4. **Run the app**
   ```bash
   flutter run --dart-define-from-file=api_keys.json
   ```

## Project Structure

```
lib/
├── core/
│   ├── app_theme.dart          # App theme and colors
│   ├── intercepts/             # Error handling
│   └── utils/                  # Utility classes
├── data/
│   ├── repositories/           # Data layer implementations
│   └── services/              # External services (API, Hive)
├── domain/
│   ├── models/                # Data models
│   └── repositories/          # Repository interfaces
└── ui/
    ├── view/                  # Screens
    ├── view_model/            # State management
    └── core/                  # Reusable UI components
```

## Architecture

This project follows **Clean Architecture** principles with:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI and state management

**State Management**: Provider pattern with reactive streams
**Local Storage**: Hive for favorites persistence
**API Integration**: HTTP with proper error handling

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
