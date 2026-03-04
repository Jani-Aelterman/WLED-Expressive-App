import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wled_expressive/l10n/app_localizations.dart';

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

  @override
  void dispose() {
    _ssidController.dispose();
    _pskController.dispose();
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

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Wi-Fi instellingen opgeslagen! Verbinden...')),
          );
          // Go back to the device list
          Navigator.of(context).pop();
        }
      } else {
        throw Exception('Server gaf foutcode ${response.statusCode}');
      }
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _pskController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.wifiSetupPasswordLabel,
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
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
