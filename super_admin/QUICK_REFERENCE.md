# 🚀 Quick Reference Card

Fast lookup for common tasks and customizations.

## 📁 Key Files

| Task | File Location |
|------|---------------|
| Change colors | `lib/utils/style_tokens.dart` |
| Adjust animations | `lib/utils/style_tokens.dart` (animationDurations) |
| Modify breakpoints | `lib/utils/responsive_helper.dart` |
| Update theme | `lib/providers/theme_provider.dart` |
| Add new screen | `lib/screens/your_screen.dart` |
| Create widget | `lib/widgets/your_widget.dart` |
| Sample data | `lib/models/*.dart` (generateSample methods) |

## 🎨 Color Quick Change

### Light Theme Primary Color
```dart
// lib/utils/style_tokens.dart - Line 9
static const primary = Color(0xFF6366F1); // Change this hex
```

### Dark Theme Primary Color
```dart
// lib/utils/style_tokens.dart - Line 33
static const primary = Color(0xFF818CF8); // Change this hex
```

## ⚡ Animation Speed

```dart
// lib/utils/style_tokens.dart - Lines 114-119
static const animationDurations = {
  'fast': Duration(milliseconds: 150),   // Button taps
  'normal': Duration(milliseconds: 300), // Page transitions
  'slow': Duration(milliseconds: 500),   // Complex animations
  'verySlow': Duration(milliseconds: 900), // Initial load
};
```

## 📱 Responsive Breakpoints

```dart
// lib/utils/responsive_helper.dart - Lines 4-6
static const phoneBreakpoint = 600.0;   // < 600 = phone
static const tabletBreakpoint = 900.0;  // 600-900 = tablet
static const desktopBreakpoint = 1200.0; // > 1200 = desktop
```

## 🔢 Spacing Values

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Icon padding |
| sm | 8px | Small gaps |
| md | 12px | Medium gaps |
| base | 16px | Default padding |
| lg | 24px | Section padding |
| xl | 32px | Large spacing |
| xxl | 40px | Extra large |
| xxxl | 48px | Screen padding |

Usage:
```dart
padding: EdgeInsets.all(theme.spacing('lg')) // 24px
```

## 🎭 Common Widgets

### Summary Card
```dart
SummaryCard(
  title: 'Total Users',
  value: 1247,
  icon: Icons.people_rounded,
  color: theme.primary,
  subtitle: '+12% from last month',
  animationDelay: 0,
)
```

### Glass Card
```dart
GlassCard(
  padding: EdgeInsets.all(20),
  child: YourWidget(),
)
```

### Shimmer Loader
```dart
ShimmerLoader(
  width: 100,
  height: 20,
  borderRadius: BorderRadius.circular(8),
)
```

### Animated Counter
```dart
AnimatedCounter(
  value: 1247,
  style: theme.heading2,
  prefix: '\$', // Optional
  suffix: 'K',  // Optional
)
```

## 🎯 Provider Access

### In Widget
```dart
// Read once (no rebuild)
final theme = Provider.of<ThemeProvider>(context, listen: false);

// Listen to changes
final theme = Provider.of<ThemeProvider>(context);

// Specific field only
Consumer<ThemeProvider>(
  builder: (context, theme, child) {
    return Text(theme.primary.toString());
  },
)
```

### Available Providers
- `ThemeProvider` - Colors, text styles, theme toggle
- `DashboardProvider` - Metrics, activities, page index
- `UsersProvider` - User list, search, pagination
- `SettingsProvider` - App preferences

## 🎨 Text Styles

```dart
final theme = Provider.of<ThemeProvider>(context);

Text('Heading 1', style: theme.heading1)   // 32px Bold
Text('Heading 2', style: theme.heading2)   // 24px Bold
Text('Heading 3', style: theme.heading3)   // 20px SemiBold
Text('Body Large', style: theme.bodyLarge) // 16px Regular
Text('Body Medium', style: theme.bodyMedium) // 14px Regular
Text('Body Small', style: theme.bodySmall) // 12px Regular
Text('Caption', style: theme.caption)      // 11px Medium
```

## 🚀 Common Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d chrome      # Web
flutter run -d windows     # Windows
flutter run -d macos       # macOS

