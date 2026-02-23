import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeService themeService;

  const SettingsScreen({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instellingen'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: themeService,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle(context, 'Thema'),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: const Text('Systeem'),
                        value: ThemeMode.system,
                        groupValue: themeService.themeMode,
                        onChanged: (mode) => themeService.setThemeMode(mode!),
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('Licht'),
                        value: ThemeMode.light,
                        groupValue: themeService.themeMode,
                        onChanged: (mode) => themeService.setThemeMode(mode!),
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('Donker'),
                        value: ThemeMode.dark,
                        groupValue: themeService.themeMode,
                        onChanged: (mode) => themeService.setThemeMode(mode!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Kleuren'),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dynamische kleuren'),
                      subtitle:
                          const Text('Gebruik systeemkleuren (Android 12+)'),
                      value: themeService.useDynamicColor,
                      onChanged: (value) =>
                          themeService.setUseDynamicColor(value),
                    ),
                    if (!themeService.useDynamicColor) ...[
                      const Divider(indent: 16, endIndent: 16),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Kies een accentkleur'),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _ColorButton(
                                  color: Colors.deepPurple,
                                  isSelected: themeService.seedColor ==
                                      Colors.deepPurple,
                                  onTap: () => themeService
                                      .setSeedColor(Colors.deepPurple),
                                ),
                                _ColorButton(
                                  color: Colors.blue,
                                  isSelected:
                                      themeService.seedColor == Colors.blue,
                                  onTap: () =>
                                      themeService.setSeedColor(Colors.blue),
                                ),
                                _ColorButton(
                                  color: Colors.teal,
                                  isSelected:
                                      themeService.seedColor == Colors.teal,
                                  onTap: () =>
                                      themeService.setSeedColor(Colors.teal),
                                ),
                                _ColorButton(
                                  color: Colors.green,
                                  isSelected:
                                      themeService.seedColor == Colors.green,
                                  onTap: () =>
                                      themeService.setSeedColor(Colors.green),
                                ),
                                _ColorButton(
                                  color: Colors.orange,
                                  isSelected:
                                      themeService.seedColor == Colors.orange,
                                  onTap: () =>
                                      themeService.setSeedColor(Colors.orange),
                                ),
                                _ColorButton(
                                  color: Colors.red,
                                  isSelected:
                                      themeService.seedColor == Colors.red,
                                  onTap: () =>
                                      themeService.setSeedColor(Colors.red),
                                ),
                                _ColorButton(
                                  color: Colors.pink,
                                  isSelected:
                                      themeService.seedColor == Colors.pink,
                                  onTap: () =>
                                      themeService.setSeedColor(Colors.pink),
                                ),
                                _ColorButton(
                                  color: Colors.blueGrey,
                                  isSelected:
                                      themeService.seedColor == Colors.blueGrey,
                                  onTap: () => themeService
                                      .setSeedColor(Colors.blueGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.settings_suggest, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'WLED Material 3',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    Text(
                      'v1.0.0',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorButton({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 3,
                )
              : null,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
