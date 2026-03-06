import 'package:flutter/material.dart';
import 'package:wled_expressive/l10n/app_localizations.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import '../models/wled_device.dart';
import '../services/wled_api_service.dart';

class DeviceSettingsWifiScreen extends StatefulWidget {
  final WledDevice device;

  const DeviceSettingsWifiScreen({super.key, required this.device});

  @override
  State<DeviceSettingsWifiScreen> createState() =>
      _DeviceSettingsWifiScreenState();
}

class _DeviceSettingsWifiScreenState extends State<DeviceSettingsWifiScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  Map<String, dynamic>? _originalConfig;

  // Network controllers
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _staticIpController = TextEditingController();
  final _gatewayController = TextEditingController();
  final _subnetController = TextEditingController();
  final _dnsController = TextEditingController();
  final _mdnsController = TextEditingController();

  // AP controllers
  final _apSsidController = TextEditingController();
  final _apPasswordController = TextEditingController();
  final _apChannelController = TextEditingController();

  // State variables
  bool _apHide = false;
  int _apBehavior = 0; // 0=Always, 1=No connection, 2=Disconnected
  String _clientIp = "";
  String _apIp = "";

  // Experimental / ESP-NOW
  bool _force80211g = false;
  bool _disableSleep = false;
  bool _enableEspNow = false;
  final _pairedMacController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchConfig();
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    _staticIpController.dispose();
    _gatewayController.dispose();
    _subnetController.dispose();
    _dnsController.dispose();
    _mdnsController.dispose();
    _apSsidController.dispose();
    _apPasswordController.dispose();
    _apChannelController.dispose();
    _pairedMacController.dispose();
    super.dispose();
  }

  Future<void> _fetchConfig() async {
    final config = await WledApiService.getDeviceConfig(widget.device.ip);

    if (!mounted) return;

    try {
      if (config != null) {
        _originalConfig = config;

        // Unpack NW (Network)
        final nw = config['nw'];
        if (nw != null &&
            nw['ins'] != null &&
            nw['ins'] is List &&
            nw['ins'].isNotEmpty) {
          final ins = nw['ins'][0];
          _ssidController.text = ins['ssid']?.toString() ?? '';
          _passwordController.text = ins['psk']?.toString() ?? '';

          String parseIpList(dynamic ipObj) {
            if (ipObj is List) return ipObj.join('.');
            return ipObj?.toString() ?? '0.0.0.0';
          }

          _staticIpController.text = parseIpList(ins['ip']);
          _gatewayController.text = parseIpList(ins['gw']);
          _subnetController.text = parseIpList(ins['sn']);
        }

        // Read only fields
        if (config['info'] != null) {
          final infoIp = config['info']['ip'];
          _clientIp =
              (infoIp is List) ? infoIp.join('.') : infoIp?.toString() ?? '';
        }

        // DNS / MDNS
        if (config['id'] != null) {
          _mdnsController.text = config['id']['mdns']?.toString() ?? '';
        }

        // AP (Access Point)
        final ap = config['ap'];
        if (ap != null) {
          _apSsidController.text = ap['ssid']?.toString() ?? 'WLED-AP';
          _apPasswordController.text = ap['psk']?.toString() ?? '';
          _apChannelController.text = (ap['chan'] ?? 1).toString();
          _apHide = ap['hide'] == true || ap['hide'] == 1;
          _apBehavior = ap['behav'] is int
              ? ap['behav']
              : int.tryParse(ap['behav']?.toString() ?? '0') ?? 0;

          final apIpList = ap['ip'];
          _apIp = (apIpList is List)
              ? apIpList.join('.')
              : apIpList?.toString() ?? '4.3.2.1';
        }

        // Experimental/ETH
        final wifi = config['wifi'];
        if (wifi != null) {
          _force80211g = wifi['11g'] == true || wifi['11g'] == 1;
          _disableSleep =
              wifi['sleep'] == false || wifi['sleep'] == 0; // Sleep off
        }

        // ESP NOW
        final espNow = config['espnow'];
        if (espNow != null) {
          _enableEspNow = espNow['en'] == true || espNow['en'] == 1;
          _pairedMacController.text = espNow['mac']?.toString() ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error parsing WLED config: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveConfig() async {
    if (_originalConfig == null) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    // We build a deep copy or partial structure
    // Since WLED merges objects, sending only changed fields is safer,
    // but building the structured hierarchy works too.

    List<int> parseIp(String ipText) {
      final parts = ipText.split('.');
      if (parts.length == 4) {
        return parts.map((e) => int.tryParse(e) ?? 0).toList();
      }
      return [0, 0, 0, 0];
    }

    final payload = {
      "nw": {
        "ins": [
          {
            "ssid": _ssidController.text,
            "psk": _passwordController.text,
            "ip": parseIp(_staticIpController.text),
            "gw": parseIp(_gatewayController.text),
            "sn": parseIp(_subnetController.text),
          }
        ]
      },
      "ap": {
        "ssid": _apSsidController.text,
        "psk": _apPasswordController.text,
        "chan": int.tryParse(_apChannelController.text) ?? 1,
        "hide": _apHide,
        "behav": _apBehavior,
      },
      "id": {
        "mdns": _mdnsController.text,
      },
      "wifi": {
        "11g": _force80211g,
        "sleep": !_disableSleep,
      },
      "espnow": {
        "en": _enableEspNow,
        "mac": _pairedMacController.text,
      }
    };

    final success =
        await WledApiService.setDeviceConfig(widget.device.ip, payload);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.wifiSaveSuccess)),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.wifiSaveError)),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8, left: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context)!.wifiSetupTitle)),
        body: const Center(child: LoadingIndicatorM3E()),
      );
    }

    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.wifiSetupTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Client Network
          _buildSectionHeader(loc.wifiConnectToExisting),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.wifi_find),
                    label: Text(loc.wifiScan),
                    onPressed: () {
                      // Stub for scan functionality if exposed via API
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(_ssidController, loc.wifiNetworkName),
                  _buildTextField(_passwordController, loc.wifiNetworkPassword,
                      isPassword: true),
                  _buildTextField(_staticIpController, loc.wifiStaticIp,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true)),
                  _buildTextField(_gatewayController, loc.wifiStaticGateway,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true)),
                  _buildTextField(_subnetController, loc.wifiStaticSubnet,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true)),
                  _buildTextField(_mdnsController, loc.wifiMdnsAddress),
                  if (_clientIp.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(loc.wifiClientIp(_clientIp),
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                ],
              ),
            ),
          ),

          // Access Point
          _buildSectionHeader(loc.wifiConfigureAp),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(_apSsidController, loc.wifiApSsid),
                  SwitchListTile(
                    title: Text(loc.wifiHideApName),
                    value: _apHide,
                    onChanged: (val) => setState(() => _apHide = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(_apPasswordController, loc.wifiApPassword,
                      isPassword: true),
                  _buildTextField(_apChannelController, loc.wifiApChannel,
                      keyboardType: TextInputType.number),
                  DropdownButtonFormField<int>(
                    initialValue: _apBehavior,
                    decoration: InputDecoration(
                      labelText: loc.wifiApBehavior,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLow,
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 0, child: Text(loc.wifiApBehaviorAlways)),
                      DropdownMenuItem(
                          value: 1,
                          child: Text(loc.wifiApBehaviorNoConnection)),
                      DropdownMenuItem(
                          value: 2,
                          child: Text(loc.wifiApBehaviorDisconnected)),
                    ],
                    onChanged: (val) => setState(() => _apBehavior = val ?? 0),
                  ),
                  if (_apIp.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(loc.wifiApIp(_apIp),
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                ],
              ),
            ),
          ),

          // Experimental
          _buildSectionHeader(loc.wifiExperimental),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(loc.wifiForce80211g),
                    value: _force80211g,
                    onChanged: (val) => setState(() => _force80211g = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text(loc.wifiDisableSleep),
                    subtitle: Text(loc.wifiDisableSleepDesc),
                    value: _disableSleep,
                    onChanged: (val) => setState(() => _disableSleep = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),

          // ESP NOW
          _buildSectionHeader(loc.wifiEspNow),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(loc.wifiEnableEspNow),
                    subtitle: Text(loc.wifiEnableEspNowDesc),
                    value: _enableEspNow,
                    onChanged: (val) => setState(() => _enableEspNow = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_enableEspNow) ...[
                    const SizedBox(height: 16),
                    _buildTextField(
                        _pairedMacController, loc.wifiPairedRemoteMac),
                  ]
                ],
              ),
            ),
          ),

          const SizedBox(height: 80), // Padding for FAB
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _saveConfig,
        icon: _isSaving
            ? SizedBox(
                width: 24, height: 24, child: const LoadingIndicatorM3E())
            : const Icon(Icons.save),
        label: Text(loc.wifiSaveAndConnect),
      ),
    );
  }
}
