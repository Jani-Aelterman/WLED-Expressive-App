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
  String get liveDataActive => 'Live Data Active';

  @override
  String liveDataActiveDesc(String ip) {
    return 'App controls are disabled while receiving live data ($ip).';
  }

  @override
  String get liveDataOverrideCategory => 'Live Data Override';

  @override
  String get liveDataOverrideToggle => 'Live Data Override';

  @override
  String get liveDataOverrideDescription =>
      'Override the live data (like E1.31, UDP, etc) with the WLED UI controls.';

  @override
  String get liveDataOverrideOnce => 'Override Once';

  @override
  String get liveDataOverrideReboot => 'Override until Reboot';

  @override
  String get wifiSaveSuccess =>
      'Configuration saved! Reboot device if necessary.';

  @override
  String get wifiSaveError => 'Error saving configuration.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsWifi => 'WiFi Setup';

  @override
  String get settingsLeds => 'LED Preferences';

  @override
  String get settingsUi => 'User Interface';

  @override
  String get settingsSync => 'Sync Interfaces';

  @override
  String get settingsTime => 'Time & Macros';

  @override
  String get settingsSecurity => 'Security & Updates';

  @override
  String get actionSync => 'Sync';

  @override
  String get actionSegments => 'Segments';

  @override
  String get actionTimer => 'Timer';

  @override
  String get actionSettings => 'Settings';

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

  @override
  String get apSetupNewDevice => 'New WLED Device!';

  @override
  String get apSetupManualTitle => 'Manual AP Setup';

  @override
  String apSetupFoundText(String ssid) {
    return 'We found a WLED network ($ssid) nearby that currently has no internet connection. Would you like to connect to it to set up Wi-Fi?';
  }

  @override
  String apSetupManualText(String ssid) {
    return 'Make sure your new WLED device is powered on. We will now try to connect to the default \'$ssid\' network to configure Wi-Fi.\n\n(Tip for iOS: Connect to the WLED-AP network manually in your iPhone Settings if this doesn\'t work automatically!)';
  }

  @override
  String get apSetupConnectAndSetup => 'Connect and Setup';

  @override
  String get apSetupIgnoreDevice => 'Ignore Device';

  @override
  String get apSetupFailedConnect =>
      'Could not connect to AP. Make sure you are nearby.';

  @override
  String get apSetupOptionTitle => 'New WLED device (AP Setup)';

  @override
  String get apSetupOptionSubtitle =>
      'Automatically connect to a new device and set up Wi-Fi.';

  @override
  String get manualAddOptionTitle => 'Add manually via IP';

  @override
  String get manualAddOptionSubtitle =>
      'If the device is already on your network.';

  @override
  String get wifiSetupTitle => 'WiFi Setup';

  @override
  String get wifiSetupHeader => 'Choose Home Network';

  @override
  String get wifiSetupDescription =>
      'Enter the name and password of your Wi-Fi network so the WLED can connect to it.';

  @override
  String get wifiSetupNetworkLabel => 'Network (SSID)';

  @override
  String get wifiSetupEmptyError => 'Please enter a network name';

  @override
  String get wifiSetupPasswordLabel => 'Password';

  @override
  String get wifiSetupSaveConnect => 'Save & Connect';

  @override
  String get wifiSetupSuccess => 'Wi-Fi settings saved! Connecting...';

  @override
  String wifiSetupError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get color => 'Color';

  @override
  String get quickPresets => 'Quick Presets';

  @override
  String get applyColor => 'Apply Color';

  @override
  String get errorLoadEffects => 'Could not load effects';

  @override
  String get searchEffects => 'Search effects...';

  @override
  String get errorLoadPalettes => 'Could not load palettes';

  @override
  String get searchPalettes => 'Search palettes...';

  @override
  String get noPresetsFound => 'No presets found';

  @override
  String get createPresetsHint => 'Create presets in the web interface';

  @override
  String get saveStateAsPreset => 'Save current state as preset';

  @override
  String get wifiConnectToExisting => 'Connect to existing network';

  @override
  String get wifiScan => 'Scan';

  @override
  String get wifiNetworkName => 'Network name (SSID, empty to not connect)';

  @override
  String get wifiNetworkPassword => 'Network password';

  @override
  String get wifiStaticIp => 'Static IP (leave at 0.0.0.0 for DHCP)';

  @override
  String get wifiStaticGateway => 'Static gateway';

  @override
  String get wifiStaticSubnet => 'Static subnet mask';

  @override
  String get wifiDnsServer => 'DNS server address';

  @override
  String get wifiMdnsAddress => 'mDNS address (leave empty for no mDNS)';

  @override
  String wifiClientIp(Object ip) {
    return 'Client IP: $ip';
  }

  @override
  String get wifiConfigureAp => 'Configure Access Point';

  @override
  String get wifiApSsid => 'AP SSID (leave empty for no AP)';

  @override
  String get wifiHideApName => 'Hide AP name';

  @override
  String get wifiApPassword => 'AP password (leave empty for open)';

  @override
  String get wifiApChannel => 'Access Point WiFi channel';

  @override
  String get wifiApBehavior => 'AP opens';

  @override
  String get wifiApBehaviorAlways => 'Always';

  @override
  String get wifiApBehaviorNoConnection => 'No connection after boot';

  @override
  String get wifiApBehaviorDisconnected => 'Disconnected';

  @override
  String wifiApIp(Object ip) {
    return 'AP IP: $ip';
  }

  @override
  String get wifiExperimental => 'Experimental';

  @override
  String get wifiForce80211g => 'Force 802.11g mode (ESP8266 only)';

  @override
  String get wifiDisableSleep => 'Disable WiFi sleep';

  @override
  String get wifiDisableSleepDesc =>
      'Can help with connectivity issues and Audioreactive sync.\nDisabling WiFi sleep increases power consumption.';

  @override
  String get wifiEspNow => 'ESP-NOW Wireless';

  @override
  String get wifiEnableEspNow => 'Enable ESP-NOW';

  @override
  String get wifiEnableEspNowDesc =>
      'Listen for events over ESP-NOW\nKeep disabled if not using a remote or wireless sync, increases power consumption.';

  @override
  String get wifiPairedRemoteMac => 'Paired Remote MAC';

  @override
  String wifiLastDeviceSeen(Object mac) {
    return 'Last device seen: $mac';
  }

  @override
  String get wifiSaveAndConnect => 'Save & Connect';
}
