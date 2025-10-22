# Testing Guide - Super Admin Dashboard

Complete testing strategy for the Super Admin dashboard application.

## 🧪 Testing Strategy

### Test Types
1. **Widget Tests** - UI components
2. **Provider Tests** - State management
3. **Integration Tests** - Full app flow
4. **Performance Tests** - Rendering & memory

## 📝 Widget Tests

### Setup
Create test files in `test/` folder:

```
test/
├── widgets/
│   ├── summary_card_test.dart
│   ├── shimmer_loader_test.dart
│   └── user_row_test.dart
├── providers/
│   ├── theme_provider_test.dart
│   ├── dashboard_provider_test.dart
│   └── users_provider_test.dart
└── screens/
    ├── dashboard_screen_test.dart
    └── users_screen_test.dart
```

### Example: Theme Provider Test

```dart
// test/providers/theme_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:super_admin/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeProvider Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial theme is light mode', () {
      final provider = ThemeProvider();
      expect(provider.isDarkMode, false);
    });

    test('Toggle theme changes isDarkMode', () async {
      final provider = ThemeProvider();
      await provider.toggleTheme();
      expect(provider.isDarkMode, true);
    });

    test('Theme preference persists', () async {
      final provider = ThemeProvider();
      await provider.toggleTheme();
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isDarkMode'), true);
    });
  });
}
```

### Example: Summary Card Widget Test

```dart
// test/widgets/summary_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:super_admin/widgets/summary_card.dart';
import 'package:super_admin/providers/theme_provider.dart';

void main() {
  testWidgets('SummaryCard displays correct value', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: 'Total Users',
              value: 1247,
              icon: Icons.people_rounded,
              color: Colors.blue,
              animationDelay: 0,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    expect(find.text('Total Users'), findsOneWidget);
    expect(find.text('1247'), findsOneWidget);
  });

  testWidgets('SummaryCard has proper accessibility', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: SummaryCard(
              title: 'Total Users',
              value: 1247,
              icon: Icons.people_rounded,
              color: Colors.blue,
              animationDelay: 0,
            ),
          ),
        ),
      ),
    );

    final card = tester.widget<SummaryCard>(find.byType(SummaryCard));
    expect(card, isNotNull);
  });
}
```

### Example: Dashboard Screen Test

```dart
// test/screens/dashboard_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:super_admin/screens/dashboard_screen.dart';
import 'package:super_admin/providers/theme_provider.dart';
import 'package:super_admin/providers/dashboard_provider.dart';

void main() {
  testWidgets('Dashboard shows shimmer when loading', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ],
        child: const MaterialApp(
          home: Scaffold(body: DashboardScreen()),
        ),
      ),
    );

    // Initially shows shimmer
    expect(find.byType(SummaryCardShimmer), findsWidgets);
    
    // Wait for data to load
    await tester.pumpAndSettle();
    
    // Shimmer should be gone
    expect(find.byType(SummaryCardShimmer), findsNothing);
  });
}
```

## 🔄 Provider Tests

### Example: Users Provider Test

```dart
// test/providers/users_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:super_admin/providers/users_provider.dart';

void main() {
  group('UsersProvider Tests', () {
    test('Search filters users correctly', () async {
      final provider = UsersProvider();
      await Future.delayed(const Duration(milliseconds: 700));
      
      final initialCount = provider.filteredUsers.length;
      provider.searchUsers('Ahmed');
      
      expect(provider.filteredUsers.length, lessThan(initialCount));
    });

    test('Pagination works correctly', () {
      final provider = UsersProvider();
      
      expect(provider.currentPage, 0);
      provider.nextPage();
      expect(provider.currentPage, 1);
      provider.previousPage();
      expect(provider.currentPage, 0);
    });

    test('Toggle user status updates correctly', () async {
      final provider = UsersProvider();
      await Future.delayed(const Duration(milliseconds: 700));
      
      final user = provider.paginatedUsers.first;
      final initialStatus = user.isActive;
      
      await provider.toggleUserStatus(user.id);
      
      final updatedUser = provider.paginatedUsers
        .firstWhere((u) => u.id == user.id);
      expect(updatedUser.isActive, !initialStatus);
    });
  });
}
```

## 🎯 Integration Tests

Create `integration_test/` folder:

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:super_admin/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full App Test', () {
    testWidgets('Complete user flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Users
      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();

      // Search for user
      await tester.enterText(
        find.byType(TextField), 
        'Ahmed'
      );
      await tester.pumpAndSettle();

      // Verify search results
      expect(find.text('Ahmed'), findsWidgets);

      // Tap on user
      await tester.tap(find.text('Ahmed Khan').first);
      await tester.pumpAndSettle();

      // Verify details sheet opened
      expect(find.text('Email'), findsOneWidget);

      // Go back
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
    });

    testWidgets('Theme toggle persists', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Toggle to dark mode
      await tester.tap(find.byIcon(Icons.dark_mode_rounded));
      await tester.pumpAndSettle();

      // Verify dark mode active
      final lightModeIcon = find.byIcon(Icons.light_mode_rounded);
      expect(lightModeIcon, findsOneWidget);

      // Restart app
      await tester.pumpWidget(Container());
      app.main();
      await tester.pumpAndSettle();

      // Verify still in dark mode
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    });
  });
}
```

## 🚀 Running Tests

### All Tests
```bash
flutter test
```

### Specific Test File
```bash
flutter test test/providers/theme_provider_test.dart
```

### With Coverage
```bash
flutter test --coverage
```

### Integration Tests
```bash
flutter test integration_test/app_test.dart
```

## 📊 Performance Tests

### Frame Timing Test
```dart
testWidgets('Dashboard renders without jank', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();

  final binding = tester.binding;
  await binding.tracing.enable();
  
  await tester.fling(
    find.byType(ListView),
    const Offset(0, -300),
    1000,
  );
  
  await tester.pumpAndSettle();
  
  final timeline = await binding.tracing.disable();
  // Analyze timeline for jank
});
```

### Memory Test
```bash
flutter run --profile
# Then use DevTools to monitor memory
```

## ♿ Accessibility Tests

```dart
testWidgets('All tappable elements meet size requirements', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();

  final buttons = find.byType(IconButton);
  
  for (var i = 0; i < tester.widgetList(buttons).length; i++) {
    final button = tester.widget<IconButton>(buttons.at(i));
    final size = tester.getSize(buttons.at(i));
    
    expect(
      size.width >= 48 && size.height >= 48,
      true,
      reason: 'Button must be at least 48x48px',
    );
  }
});
```

## 📈 Test Coverage

### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Target Coverage
- **Providers**: 80%+
- **Widgets**: 70%+
- **Screens**: 60%+
- **Overall**: 70%+

## 🐛 Debugging Tests

### Enable Verbose Output
```bash
flutter test --verbose
```

### Debug Specific Test
```bash
flutter test --plain-name "Test name here"
```

### Test in Chrome
```bash
flutter test --platform chrome
```

## ✅ Test Checklist

Before releasing:
- [ ] All widget tests pass
- [ ] Provider state management tests pass
- [ ] Integration tests complete successfully
- [ ] No accessibility violations
- [ ] Performance benchmarks met
- [ ] Code coverage > 70%
- [ ] No memory leaks detected
- [ ] All linter warnings resolved

## 🔧 CI/CD Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter analyze
```

## 📚 Additional Resources

- [Flutter Testing Docs](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

---

**Remember**: Tests are documentation. Write clear, maintainable tests!

