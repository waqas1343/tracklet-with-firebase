// Main Entry Point - Provider setup aur app initialization
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/users_provider.dart';
import 'providers/settings_provider.dart';

import 'screens/dashboard_screen.dart';
import 'screens/users_screen.dart';
import 'screens/settings_screen.dart';

import 'widgets/custom_app_bar.dart';
import 'widgets/side_navigation.dart';

import 'utils/responsive_helper.dart';

void main() {
  runApp(const SuperAdminApp());
}

class SuperAdminApp extends StatelessWidget {
  const SuperAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<ThemeProvider>(
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
            home: const MainLayout(),
          );
        },
      ),
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

    final screens = [
      const DashboardScreen(),
      const UsersScreen(),
      const Placeholder(), // Analytics placeholder
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.background,
      appBar: CustomAppBar(
        title: _getTitle(dashboardProvider.currentPageIndex),
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
