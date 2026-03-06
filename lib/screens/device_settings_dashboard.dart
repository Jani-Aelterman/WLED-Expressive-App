import 'package:flutter/material.dart';
import 'package:wled_expressive/l10n/app_localizations.dart';
import '../models/wled_device.dart';
import 'web_view_screen.dart';
import 'device_settings_wifi_screen.dart';

class DeviceSettingsDashboard extends StatelessWidget {
  final WledDevice device;

  const DeviceSettingsDashboard({super.key, required this.device});

  void _openSettingsSubpage(BuildContext context, String path, String title) {
    if (path == 'wifi') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceSettingsWifiScreen(device: device),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          device: device,
          url: 'http://${device.ip}/settings/$path',
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsCard(
            context,
            icon: Icons.wifi,
            title: AppLocalizations.of(context)!.settingsWifi,
            path: 'wifi',
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            icon: Icons.lightbulb_outline,
            title: AppLocalizations.of(context)!.settingsLeds,
            path: 'leds',
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            icon: Icons.dashboard_customize_outlined,
            title: AppLocalizations.of(context)!.settingsUi,
            path: 'ui',
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            icon: Icons.sync_alt,
            title: AppLocalizations.of(context)!.settingsSync,
            path: 'sync',
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            icon: Icons.access_time,
            title: AppLocalizations.of(context)!.settingsTime,
            path: 'time',
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            context,
            icon: Icons.security,
            title: AppLocalizations.of(context)!.settingsSecurity,
            path: 'sec',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String path,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openSettingsSubpage(context, path, title),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
          child: Row(
            children: [
              Icon(icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Icon(Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
