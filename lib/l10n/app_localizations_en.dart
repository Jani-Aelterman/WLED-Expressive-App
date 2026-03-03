// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WLED Expressive';

  @override
  String get homeTab => 'Home';

  @override
  String get settingsTab => 'Settings';

  @override
  String get version => 'v1.0.0';

  @override
  String get addDeviceButton => 'Add Device';

  @override
  String get addDeviceTitle => 'New WLED Device';

  @override
  String get deviceNameLabel => 'Name (optional)';

  @override
  String get deviceNameHint => 'My Light';

  @override
  String get deviceIpLabel => 'IP Address';

  @override
  String get deviceIpHint => '192.168.x.x';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get editDeviceTitle => 'Edit Device';

  @override
  String get editDeviceNameLabel => 'Name';

  @override
  String get editDeviceNameHint => 'My Light';

  @override
  String get identifyDeviceButton => 'Identify (Blink)';

  @override
  String get save => 'Save';

  @override
  String get editAndIdentify => 'Edit & Identify';

  @override
  String get delete => 'Delete';

  @override
  String get allDevicesTurningOn => 'Turning on all devices';

  @override
  String get allDevicesTurningOff => 'Turning off all devices';

  @override
  String get allControlTitle => 'Master Control';

  @override
  String get allControlSubtitle => 'All connected lights';

  @override
  String get noDevicesTitle => 'No devices found';

  @override
  String get noDevicesSubtitle => 'Add a WLED device to get started';

  @override
  String get offline => 'Offline';

  @override
  String get deviceUnreachable => 'Device unreachable';

  @override
  String get colorTab => 'Color';

  @override
  String get palettesTab => 'Palettes';

  @override
  String get effectsTab => 'Effects';

  @override
  String get presetsTab => 'Presets';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get brightness => 'Brightness';

  @override
  String get intensity => 'Intensity';

  @override
  String get speed => 'Speed';

  @override
  String get selectDeviceToControl => 'Select a light to control';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get dynamicColorToggle => 'Dynamic Color (Material You)';

  @override
  String get dynamicColorSubtitle => 'Adapt app colors to your wallpaper';

  @override
  String get seedColorSelection => 'Seed Color';

  @override
  String get seedColorSubtitle => 'Used as the primary color for the app';

  @override
  String get languageSection => 'Language';

  @override
  String get languageLabel => 'App Language';

  @override
  String get webInterfaceUnreachable => 'Could not open web interface';

  @override
  String get hapticsToggle => 'Haptic Feedback / Vibration';

  @override
  String get hapticsSubtitle =>
      'Use vibrations to make controls feel more expressive';
}
