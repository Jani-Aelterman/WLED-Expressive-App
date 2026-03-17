import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wled_expressive/l10n/app_localizations.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/wifi_setup_service.dart';

class WifiSetupScreen extends StatefulWidget {
  final String deviceIp; // Should be '4.3.2.1' in AP mode

  const WifiSetupScreen({super.key, required this.deviceIp});

  @override
  State<WifiSetupScreen> createState() => _WifiSetupScreenState();
}

class _WifiSetupScreenState extends State<WifiSetupScreen> {
  final _ssidController = TextEditingController();
  final _pskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isScanning = false;
  List<String> _scannedNetworks = [];

  Future<void> _startScan() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      final canScan =
          await WiFiScan.instance.canStartScan(askPermissions: true);
      if (canScan == CanStartScan.yes) {
        setState(() => _isScanning = true);
        await WiFiScan.instance.startScan();
        final results = await WiFiScan.instance.getScannedResults();
        if (mounted) {
          setState(() {
            _scannedNetworks = results
                .map((r) => r.ssid)
                .where((s) => s.isNotEmpty)
                .toSet()
                .toList();
            _isScanning = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _pskController.dispose();
    WifiSetupService.disconnectFromAp(); // Release the forced AP network
    super.dispose();
  }

  Future<void> _saveWifi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final ssid = _ssidController.text;
    final psk = _pskController.text;

    try {
      final url = Uri.parse('http://${widget.deviceIp}/json/cfg');
      final payload = jsonEncode({
        "nw": {
          "ins": [
            {"ssid": ssid, "pskl": psk.length, "psk": psk}
          ]
        }
      });

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(const Duration(seconds: 4));

      try {
        await http
            .post(
              Uri.parse('http://${widget.deviceIp}/json/state'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({"rb": true}),
            )
            .timeout(const Duration(seconds: 1));
      } catch (_) {}

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _showSuccessAndPop();
      } else {
        throw Exception('Server gaf foutcode ${response.statusCode}');
      }
    } on TimeoutException {
      // WLED drops the AP connection immediately to apply settings, so a timeout is usually success
      _showSuccessAndPop();
    } on SocketException {
      // Same here, the socket closes abruptly when the AP goes down
      _showSuccessAndPop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.wifiSetupError(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessAndPop() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Wi-Fi instellingen opgeslagen! Verbinden...')),
      );
      // Go back to the device list
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.wifiSetupTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'esp32_illustration',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/esp32.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.wifiSetupHeader,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.wifiSetupDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _ssidController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.wifiSetupNetworkLabel,
                  prefixIcon: const Icon(Icons.wifi),
                  suffixIcon: _isScanning
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          tooltip: 'Scan voor netwerken',
                          onPressed: _startScan,
                        ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.wifiSetupEmptyError;
                  }
                  return null;
                },
              ),
              if (_scannedNetworks.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _scannedNetworks.map((ssid) {
                    return ActionChip(
                      label: Text(ssid),
                      onPressed: () {
                        _ssidController.text = ssid;
                        setState(() {
                          _scannedNetworks.clear();
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _pskController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.wifiSetupPasswordLabel,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                obscureText: _obscurePassword,
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: LoadingIndicatorM3E())
              else
                FilledButton.icon(
                  onPressed: _saveWifi,
                  icon: const Icon(Icons.save),
                  label:
                      Text(AppLocalizations.of(context)!.wifiSetupSaveConnect),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
