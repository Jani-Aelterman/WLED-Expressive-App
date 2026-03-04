// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'WLED Expressive';

  @override
  String get homeTab => 'Home';

  @override
  String get settingsTab => 'Instellingen';

  @override
  String get version => 'v1.0.0';

  @override
  String get addDeviceButton => 'Apparaat toevoegen';

  @override
  String get addDeviceTitle => 'Nieuw WLED apparaat';

  @override
  String get deviceNameLabel => 'Naam (optioneel)';

  @override
  String get deviceNameHint => 'Mijn Lamp';

  @override
  String get deviceIpLabel => 'IP Adres';

  @override
  String get deviceIpHint => '192.168.x.x';

  @override
  String get cancel => 'Annuleren';

  @override
  String get add => 'Toevoegen';

  @override
  String get editDeviceTitle => 'Apparaat bewerken';

  @override
  String get editDeviceNameLabel => 'Naam';

  @override
  String get editDeviceNameHint => 'Mijn Lamp';

  @override
  String get identifyDeviceButton => 'Identificeer (Knipper)';

  @override
  String get save => 'Opslaan';

  @override
  String get editAndIdentify => 'Bewerken & Identificeren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get allDevicesTurningOn => 'Alle apparaten worden ingeschakeld';

  @override
  String get allDevicesTurningOff => 'Alle apparaten worden uitgeschakeld';

  @override
  String get allControlTitle => 'Alles Bediening';

  @override
  String get allControlSubtitle => 'Alle verbonden lampen';

  @override
  String get noDevicesTitle => 'Geen apparaten gevonden';

  @override
  String get noDevicesSubtitle => 'Voeg een WLED apparaat toe om te beginnen';

  @override
  String get offline => 'Offline';

  @override
  String get deviceUnreachable => 'Kon apparaat niet bereiken';

  @override
  String get colorTab => 'Kleur';

  @override
  String get palettesTab => 'Paletten';

  @override
  String get effectsTab => 'Effecten';

  @override
  String get presetsTab => 'Presets';

  @override
  String get on => 'Aan';

  @override
  String get off => 'Uit';

  @override
  String get brightness => 'Helderheid';

  @override
  String get intensity => 'Intensiteit';

  @override
  String get speed => 'Snelheid';

  @override
  String get selectDeviceToControl => 'Selecteer een lamp om te bedienen';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get appearanceSection => 'Weergave';

  @override
  String get themeMode => 'Thema Modus';

  @override
  String get themeSystem => 'Systeem Standaard';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeColor => 'Thema Kleur';

  @override
  String get dynamicColorToggle => 'Dynamische Kleuren (Material You)';

  @override
  String get dynamicColorSubtitle => 'Pas app kleuren aan op je achtergrond';

  @override
  String get seedColorSelection => 'Basiskleur';

  @override
  String get seedColorSubtitle => 'Gebruikt als de primaire kleur voor de app';

  @override
  String get languageSection => 'Taal';

  @override
  String get languageLabel => 'App Taal';

  @override
  String get webInterfaceUnreachable => 'Kon webinterface niet openen';

  @override
  String get hapticsToggle => 'Haptische Feedback / Trillen';

  @override
  String get hapticsSubtitle =>
      'Gebruik trillingen om besturing expressiever te laten voelen';

  @override
  String get apSetupNewDevice => 'Nieuw WLED Apparaat!';

  @override
  String get apSetupManualTitle => 'WLED-AP Verbinden';

  @override
  String apSetupFoundText(String ssid) {
    return 'We hebben een WLED netwerk ($ssid) in de buurt gevonden dat nog geen internet verbinding heeft. Wil je hiermee verbinden om het in te stellen?';
  }

  @override
  String apSetupManualText(String ssid) {
    return 'Zorg dat je nieuwe WLED apparaat aan staat. We proberen nu te verbinden met het standaard \'$ssid\' netwerk om Wi-Fi in te stellen.\n\n(Tip voor iOS: Verbind zelf in je iPhone Instellingen met het WLED-AP netwerk als dit niet automatisch werkt!)';
  }

  @override
  String get apSetupConnectAndSetup => 'Verbinden en Instellen';

  @override
  String get apSetupIgnoreDevice => 'Apparaat Negeren';

  @override
  String get apSetupFailedConnect =>
      'Kan niet met AP verbinden. Controleer of je in de buurt bent.';

  @override
  String get apSetupOptionTitle => 'Nieuw WLED apparaat (AP Setup)';

  @override
  String get apSetupOptionSubtitle =>
      'Verbind automatisch met een nieuw apparaat en stel Wi-Fi in.';

  @override
  String get manualAddOptionTitle => 'Voeg handmatig toe via IP';

  @override
  String get manualAddOptionSubtitle =>
      'Als het apparaat al op je netwerk zit.';

  @override
  String get wifiSetupTitle => 'Wi-Fi Instellen';

  @override
  String get wifiSetupHeader => 'Thuisnetwerk Kiezen';

  @override
  String get wifiSetupDescription =>
      'Voer de naam en het wachtwoord in van je Wi-Fi netwerk zodat de WLED hiermee kan verbinden.';

  @override
  String get wifiSetupNetworkLabel => 'Netwerk (SSID)';

  @override
  String get wifiSetupEmptyError => 'Vul een netwerknaam in';

  @override
  String get wifiSetupPasswordLabel => 'Wachtwoord';

  @override
  String get wifiSetupSaveConnect => 'Opslaan & Verbinden';

  @override
  String get wifiSetupSuccess => 'Wi-Fi instellingen opgeslagen! Verbinden...';

  @override
  String wifiSetupError(String error) {
    return 'Fout bij opslaan: $error';
  }

  @override
  String get color => 'Kleur';

  @override
  String get quickPresets => 'Snelle Presets';

  @override
  String get applyColor => 'Kleur Toepassen';

  @override
  String get errorLoadEffects => 'Kon effecten niet laden';

  @override
  String get searchEffects => 'Zoek effecten...';

  @override
  String get errorLoadPalettes => 'Kon paletten niet laden';

  @override
  String get searchPalettes => 'Zoek paletten...';

  @override
  String get noPresetsFound => 'Geen presets gevonden';

  @override
  String get createPresetsHint => 'Maak presets aan in de webinterface';

  @override
  String get saveStateAsPreset => 'Huidige staat opslaan als preset';
}
