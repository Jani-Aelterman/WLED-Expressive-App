import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wled_expressive/l10n/app_localizations.dart';
import 'screens/device_list_screen.dart';
import 'widgets/expressive_slider.dart';

import 'services/theme_service.dart';
import 'services/locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeService = ThemeService();
  final localeService = LocaleService(prefs);
  runApp(WledApp(themeService: themeService, localeService: localeService));
}

class WledApp extends StatelessWidget {
  final ThemeService themeService;
  final LocaleService localeService;

  const WledApp(
      {super.key, required this.themeService, required this.localeService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        return ValueListenableBuilder<Locale?>(
          valueListenable: localeService.currentLocale,
          builder: (context, locale, child) {
            return DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
                ColorScheme lightScheme;
                ColorScheme darkScheme;

                if (themeService.useDynamicColor &&
                    lightDynamic != null &&
                    darkDynamic != null) {
                  // Genereer de volledige ColorScheme vanaf de dynamische basiskleur
                  // Dit voorkomt bugs waarbij Android de 'surfaceContainer' kleuren niet doorgeeft
                  lightScheme = ColorScheme.fromSeed(
                    seedColor: lightDynamic.primary,
                    brightness: Brightness.light,
                  );
                  darkScheme = ColorScheme.fromSeed(
                    seedColor: darkDynamic.primary,
                    brightness: Brightness.dark,
                  );
                } else {
                  lightScheme = ColorScheme.fromSeed(
                    seedColor: themeService.seedColor,
                    brightness: Brightness.light,
                  );
                  darkScheme = ColorScheme.fromSeed(
                    seedColor: themeService.seedColor,
                    brightness: Brightness.dark,
                  );
                }

                return MaterialApp(
                  onGenerateTitle: (context) =>
                      AppLocalizations.of(context)!.appTitle,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en'),
                    Locale('nl'),
                  ],
                  locale: locale,
                  theme: ThemeData(
                    colorScheme: lightScheme,
                    scaffoldBackgroundColor: lightScheme.surface,
                    useMaterial3: true,
                    sliderTheme: SliderThemeData(
                      trackHeight: 16.0,
                      trackShape: ExpressiveSliderTrackShape(),
                      thumbShape: const ExpressiveSliderThumbShape(),
                      activeTrackColor: lightScheme.primary,
                      inactiveTrackColor:
                          lightScheme.onSurfaceVariant.withOpacity(0.2),
                      thumbColor: lightScheme.primary,
                      overlayColor: lightScheme.primary.withOpacity(0.1),
                      showValueIndicator: ShowValueIndicator.always,
                      valueIndicatorTextStyle: TextStyle(
                        color: lightScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    iconTheme: IconThemeData(
                      color: lightScheme.onSurface,
                    ),
                  ),
                  darkTheme: ThemeData(
                    colorScheme: darkScheme,
                    scaffoldBackgroundColor: darkScheme.surface,
                    useMaterial3: true,
                    sliderTheme: SliderThemeData(
                      trackHeight: 16.0,
                      trackShape: ExpressiveSliderTrackShape(),
                      thumbShape: const ExpressiveSliderThumbShape(),
                      activeTrackColor: darkScheme.primary,
                      inactiveTrackColor:
                          darkScheme.onSurfaceVariant.withOpacity(0.2),
                      thumbColor: darkScheme.primary,
                      overlayColor: darkScheme.primary.withOpacity(0.1),
                      showValueIndicator: ShowValueIndicator.always,
                      valueIndicatorTextStyle: TextStyle(
                        color: darkScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    iconTheme: IconThemeData(
                      color: darkScheme.onSurface,
                    ),
                  ),
                  themeMode: themeService.themeMode,
                  home: DeviceListScreen(
                      themeService: themeService, localeService: localeService),
                );
              },
            );
          },
        );
      },
    );
  }
}
