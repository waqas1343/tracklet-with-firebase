// Super Admin Dashboard Widget Tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:super_admin/main.dart';

void main() {
  testWidgets('App starts and shows dashboard', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SuperAdminApp());

    // Wait for theme to load
    await tester.pumpAndSettle();

    // Verify that dashboard screen appears
    expect(find.text('Dashboard Overview'), findsOneWidget);
  });

  testWidgets('Bottom navigation shows on mobile', (WidgetTester tester) async {
    // Set mobile screen size
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const SuperAdminApp());
    await tester.pumpAndSettle();

    // Verify bottom navigation exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Clean up
    addTearDown(tester.view.reset);
  });

  testWidgets('Dashboard shows summary cards', (WidgetTester tester) async {
    await tester.pumpWidget(const SuperAdminApp());
    await tester.pumpAndSettle();

    // Wait for shimmer to complete and data to load
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    // Verify summary cards appear
    expect(find.text('Total Users'), findsOneWidget);
    expect(find.text('Active Users'), findsOneWidget);
  });
}
