import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'WLED Expressive'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0'**
  String get version;

  /// No description provided for @addDeviceButton.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDeviceButton;

  /// No description provided for @addDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'New WLED Device'**
  String get addDeviceTitle;

  /// No description provided for @deviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get deviceNameLabel;

  /// No description provided for @deviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'My Light'**
  String get deviceNameHint;

  /// No description provided for @deviceIpLabel.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get deviceIpLabel;

  /// No description provided for @deviceIpHint.
  ///
  /// In en, this message translates to:
  /// **'192.168.x.x'**
  String get deviceIpHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @editDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Device'**
  String get editDeviceTitle;

  /// No description provided for @editDeviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editDeviceNameLabel;

  /// No description provided for @editDeviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'My Light'**
  String get editDeviceNameHint;

  /// No description provided for @identifyDeviceButton.
  ///
  /// In en, this message translates to:
  /// **'Identify (Blink)'**
  String get identifyDeviceButton;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editAndIdentify.
  ///
  /// In en, this message translates to:
  /// **'Edit & Identify'**
  String get editAndIdentify;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @allDevicesTurningOn.
  ///
  /// In en, this message translates to:
  /// **'Turning on all devices'**
  String get allDevicesTurningOn;

  /// No description provided for @allDevicesTurningOff.
  ///
  /// In en, this message translates to:
  /// **'Turning off all devices'**
  String get allDevicesTurningOff;

  /// No description provided for @allControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Control'**
  String get allControlTitle;

  /// No description provided for @allControlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All connected lights'**
  String get allControlSubtitle;

  /// No description provided for @noDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevicesTitle;

  /// No description provided for @noDevicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a WLED device to get started'**
  String get noDevicesSubtitle;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @deviceUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Device unreachable'**
  String get deviceUnreachable;

  /// No description provided for @colorTab.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorTab;

  /// No description provided for @palettesTab.
  ///
  /// In en, this message translates to:
  /// **'Palettes'**
  String get palettesTab;

  /// No description provided for @effectsTab.
  ///
  /// In en, this message translates to:
  /// **'Effects'**
  String get effectsTab;

  /// No description provided for @presetsTab.
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get presetsTab;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// No description provided for @intensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensity;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @selectDeviceToControl.
  ///
  /// In en, this message translates to:
  /// **'Select a light to control'**
  String get selectDeviceToControl;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @dynamicColorToggle.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Color (Material You)'**
  String get dynamicColorToggle;

  /// No description provided for @dynamicColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adapt app colors to your wallpaper'**
  String get dynamicColorSubtitle;

  /// No description provided for @seedColorSelection.
  ///
  /// In en, this message translates to:
  /// **'Seed Color'**
  String get seedColorSelection;

  /// No description provided for @seedColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used as the primary color for the app'**
  String get seedColorSubtitle;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageLabel;

  /// No description provided for @webInterfaceUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Could not open web interface'**
  String get webInterfaceUnreachable;

  /// No description provided for @hapticsToggle.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback / Vibration'**
  String get hapticsToggle;

  /// No description provided for @hapticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use vibrations to make controls feel more expressive'**
  String get hapticsSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
