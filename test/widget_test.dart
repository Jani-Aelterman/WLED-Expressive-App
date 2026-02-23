// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:wled_material3/main.dart';
import 'package:wled_material3/services/theme_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final themeService = ThemeService();
    await tester.pumpWidget(WledApp(themeService: themeService));

    // Verify that the app starts and shows the title
    expect(find.text('WLED'), findsOneWidget);
  });
}
