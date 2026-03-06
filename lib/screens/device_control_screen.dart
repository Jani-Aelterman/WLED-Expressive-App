import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../services/theme_service.dart';
import 'package:wled_expressive/l10n/app_localizations.dart';
import 'device_settings_dashboard.dart';
import 'segments_screen.dart';
import '../models/wled_device.dart';
import '../services/wled_api_service.dart';
import '../widgets/expressive_switch.dart';

class DeviceControlScreen extends StatefulWidget {
  final WledDevice device;

  const DeviceControlScreen({super.key, required this.device});

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  late bool isOn;
  late double brightness;
  List<Color> slotColors = [Colors.blue, Colors.black, Colors.black];
  int _selectedColorSlot = 0;
  int _selectedIndex = 0;

  bool isLive = false;
  String liveIp = "";

  bool isSyncOn = false;
  bool isTimerOn = false;

  List<String> effects = [];
  int currentEffectId = 0;
  bool isLoadingEffects = true;

  List<String> palettes = [];
  int currentPaletteId = 0;
  bool isLoadingPalettes = true;

  Map<String, dynamic> presets = {};
  int currentPresetId = -1;
  bool isLoadingPresets = true;

  String _effectSearchQuery = '';
  String _paletteSearchQuery = '';
  final TextEditingController _effectSearchController = TextEditingController();
  final TextEditingController _paletteSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    isOn = widget.device.isOn;
    brightness = widget.device.brightness.toDouble();
    _fetchCurrentState();
    _fetchEffects();
    _fetchPalettes();
    _fetchPresets();
  }

  @override
  void dispose() {
    _effectSearchController.dispose();
    _paletteSearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEffects() async {
    final fetchedEffects = await WledApiService.getEffects(widget.device.ip);
    if (mounted) {
      setState(() {
        effects = fetchedEffects ?? [];
        isLoadingEffects = false;
      });
    }
  }

  Future<void> _fetchPalettes() async {
    final fetchedPalettes = await WledApiService.getPalettes(widget.device.ip);
    if (mounted) {
      setState(() {
        palettes = fetchedPalettes ?? [];
        isLoadingPalettes = false;
      });
    }
  }

  Future<void> _fetchPresets() async {
    final fetchedPresets = await WledApiService.getPresets(widget.device.ip);
    if (mounted) {
      setState(() {
        // Filter out the "0" preset which is usually just a placeholder or empty
        if (fetchedPresets != null) {
          fetchedPresets.remove("0");
          presets = fetchedPresets;
        }
        isLoadingPresets = false;
      });
    }
  }

  Future<void> _fetchCurrentState() async {
    final state = await WledApiService.getDeviceState(widget.device.ip);
    final info = await WledApiService.getDeviceInfo(widget.device.ip);

    if (state != null && mounted) {
      setState(() {
        if (info != null) {
          isLive = info['live'] ?? false;
          liveIp = info['lip'] ?? "";
          widget.device.isLive = isLive;
          widget.device.liveIp = liveIp;
        }

        isOn = state['on'] ?? false;
        brightness = (state['bri'] ?? 128).toDouble();

        // Sync and Timer
        if (state['udpn'] != null) {
          isSyncOn = state['udpn']['send'] ?? false;
        }
        if (state['nl'] != null) {
          isTimerOn = state['nl']['on'] ?? false;
        }

        // Preset
        if (state['ps'] != null) {
          currentPresetId = state['ps'];
        }

        // Try to parse color, effect, and palette from first segment
        try {
          final segs = state['seg'] as List;
          if (segs.isNotEmpty) {
            final firstSeg = segs[0];

            // Parse effect ID
            if (firstSeg['fx'] != null) {
              currentEffectId = firstSeg['fx'];
            }

            // Parse palette ID
            if (firstSeg['pal'] != null) {
              currentPaletteId = firstSeg['pal'];
            }

            final colors = firstSeg['col'] as List;
            for (int i = 0; i < colors.length && i < 3; i++) {
              final rgb = colors[i] as List;
              slotColors[i] = Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1.0);
            }
          }
        } catch (e) {
          // Ignore parsing errors
        }
      });
    }
  }

  void _togglePower() async {
    final newState = !isOn;
    setState(() {
      isOn = newState;
      widget.device.isOn = newState;
    });

    final success =
        await WledApiService.togglePower(widget.device.ip, newState);
    if (!success && mounted) {
      setState(() {
        isOn = !newState;
        widget.device.isOn = !newState;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.deviceUnreachable)),
      );
    }
  }

  void _changeBrightness(double value) {
    setState(() {
      brightness = value;
    });
  }

  void _changeBrightnessEnd(double value) async {
    widget.device.brightness = value.toInt();
    await WledApiService.setBrightness(widget.device.ip, value.toInt());
  }

  void _changeColor(Color color) {
    setState(() => slotColors[_selectedColorSlot] = color);
  }

  void _applyColor() async {
    // When applying a solid color, we usually want to set the effect to "Solid" (ID 0)
    // so the color is actually visible.
    setState(() {
      currentEffectId = 0;
    });

    await WledApiService.setEffect(widget.device.ip, 0);
    final List<List<int>> colors =
        slotColors.map((c) => [c.red, c.green, c.blue]).toList();
    await WledApiService.setColors(widget.device.ip, colors);
  }

  void _applyEffect(int effectId) async {
    setState(() {
      currentEffectId = effectId;
    });
    await WledApiService.setEffect(widget.device.ip, effectId);
  }

  void _applyPalette(int paletteId) async {
    setState(() {
      currentPaletteId = paletteId;
    });
    await WledApiService.setPalette(widget.device.ip, paletteId);
  }

  void _applyPreset(int presetId) async {
    setState(() {
      currentPresetId = presetId;
    });
    await WledApiService.setPreset(widget.device.ip, presetId);
    // Refresh state after applying preset
    _fetchCurrentState();
  }

  void _overrideLiveData(int lorMode) async {
    final success =
        await WledApiService.setLiveOverride(widget.device.ip, lorMode);
    if (success && mounted) {
      // Re-fetch state to clear the warning banner
      setState(() {
        isLive = false; // Optimistically hide
      });
      _fetchCurrentState();
    }
  }

  Widget _buildLiveOverrideWarning() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sensors,
                  color: Theme.of(context).colorScheme.onErrorContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.liveDataActive,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.liveDataActiveDesc(liveIp),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _overrideLiveData(1), // Override Once
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onErrorContainer,
                ),
                child: Text(AppLocalizations.of(context)!.liveDataOverrideOnce),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: () => _overrideLiveData(2), // Override until reboot
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .onErrorContainer
                      .withValues(alpha: 0.2),
                  foregroundColor:
                      Theme.of(context).colorScheme.onErrorContainer,
                ),
                child:
                    Text(AppLocalizations.of(context)!.liveDataOverrideReboot),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleSync() async {
    final newState = !isSyncOn;
    setState(() {
      isSyncOn = newState;
    });
    await WledApiService.toggleSync(widget.device.ip, newState);
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                newState ? Icons.sync : Icons.sync_disabled,
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  newState
                      ? '${AppLocalizations.of(context)!.on} — ${widget.device.name}'
                      : AppLocalizations.of(context)!.off,
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _toggleTimer() async {
    final newState = !isTimerOn;
    setState(() {
      isTimerOn = newState;
    });
    await WledApiService.toggleTimer(widget.device.ip, newState);
  }

  Future<void> _openWebInterface() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceSettingsDashboard(device: widget.device),
      ),
    );
  }

  void _showSavePresetDialog() {
    final nameController = TextEditingController();
    int nextId = 1;
    while (presets.containsKey(nextId.toString()) && nextId < 250) {
      nextId++;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addDeviceTitle),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.deviceNameLabel,
            hintText: AppLocalizations.of(context)!.deviceNameHint,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                Navigator.pop(context);
                setState(() {
                  isLoadingPresets = true;
                });
                await WledApiService.savePreset(
                    widget.device.ip, nextId, nameController.text);
                await _fetchPresets();
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows body to scroll under the floating nav bar
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: [
          isOn
              ? IconButton.filledTonal(
                  icon: const Icon(Icons.power_settings_new),
                  tooltip: 'Aan/Uit',
                  onPressed: _togglePower,
                )
              : IconButton.outlined(
                  icon: const Icon(Icons.power_settings_new_outlined),
                  tooltip: 'Aan/Uit',
                  onPressed: _togglePower,
                ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              // Lichte "pill" achter de NavigationBar zodat hij echt float
              color: Theme.of(context).colorScheme.surfaceBright,
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.6),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.0),
              child: NavigationBar(
                // Zelf ook een lichte achtergrond voor extra contrast
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surfaceBright
                    .withValues(alpha: 0.95),
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.color_lens_outlined),
                    selectedIcon: const Icon(Icons.color_lens),
                    label: AppLocalizations.of(context)!.colorTab,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.palette_outlined),
                    selectedIcon: const Icon(Icons.palette),
                    label: AppLocalizations.of(context)!.palettesTab,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.auto_awesome_outlined),
                    selectedIcon: const Icon(Icons.auto_awesome),
                    label: AppLocalizations.of(context)!.effectsTab,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.favorite_border),
                    selectedIcon: const Icon(Icons.favorite),
                    label: AppLocalizations.of(context)!.presetsTab,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        if (isLive) _buildLiveOverrideWarning(),
        _buildQuickActionsRow(),
        Expanded(
          child: Builder(builder: (context) {
            switch (_selectedIndex) {
              case 0:
                return _buildColorTab();
              case 1:
                return _buildPalettesTab();
              case 2:
                return _buildEffectsTab();
              case 3:
                return _buildPresetsTab();
              default:
                return _buildColorTab();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildQuickActionsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildQuickActionButton(
            icon: isSyncOn ? Icons.sync : Icons.sync_disabled,
            label: AppLocalizations.of(context)!.actionSync,
            isActive: isSyncOn,
            onPressed: _toggleSync,
          ),
          const SizedBox(width: 12),
          _buildQuickActionButton(
            icon: Icons.view_week,
            label: AppLocalizations.of(context)!.actionSegments,
            isActive: false,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SegmentsScreen(device: widget.device),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          _buildQuickActionButton(
            icon: isTimerOn ? Icons.timer : Icons.timer_off_outlined,
            label: AppLocalizations.of(context)!.actionTimer,
            isActive: isTimerOn,
            onPressed: _toggleTimer,
          ),
          const SizedBox(width: 12),
          _buildQuickActionButton(
            icon: Icons.settings,
            label: AppLocalizations.of(context)!.actionSettings,
            isActive: false,
            onPressed: _openWebInterface,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: isActive
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: isActive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant),
              const SizedBox(height: 4),
              Text(label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isActive
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          left: 24.0, right: 24.0, top: 24.0, bottom: 120.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCirc,
            decoration: BoxDecoration(
              color: isOn
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
              boxShadow: isOn
                  ? [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: InkWell(
              onTap: _togglePower,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            isOn ? Icons.lightbulb : Icons.lightbulb_outline,
                            key: ValueKey<bool>(isOn),
                            size: 32,
                            color: isOn
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: isOn
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                          child: Text(isOn
                              ? AppLocalizations.of(context)!.on
                              : AppLocalizations.of(context)!.off),
                        ),
                      ],
                    ),
                    ExpressiveSwitch(
                      value: isOn,
                      onChanged: (val) => _togglePower(),
                      activeIcon: const Icon(Icons.power_settings_new),
                      inactiveIcon: const Icon(Icons.power_settings_new),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Brightness Section
          Text(
            AppLocalizations.of(context)!.brightness,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.brightness_low,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Slider(
                      value: brightness,
                      min: 1,
                      max: 255,
                      divisions: 20,
                      label: '${((brightness / 255) * 100).round()}%',
                      onChanged: (val) {
                        if (Provider.of<ThemeService>(context, listen: false)
                            .enableHaptics) {
                          HapticFeedback.selectionClick();
                        }
                        _changeBrightness(val);
                      },
                      onChangeEnd: (val) {
                        if (Provider.of<ThemeService>(context, listen: false)
                            .enableHaptics) {
                          HapticFeedback.lightImpact();
                        }
                        _changeBrightnessEnd(val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.brightness_high,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 44,
                    child: Text(
                      '${((brightness / 255) * 100).round()}%',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Color Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.color,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('1')),
                  ButtonSegment(value: 1, label: Text('2')),
                  ButtonSegment(value: 2, label: Text('3')),
                ],
                selected: {_selectedColorSlot},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    _selectedColorSlot = newSelection.first;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  ColorPicker(
                    pickerColor: slotColors[_selectedColorSlot],
                    onColorChanged: _changeColor,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    paletteType: PaletteType.hsvWithHue,
                    labelTypes: const [],
                    pickerAreaBorderRadius:
                        const BorderRadius.all(Radius.circular(16)),
                  ),
                  const SizedBox(height: 16),
                  // Quick Colors
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Colors.red,
                        Colors.orange,
                        Colors.yellow,
                        Colors.green,
                        Colors.cyan,
                        Colors.blue,
                        Colors.purple,
                        Colors.pink,
                        Colors.white,
                        Colors.black,
                      ]
                          .map((color) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    _changeColor(color);
                                    _applyColor();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outlineVariant,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // Quick Presets Row
                  if (presets.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.quickPresets,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: presets.length > 15 ? 15 : presets.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          // Sort keys to ensure consistent ordering based on preset ID
                          final presetKeys = presets.keys.toList()
                            ..sort(
                                (a, b) => int.parse(a).compareTo(int.parse(b)));
                          final presetIdStr = presetKeys[index];
                          final presetId = int.parse(presetIdStr);
                          final presetData = presets[presetIdStr];
                          final presetName =
                              presetData['n'] ?? 'Preset $presetId';

                          final isSelected = currentPresetId == presetId;

                          return ActionChip(
                            label: Text(presetName),
                            avatar: Icon(
                              Icons.favorite,
                              size: 16,
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surface,
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                            ),
                            onPressed: () => _applyPreset(presetId),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _applyColor,
                    icon: const Icon(Icons.color_lens),
                    label: Text(AppLocalizations.of(context)!.applyColor),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(64),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectsTab() {
    if (isLoadingEffects) {
      return const Center(child: CircularProgressIndicator());
    }

    if (effects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorLoadEffects,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
      );
    }

    final filteredEffects = effects
        .asMap()
        .entries
        .where((entry) => entry.value
            .toLowerCase()
            .contains(_effectSearchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: SearchBar(
            controller: _effectSearchController,
            hintText: AppLocalizations.of(context)!.searchEffects,
            leading: const Icon(Icons.search),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainerHighest),
            trailing: _effectSearchQuery.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _effectSearchController.clear();
                        setState(() => _effectSearchQuery = '');
                      },
                    )
                  ]
                : null,
            onChanged: (value) {
              setState(() => _effectSearchQuery = value);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 120.0),
            itemCount: filteredEffects.length,
            itemBuilder: (context, index) {
              final originalIndex = filteredEffects[index].key;
              final effectName = filteredEffects[index].value;
              final isSelected = currentEffectId == originalIndex;

              return Card(
                elevation: isSelected ? 2 : 0,
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                margin: const EdgeInsets.only(bottom: 8.0),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  title: Text(
                    effectName,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () => _applyEffect(originalIndex),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getPalettePreview(int index) {
    // Basic mapping for common WLED palettes
    final Map<int, List<Color>> previews = {
      0: [Colors.white, Colors.white, Colors.white], // Default
      1: [Colors.red, Colors.green, Colors.blue], // Random Cycle
      2: [Colors.red, Colors.red, Colors.red], // Primary Color
      3: [Colors.red, Colors.green, Colors.black], // Based on Colors
      4: [Colors.red, Colors.orange, Colors.yellow], // Fire
      5: [Colors.blue, Colors.cyan, Colors.white], // Ice
      6: [Colors.red, Colors.yellow, Colors.blue], // Party
      7: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple
      ], // Rainbow
      11: [Colors.blue, Colors.white, Colors.blue], // Ocean
      35: [Colors.green, Colors.yellow, Colors.red], // Forest
    };

    final colors = previews[index] ?? [Colors.grey, Colors.grey, Colors.grey];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors
          .take(4)
          .map((color) => Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPalettesTab() {
    if (isLoadingPalettes) {
      return const Center(child: CircularProgressIndicator());
    }

    if (palettes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorLoadPalettes,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
      );
    }

    final filteredPalettes = palettes
        .asMap()
        .entries
        .where((entry) => entry.value
            .toLowerCase()
            .contains(_paletteSearchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: SearchBar(
            controller: _paletteSearchController,
            hintText: AppLocalizations.of(context)!.searchPalettes,
            leading: const Icon(Icons.search),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainerHighest),
            trailing: _paletteSearchQuery.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _paletteSearchController.clear();
                        setState(() => _paletteSearchQuery = '');
                      },
                    )
                  ]
                : null,
            onChanged: (value) {
              setState(() => _paletteSearchQuery = value);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 120.0),
            itemCount: filteredPalettes.length,
            itemBuilder: (context, index) {
              final originalIndex = filteredPalettes[index].key;
              final paletteName = filteredPalettes[index].value;
              final isSelected = currentPaletteId == originalIndex;

              return Card(
                elevation: isSelected ? 2 : 0,
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                margin: const EdgeInsets.only(bottom: 8.0),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: _getPalettePreview(originalIndex),
                  title: Text(
                    paletteName,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () => _applyPalette(originalIndex),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPresetsTab() {
    if (isLoadingPresets) {
      return const Center(child: CircularProgressIndicator());
    }

    if (presets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border,
                size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noPresetsFound,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.createPresetsHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    final presetKeys = presets.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    return ListView.builder(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 16.0, bottom: 120.0),
      itemCount: presetKeys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FilledButton.icon(
              onPressed: _showSavePresetDialog,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.saveStateAsPreset),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        }

        final presetIdStr = presetKeys[index - 1];
        final presetId = int.parse(presetIdStr);
        final presetData = presets[presetIdStr];
        final presetName = presetData['n'] ?? 'Preset $presetId';
        final isSelected = currentPresetId == presetId;

        return Card(
          elevation: isSelected ? 2 : 0,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          margin: const EdgeInsets.only(bottom: 8.0),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
              child: Text(
                presetIdStr,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            title: Text(
              presetName,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check,
                    color: Theme.of(context).colorScheme.primary)
                : null,
            onTap: () => _applyPreset(presetId),
          ),
        );
      },
    );
  }
}
