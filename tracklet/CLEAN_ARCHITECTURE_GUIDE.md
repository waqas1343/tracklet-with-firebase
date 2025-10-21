# Clean Architecture Quick Reference

## 🎯 Core Principle

**`main.dart` must remain completely clean**
- Only `void main()` and `runApp()`
- No logic, no services, no MultiProvider setup

## 📁 Key Files

### 1. `main.dart` - The Cleanest Entry Point ✨

```dart
void main() async {
  final initializer = AppInitializer();
  await initializer.initialize();
  
  runApp(
    AppProvider(
      storageService: initializer.storageService,
      apiService: initializer.apiService,
      authService: initializer.authService,
      child: const MyApp(),
    ),
  );
}
```

**That's it! Only 10 lines of code!**

---

### 2. `AppInitializer` - Service Setup

**Location**: `lib/core/app/app_initializer.dart`

**Purpose**: Initialize all services before the app starts

```dart
class AppInitializer {
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Storage
    _storageService = StorageService();
    await _storageService!.init();
    
    // Initialize API
    _apiService = ApiService();
    
    // Initialize Auth
    _authService = AuthService(
      apiService: _apiService!,
      storageService: _storageService!,
    );
  }
}
```

---

### 3. `AppProvider` - Central Provider Hub 🎯

**Location**: `lib/core/providers/app_provider.dart`

**Purpose**: Single class that handles ALL provider registration

```dart
class AppProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<StorageService>.value(value: storageService),
        Provider<ApiService>.value(value: apiService),
        Provider<AuthService>.value(value: authService),
        
        // Feature Providers (ViewModels)
        ChangeNotifierProvider(create: (_) => AuthProvider(...)),
        ChangeNotifierProvider(create: (_) => OrderProvider(...)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(...)),
        // ... all other providers
      ],
      child: child,
    );
  }
}
```

**All providers in ONE place!**

---

### 4. `app.dart` - Root Widget

**Location**: `lib/app.dart`

**Purpose**: MaterialApp configuration

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, _) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
```

---

## 🏗️ Architecture Layers

```
┌──────────────────────────────────────┐
│         main.dart (Entry)            │  ← Only initialization
├──────────────────────────────────────┤
│    AppInitializer (Setup)            │  ← Service creation
├──────────────────────────────────────┤
│    AppProvider (DI Container)        │  ← Provider registration
├──────────────────────────────────────┤
│         MyApp (Root Widget)          │  ← MaterialApp config
├──────────────────────────────────────┤
│      Views (UI Components)           │  ← User interface
├──────────────────────────────────────┤
│   ViewModels (Providers)             │  ← Business logic
├──────────────────────────────────────┤
│    Services (Infrastructure)         │  ← API, Storage, etc.
└──────────────────────────────────────┘
```

---

## 📂 Folder Structure

```
lib/
├── main.dart                    ← Entry point (CLEAN!)
├── app.dart                     ← Root widget
│
├── core/
│   ├── app/
│   │   └── app_initializer.dart ← Service initialization
│   ├── providers/
│   │   └── app_provider.dart    ← Provider hub 🎯
│   ├── models/                  ← Data models
│   ├── services/                ← Infrastructure
│   ├── routes/                  ← Navigation
│   └── utils/                   ← Helpers
│
├── features/                    ← MVVM structure
│   ├── common/
│   │   ├── provider/           ← ViewModels
│   │   └── view/               ← UI screens
│   ├── gas_plant/
│   │   ├── provider/
│   │   └── view/
│   └── distributor/
│       ├── provider/
│       └── view/
│
└── shared/
    └── widgets/                 ← Reusable components
```

---

## 🔄 MVVM Pattern

### Model
```dart
// core/models/order_model.dart
class OrderModel {
  final String id;
  final String customerName;
  final double amount;
  
  OrderModel({required this.id, ...});
  