# Clean build
flutter clean
flutter pub get
flutter run

# Generate code (if using json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Check for errors
flutter analyze

# Run tests
flutter test

# Format code
flutter format .
```

## 🎬 Page Navigation

### Simple Navigation
```dart
Navigator.push(
  context,
  AnimatedPageRoute(page: YourScreen()),
);
```

### Fade Navigation (Modal-like)
```dart
Navigator.push(
  context,
  FadePageRoute(page: YourScreen()),
);
```

### Go Back
```dart
Navigator.pop(context);
```

## 🔧 Add New Navigation Item

### 1. Add to Side Navigation
```dart
// lib/widgets/side_navigation.dart - Around line 60
_NavItem(
  icon: Icons.your_icon,
  label: 'Your Label',
  isSelected: dashboardProvider.currentPageIndex == 4,
  onTap: () => dashboardProvider.setCurrentPage(4),
),
```

### 2. Add to Bottom Navigation
```dart
// lib/main.dart - Around line 90
BottomNavigationBarItem(
  icon: Icon(Icons.your_icon),
  label: 'Your Label',
),
```

### 3. Add Screen to IndexedStack
```dart
// lib/main.dart - Around line 75
final screens = [
  const DashboardScreen(),
  const UsersScreen(),
  const YourNewScreen(), // Add here
  const SettingsScreen(),
];
```

## 🎨 Theme Colors

### Access in Code
```dart
final theme = Provider.of<ThemeProvider>(context);

Container(
  color: theme.primary,      // Primary color
  child: Text(
    'Hello',
    style: TextStyle(color: theme.textPrimary),
  ),
)
```

### Available Colors
```dart
theme.primary
theme.secondary
theme.background
theme.surface
theme.surfaceVariant
theme.textPrimary
theme.textSecondary
theme.textMuted
theme.success
theme.warning
theme.error
theme.info
theme.divider
```

## 🎭 Shadows

```dart
Container(
  decoration: BoxDecoration(
    boxShadow: theme.shadowSm,  // Small shadow
    boxShadow: theme.shadowMd,  // Medium shadow
    boxShadow: theme.shadowLg,  // Large shadow
  ),
)
```

## 📊 Sample Data

### Generate Users
```dart
final users = UserModel.generateSampleUsers(50);
```

### Generate Activities
```dart
final activities = ActivityModel.generateSampleActivities(20);
```

## ♿ Accessibility

### Add Tooltip
```dart
IconButton(
  icon: Icon(Icons.search),
  onPressed: () {},
  tooltip: 'Search users', // Screen reader
)
```

### Semantic Label
```dart
Semantics(
  label: 'Dashboard metric card',
  child: SummaryCard(...),
)
```

## 🐛 Debugging

### Print Provider State
```dart
debugPrint('Current page: ${dashboardProvider.currentPageIndex}');
```

### Hot Reload
Press `r` in terminal

### Hot Restart
Press `R` in terminal (capital R)

### Open DevTools
```bash
flutter run
# Then press 'd' in terminal
```

## 📦 Add New Dependency

1. Add to `pubspec.yaml`:
```yaml
dependencies:
  your_package: ^1.0.0
```

2. Install:
```bash
flutter pub get
```

3. Import in file:
```dart
import 'package:your_package/your_package.dart';
```

## 🎯 Change App Name/Icon

### App Name
Edit in:
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

### App Icon
Use `flutter_launcher_icons` package:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
```

Run:
```bash
flutter pub run flutter_launcher_icons
```

## ✨ Tips

1. **Use const**: Add `const` to widgets that don't change
2. **listen: false**: Use when you don't need rebuilds
3. **Keys**: Add keys to lists for better performance
4. **Lazy loading**: Use ListView.builder for long lists
5. **Cache images**: Use cached_network_image package

## 📞 Quick Help

| Issue | Solution |
|-------|----------|
| Assets not loading | `flutter clean && flutter pub get` |
| Build errors | Delete `build/` folder, run again |
| Hot reload not working | Hot restart (R) |
| Provider not updating | Check notifyListeners() called |
| Theme not persisting | Check SharedPreferences permissions |

---

**Remember**: Save this file for quick reference! 🚀

