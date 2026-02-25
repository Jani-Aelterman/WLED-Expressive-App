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
}
