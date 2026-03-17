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

  /// No description provided for @liveDataActive.
  ///
  /// In en, this message translates to:
  /// **'Live Data Active'**
  String get liveDataActive;

  /// No description provided for @liveDataActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'App controls are disabled while receiving live data ({ip}).'**
  String liveDataActiveDesc(String ip);

  /// No description provided for @liveDataOverrideCategory.
  ///
  /// In en, this message translates to:
  /// **'Live Data Override'**
  String get liveDataOverrideCategory;

  /// No description provided for @liveDataOverrideToggle.
  ///
  /// In en, this message translates to:
  /// **'Live Data Override'**
  String get liveDataOverrideToggle;

  /// No description provided for @liveDataOverrideDescription.
  ///
  /// In en, this message translates to:
  /// **'Override the live data (like E1.31, UDP, etc) with the WLED UI controls.'**
  String get liveDataOverrideDescription;

  /// No description provided for @liveDataOverrideOnce.
  ///
  /// In en, this message translates to:
  /// **'Override Once'**
  String get liveDataOverrideOnce;

  /// No description provided for @liveDataOverrideReboot.
  ///
  /// In en, this message translates to:
  /// **'Override until Reboot'**
  String get liveDataOverrideReboot;

  /// No description provided for @wifiSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Configuration saved! Reboot device if necessary.'**
  String get wifiSaveSuccess;

  /// No description provided for @wifiSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving configuration.'**
  String get wifiSaveError;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi Setup'**
  String get settingsWifi;

  /// No description provided for @settingsLeds.
  ///
  /// In en, this message translates to:
  /// **'LED Preferences'**
  String get settingsLeds;

  /// No description provided for @settingsUi.
  ///
  /// In en, this message translates to:
  /// **'User Interface'**
  String get settingsUi;

  /// No description provided for @settingsSync.
  ///
  /// In en, this message translates to:
  /// **'Sync Interfaces'**
  String get settingsSync;

  /// No description provided for @settingsTime.
  ///
  /// In en, this message translates to:
  /// **'Time & Macros'**
  String get settingsTime;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & Updates'**
  String get settingsSecurity;

  /// No description provided for @actionSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get actionSync;

  /// No description provided for @actionSegments.
  ///
  /// In en, this message translates to:
  /// **'Segments'**
  String get actionSegments;

  /// No description provided for @actionTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get actionTimer;

  /// No description provided for @actionSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get actionSettings;

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

  /// No description provided for @apSetupNewDevice.
  ///
  /// In en, this message translates to:
  /// **'New WLED Device!'**
  String get apSetupNewDevice;

  /// No description provided for @apSetupManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual AP Setup'**
  String get apSetupManualTitle;

  /// No description provided for @apSetupFoundText.
  ///
  /// In en, this message translates to:
  /// **'We found a WLED network ({ssid}) nearby that currently has no internet connection. Would you like to connect to it to set up Wi-Fi?'**
  String apSetupFoundText(String ssid);

  /// No description provided for @apSetupManualText.
  ///
  /// In en, this message translates to:
  /// **'Make sure your new WLED device is powered on. We will now try to connect to the default \'{ssid}\' network to configure Wi-Fi.\n\n(Tip for iOS: Connect to the WLED-AP network manually in your iPhone Settings if this doesn\'t work automatically!)'**
  String apSetupManualText(String ssid);

  /// No description provided for @apSetupConnectAndSetup.
  ///
  /// In en, this message translates to:
  /// **'Connect and Setup'**
  String get apSetupConnectAndSetup;

  /// No description provided for @apSetupIgnoreDevice.
  ///
  /// In en, this message translates to:
  /// **'Ignore Device'**
  String get apSetupIgnoreDevice;

  /// No description provided for @apSetupFailedConnect.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to AP. Make sure you are nearby.'**
  String get apSetupFailedConnect;

  /// No description provided for @apSetupOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'New WLED device (AP Setup)'**
  String get apSetupOptionTitle;

  /// No description provided for @apSetupOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically connect to a new device and set up Wi-Fi.'**
  String get apSetupOptionSubtitle;

  /// No description provided for @manualAddOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add manually via IP'**
  String get manualAddOptionTitle;

  /// No description provided for @manualAddOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If the device is already on your network.'**
  String get manualAddOptionSubtitle;

  /// No description provided for @wifiSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'WiFi Setup'**
  String get wifiSetupTitle;

  /// No description provided for @wifiSetupHeader.
  ///
  /// In en, this message translates to:
  /// **'Choose Home Network'**
  String get wifiSetupHeader;

  /// No description provided for @wifiSetupDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the name and password of your Wi-Fi network so the WLED can connect to it.'**
  String get wifiSetupDescription;

  /// No description provided for @wifiSetupNetworkLabel.
  ///
  /// In en, this message translates to:
  /// **'Network (SSID)'**
  String get wifiSetupNetworkLabel;

  /// No description provided for @wifiSetupEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a network name'**
  String get wifiSetupEmptyError;

  /// No description provided for @wifiSetupPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get wifiSetupPasswordLabel;

  /// No description provided for @wifiSetupSaveConnect.
  ///
  /// In en, this message translates to:
  /// **'Save & Connect'**
  String get wifiSetupSaveConnect;

  /// No description provided for @wifiSetupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi settings saved! Connecting...'**
  String get wifiSetupSuccess;

  /// No description provided for @wifiSetupError.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String wifiSetupError(String error);

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @quickPresets.
  ///
  /// In en, this message translates to:
  /// **'Quick Presets'**
  String get quickPresets;

  /// No description provided for @applyColor.
  ///
  /// In en, this message translates to:
  /// **'Apply Color'**
  String get applyColor;

  /// No description provided for @errorLoadEffects.
  ///
  /// In en, this message translates to:
  /// **'Could not load effects'**
  String get errorLoadEffects;

  /// No description provided for @searchEffects.
  ///
  /// In en, this message translates to:
  /// **'Search effects...'**
  String get searchEffects;

  /// No description provided for @errorLoadPalettes.
  ///
  /// In en, this message translates to:
  /// **'Could not load palettes'**
  String get errorLoadPalettes;

  /// No description provided for @searchPalettes.
  ///
  /// In en, this message translates to:
  /// **'Search palettes...'**
  String get searchPalettes;

  /// No description provided for @noPresetsFound.
  ///
  /// In en, this message translates to:
  /// **'No presets found'**
  String get noPresetsFound;

  /// No description provided for @createPresetsHint.
  ///
  /// In en, this message translates to:
  /// **'Create presets in the web interface'**
  String get createPresetsHint;

  /// No description provided for @saveStateAsPreset.
  ///
  /// In en, this message translates to:
  /// **'Save current state as preset'**
  String get saveStateAsPreset;

  /// No description provided for @wifiConnectToExisting.
  ///
  /// In en, this message translates to:
  /// **'Connect to existing network'**
  String get wifiConnectToExisting;

  /// No description provided for @wifiScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get wifiScan;

  /// No description provided for @wifiNetworkName.
  ///
  /// In en, this message translates to:
  /// **'Network name (SSID, empty to not connect)'**
  String get wifiNetworkName;

  /// No description provided for @wifiNetworkPassword.
  ///
  /// In en, this message translates to:
  /// **'Network password'**
  String get wifiNetworkPassword;

  /// No description provided for @wifiStaticIp.
  ///
  /// In en, this message translates to:
  /// **'Static IP (leave at 0.0.0.0 for DHCP)'**
  String get wifiStaticIp;

  /// No description provided for @wifiStaticGateway.
  ///
  /// In en, this message translates to:
  /// **'Static gateway'**
  String get wifiStaticGateway;

  /// No description provided for @wifiStaticSubnet.
  ///
  /// In en, this message translates to:
  /// **'Static subnet mask'**
  String get wifiStaticSubnet;

  /// No description provided for @wifiDnsServer.
  ///
  /// In en, this message translates to:
  /// **'DNS server address'**
  String get wifiDnsServer;

  /// No description provided for @wifiMdnsAddress.
  ///
  /// In en, this message translates to:
  /// **'mDNS address (leave empty for no mDNS)'**
  String get wifiMdnsAddress;

  /// No description provided for @wifiClientIp.
  ///
  /// In en, this message translates to:
  /// **'Client IP: {ip}'**
  String wifiClientIp(Object ip);

  /// No description provided for @wifiConfigureAp.
  ///
  /// In en, this message translates to:
  /// **'Configure Access Point'**
  String get wifiConfigureAp;

  /// No description provided for @wifiApSsid.
  ///
  /// In en, this message translates to:
  /// **'AP SSID (leave empty for no AP)'**
  String get wifiApSsid;

  /// No description provided for @wifiHideApName.
  ///
  /// In en, this message translates to:
  /// **'Hide AP name'**
  String get wifiHideApName;

  /// No description provided for @wifiApPassword.
  ///
  /// In en, this message translates to:
  /// **'AP password (leave empty for open)'**
  String get wifiApPassword;

  /// No description provided for @wifiApChannel.
  ///
  /// In en, this message translates to:
  /// **'Access Point WiFi channel'**
  String get wifiApChannel;

  /// No description provided for @wifiApBehavior.
  ///
  /// In en, this message translates to:
  /// **'AP opens'**
  String get wifiApBehavior;

  /// No description provided for @wifiApBehaviorAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get wifiApBehaviorAlways;

  /// No description provided for @wifiApBehaviorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No connection after boot'**
  String get wifiApBehaviorNoConnection;

  /// No description provided for @wifiApBehaviorDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get wifiApBehaviorDisconnected;

  /// No description provided for @wifiApIp.
  ///
  /// In en, this message translates to:
  /// **'AP IP: {ip}'**
  String wifiApIp(Object ip);

  /// No description provided for @wifiExperimental.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get wifiExperimental;

  /// No description provided for @wifiForce80211g.
  ///
  /// In en, this message translates to:
  /// **'Force 802.11g mode (ESP8266 only)'**
  String get wifiForce80211g;

  /// No description provided for @wifiDisableSleep.
  ///
  /// In en, this message translates to:
  /// **'Disable WiFi sleep'**
  String get wifiDisableSleep;

  /// No description provided for @wifiDisableSleepDesc.
  ///
  /// In en, this message translates to:
  /// **'Can help with connectivity issues and Audioreactive sync.\nDisabling WiFi sleep increases power consumption.'**
  String get wifiDisableSleepDesc;

  /// No description provided for @wifiEspNow.
  ///
  /// In en, this message translates to:
  /// **'ESP-NOW Wireless'**
  String get wifiEspNow;

  /// No description provided for @wifiEnableEspNow.
  ///
  /// In en, this message translates to:
  /// **'Enable ESP-NOW'**
  String get wifiEnableEspNow;

  /// No description provided for @wifiEnableEspNowDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen for events over ESP-NOW\nKeep disabled if not using a remote or wireless sync, increases power consumption.'**
  String get wifiEnableEspNowDesc;

  /// No description provided for @wifiPairedRemoteMac.
  ///
  /// In en, this message translates to:
  /// **'Paired Remote MAC'**
  String get wifiPairedRemoteMac;

  /// No description provided for @wifiLastDeviceSeen.
  ///
  /// In en, this message translates to:
  /// **'Last device seen: {mac}'**
  String wifiLastDeviceSeen(Object mac);

  /// No description provided for @wifiSaveAndConnect.
  ///
  /// In en, this message translates to:
  /// **'Save & Connect'**
  String get wifiSaveAndConnect;
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
