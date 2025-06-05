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
│   ├── intercepts/             # Error handling
│   └── utils/                  # Utility classes
├── data/
│   ├── repositories/           # Data layer implementations
│   └── services/              # External services (API, Hive)
├── domain/
│   ├── models/                # Data models
│   └── repositories/          # Repository interfaces
└── ui/
    ├── view/                  # Screens (Views)
    ├── view_model/            # ViewModels for state management
    └── design_system/         # Reusable UI components and design system
```

## Architecture

This project implements **MVVM (Model-View-ViewModel)** architecture with **Clean Architecture** principles and **SOLID** design patterns:

### 🏗️ **MVVM Pattern**
- **Model**: Domain entities and business logic (`domain/` layer)
- **View**: UI screens and widgets (`ui/view/`)  
- **ViewModel**: State management and UI logic (`ui/view_model/`)

### 🎯 **Multilayer Architecture**
- **Presentation Layer** (`ui/`): Views, ViewModels, and Design System
- **Domain Layer** (`domain/`): Business logic, entities, and repository interfaces
- **Data Layer** (`data/`): Repository implementations, API services, and local storage

### 💎 **SOLID Principles Applied**
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Extensions via interfaces without modifying existing code
- **Liskov Substitution**: Repository abstractions allow implementation swapping
- **Interface Segregation**: Small, focused repository interfaces
- **Dependency Inversion**: High-level modules depend on abstractions

### 🔧 **Technical Implementation**
- **State Management**: Provider pattern with reactive streams
- **Local Storage**: Hive for favorites persistence  
- **API Integration**: HTTP with proper error handling using Either pattern
- **Reactive Architecture**: Stream-based cross-widget synchronization
- **Error Handling**: Centralized failure management with DRY principles

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
