// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:wled_expressive/main.dart';
import 'package:wled_expressive/services/theme_service.dart';
import 'package:wled_expressive/services/locale_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final themeService = ThemeService();
    final localeService = LocaleService(prefs);
    await tester.pumpWidget(
        WledApp(themeService: themeService, localeService: localeService));

    // Verify that the app starts and shows the title
    expect(find.text('WLED'), findsOneWidget);
  });
}
