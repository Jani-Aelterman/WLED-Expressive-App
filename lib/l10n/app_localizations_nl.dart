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
  String get liveDataActive => 'Live Data Actief';

  @override
  String liveDataActiveDesc(String ip) {
    return 'App-bediening is geblokkeerd door inkomende live data ($ip).';
  }

  @override
  String get liveDataOverrideCategory => 'Live Data Overschrijven';

  @override
  String get liveDataOverrideToggle => 'Live Data Overschrijven';

  @override
  String get liveDataOverrideDescription =>
      'Overschrijf live data (zoals E1.31, UDP, enz.) met de WLED UI regelaars.';

  @override
  String get liveDataOverrideOnce => 'Tijdelijk Oversturen';

  @override
  String get liveDataOverrideReboot => 'Oversturen tot Reboot';

  @override
  String get wifiSaveSuccess =>
      'Configuratie opgeslagen! Herstart apparaat indien nodig.';

  @override
  String get wifiSaveError => 'Fout bij het opslaan van configuratie.';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsWifi => 'WiFi Instellingen';

  @override
  String get settingsLeds => 'LED Voorkeuren';

  @override
  String get settingsUi => 'Gebruikersinterface';

  @override
  String get settingsSync => 'Sync Interfaces';

  @override
  String get settingsTime => 'Tijd & Macro\'s';

  @override
  String get settingsSecurity => 'Beveiliging & Updates';

  @override
  String get actionSync => 'Sync';

  @override
  String get actionSegments => 'Segmenten';

  @override
  String get actionTimer => 'Timer';

  @override
  String get actionSettings => 'Instellingen';

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
  String get wifiSetupTitle => 'WiFi Installatie';

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

  @override
  String get wifiConnectToExisting => 'Verbinden met bestaand netwerk';

  @override
  String get wifiScan => 'Zoeken';

  @override
  String get wifiNetworkName => 'Netwerknaam (SSID, leeg om niet te verbinden)';

  @override
  String get wifiNetworkPassword => 'Netwerkwachtwoord';

  @override
  String get wifiStaticIp => 'Vast IP (laat op 0.0.0.0 voor DHCP)';

  @override
  String get wifiStaticGateway => 'Vaste gateway';

  @override
  String get wifiStaticSubnet => 'Vast subnetmasker';

  @override
  String get wifiDnsServer => 'DNS-serveradres';

  @override
  String get wifiMdnsAddress => 'mDNS-adres (leeg voor geen mDNS)';

  @override
  String wifiClientIp(Object ip) {
    return 'Client IP: $ip';
  }

  @override
  String get wifiConfigureAp => 'Toegangspunt (AP) configureren';

  @override
  String get wifiApSsid => 'AP SSID (leeg voor geen AP)';

  @override
  String get wifiHideApName => 'Verberg AP-naam';

  @override
  String get wifiApPassword => 'AP-wachtwoord (leeg voor open)';

  @override
  String get wifiApChannel => 'Toegangspunt WiFi-kanaal';

  @override
  String get wifiApBehavior => 'AP opent';

  @override
  String get wifiApBehaviorAlways => 'Altijd';

  @override
  String get wifiApBehaviorNoConnection => 'Geen verbinding na start';

  @override
  String get wifiApBehaviorDisconnected => 'Verbroken';

  @override
  String wifiApIp(Object ip) {
    return 'AP IP: $ip';
  }

  @override
  String get wifiExperimental => 'Experimenteel';

  @override
  String get wifiForce80211g => 'Forceer 802.11g modus (alleen ESP8266)';

  @override
  String get wifiDisableSleep => 'Schakel WiFi-slaapstand uit';

  @override
  String get wifiDisableSleepDesc =>
      'Kan helpen bij verbindingsproblemen en Audioreactieve sync.\nHet uitschakelen verhoogt het stroomverbruik.';

  @override
  String get wifiEspNow => 'ESP-NOW Draadloos';

  @override
  String get wifiEnableEspNow => 'Schakel ESP-NOW in';

  @override
  String get wifiEnableEspNowDesc =>
      'Luister naar commando\'s via ESP-NOW\nLaat dit uitgeschakeld als je geen afstandsbediening gebruikt o.w.v. stroomverbruik.';

  @override
  String get wifiPairedRemoteMac => 'Gekoppelde MAC';

  @override
  String wifiLastDeviceSeen(Object mac) {
    return 'Laatst geziene apparaat: $mac';
  }

  @override
  String get wifiSaveAndConnect => 'Opslaan & Verbinden';
}
