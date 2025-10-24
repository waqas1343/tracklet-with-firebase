import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/theme_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/login_provider.dart';
import 'providers/users_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/users_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/custom_app_bar.dart';
import 'utils/responsive_helper.dart';
import 'widgets/side_navigation.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        if (themeProvider.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Super Admin Dashboard',
          theme: themeProvider.themeData,
          home: Consumer<LoginProvider>(
            builder: (context, loginProvider, _) {
              if (loginProvider.isLoggedIn) {
                return const MainLayout();
              } else {
                return const LoginScreen();
              }
            },
          ),
        );
      },
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.useMobileLayout(context);

    return isMobile ? const _MobileLayout() : const _DesktopLayout();
  }
}

// Mobile Layout - Bottom Navigation
class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    final screens = [
      const DashboardScreen(),
      const UsersScreen(),
      const Placeholder(), // Analytics placeholder
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Text(_getTitle(dashboardProvider.currentPageIndex)),
        backgroundColor: theme.surface,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: theme.error),
            onPressed: () {
              // Show confirmation dialog
              showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              ).then((confirm) {
                if (confirm == true) {
                  // Perform logout
                  loginProvider.logout();
                  // Navigate to login screen
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                }
              });
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: dashboardProvider.currentPageIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: theme.shadowMd),
        child: BottomNavigationBar(
          currentIndex: dashboardProvider.currentPageIndex,
          onTap: (index) => dashboardProvider.setCurrentPage(index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.surface,
          selectedItemColor: theme.primary,
          unselectedItemColor: theme.textMuted,
          selectedLabelStyle: theme.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: theme.caption,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_rounded),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Users';
      case 2:
        return 'Analytics';
      case 3:
        return 'Settings';
      default:
        return 'Super Admin';
    }
  }
}

// Desktop/Tablet Layout - Side Navigation
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    final screens = [
      const DashboardScreen(),
      const UsersScreen(),
      const Placeholder(), // Analytics placeholder
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.background,
      body: Row(
        children: [
          // Side Navigation
          const SideNavigation(),

          // Main Content
          Expanded(
            child: Column(
              children: [
                CustomAppBar(
                  title: _getTitle(dashboardProvider.currentPageIndex),
                  showSearch: true,
                ),
                Expanded(
                  child: IndexedStack(
                    index: dashboardProvider.currentPageIndex,
                    children: screens,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Users';
      case 2:
        return 'Analytics';
      case 3:
        return 'Settings';
      default:
        return 'Super Admin';
    }
  }
}
