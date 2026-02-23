import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/device_list_screen.dart';
import 'widgets/expressive_slider.dart';

import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeService = ThemeService();
  runApp(WledApp(themeService: themeService));
}

class WledApp extends StatelessWidget {
  final ThemeService themeService;

  const WledApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            ColorScheme lightScheme;
            ColorScheme darkScheme;

            if (themeService.useDynamicColor &&
                lightDynamic != null &&
                darkDynamic != null) {
              lightScheme = lightDynamic.harmonized();
              darkScheme = darkDynamic.harmonized();
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
              title: 'WLED Material 3',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: lightScheme,
                useMaterial3: true,
                sliderTheme: SliderThemeData(
                  trackHeight: 16.0,
                  trackShape: ExpressiveSliderTrackShape(),
                  thumbShape: const ExpressiveSliderThumbShape(),
                  activeTrackColor: lightScheme.primary,
                  inactiveTrackColor: lightScheme.surfaceContainerHighest,
                  thumbColor: lightScheme.onPrimary,
                  overlayColor: lightScheme.primary.withOpacity(0.1),
                ),
                iconTheme: IconThemeData(
                  color: lightScheme.onSurface,
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: darkScheme,
                useMaterial3: true,
                sliderTheme: SliderThemeData(
                  trackHeight: 16.0,
                  trackShape: ExpressiveSliderTrackShape(),
                  thumbShape: const ExpressiveSliderThumbShape(),
                  activeTrackColor: darkScheme.primary,
                  inactiveTrackColor: darkScheme.surfaceContainerHighest,
                  thumbColor: darkScheme.onPrimary,
                  overlayColor: darkScheme.primary.withOpacity(0.1),
                ),
                iconTheme: IconThemeData(
                  color: darkScheme.onSurface,
                ),
              ),
              themeMode: themeService.themeMode,
              home: DeviceListScreen(themeService: themeService),
            );
          },
        );
      },
    );
  }
}