  factory OrderModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

### ViewModel (Provider)
```dart
// features/gas_plant/provider/order_provider.dart
class OrderProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  
  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _apiService.get('/orders');
      _orders = response['orders']
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### View
```dart
// features/gas_plant/view/orders_screen.dart
class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        if (orderProvider.isLoading) {
          return LoadingWidget();
        }
        
        return ListView.builder(
          itemCount: orderProvider.orders.length,
          itemBuilder: (context, index) {
            final order = orderProvider.orders[index];
            return OrderCard(order: order);
          },
        );
      },
    );
  }
}
```

---

## ➕ Adding a New Feature

### Step 1: Create Folder Structure
```
features/new_feature/
├── provider/
│   └── new_feature_provider.dart
└── view/
    └── new_feature_screen.dart
```

### Step 2: Create Provider (ViewModel)
```dart
class NewFeatureProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  NewFeatureProvider({required ApiService apiService})
      : _apiService = apiService;
  
  // Add your state and methods
}
```

### Step 3: Register in AppProvider
```dart
// In core/providers/app_provider.dart
ChangeNotifierProvider<NewFeatureProvider>(
  create: (_) => NewFeatureProvider(apiService: apiService),
),
```

### Step 4: Create View
```dart
class NewFeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewFeatureProvider>(
      builder: (context, provider, _) {
        // Build your UI
      },
    );
  }
}
```

**Done! No changes to `main.dart` needed! ✅**

---

## 💡 Rules to Follow

### ✅ DO

1. **Keep `main.dart` clean**
   - Only initialization and `runApp()`

2. **Use `AppProvider` for all providers**
   - Single source of truth
   - All providers in one place

3. **Follow MVVM pattern**
   - Models: Data structures
   - Views: UI components
   - ViewModels: Business logic (Providers)

4. **Inject dependencies**
   - Pass services through constructors
   - Use dependency injection

5. **Call `notifyListeners()`**
   - After every state change in providers

### ❌ DON'T

1. **Don't add logic to `main.dart`**
   - Keep it minimal

2. **Don't create providers in views**
   - Always use `Consumer` or `Provider.of()`

3. **Don't put business logic in views**
   - Delegate to ViewModels

4. **Don't access services from views**
   - Go through ViewModels

5. **Don't use global variables**
   - Use dependency injection

---

## 🎯 Benefits

### Clean Code
- Easy to read and understand
- Clear separation of concerns
- Minimal coupling

### Testability
- Mock services easily
- Test ViewModels independently
- Test views with mock providers

### Scalability
- Add features without touching core
- No `main.dart` modifications
- Modular architecture

### Maintainability
- Find code quickly
- Change features independently
- Clear dependencies

---

## 📊 Comparison

### Before ❌
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storage = StorageService();
  await storage.init();
  
  final api = ApiService();
  final auth = AuthService(api, storage);
  
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storage),
        Provider<ApiService>.value(value: api),
        Provider<AuthService>.value(value: auth),
        ChangeNotifierProvider(create: (_) => AuthProvider(auth)),
        ChangeNotifierProvider(create: (_) => OrderProvider(api)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(storage)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(storage)),
        // ... 20 more providers
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, theme, lang, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            // ... 20 more lines
          );
        },
      ),
    ),
  );
}
```

**104 lines of cluttered code! 😱**

---

### After ✅
```dart
void main() async {
  final initializer = AppInitializer();
  await initializer.initialize();
  
  runApp(
    AppProvider(
      storageService: initializer.storageService,
      apiService: initializer.apiService,
      authService: initializer.authService,
      child: const MyApp(),
    ),
  );
}
```

**Only 10 lines! Clean and elegant! ✨**

---

## 🚀 Summary

This architecture provides:

1. **Clean `main.dart`** - Only initialization
2. **Centralized providers** - All in `AppProvider`
3. **MVVM pattern** - Clear separation
4. **Easy testing** - Mockable dependencies
5. **Scalable structure** - Add features easily

**Your app is production-ready! 🎉**

