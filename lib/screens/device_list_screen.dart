import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../services/theme_service.dart';
import 'package:multicast_dns/multicast_dns.dart';
import '../models/wled_device.dart';
import '../services/wled_api_service.dart';
import 'device_control_screen.dart';

import 'settings_screen.dart';
import '../services/locale_service.dart';
import '../widgets/expressive_switch.dart';
import 'package:wled_expressive/l10n/app_localizations.dart';

class DeviceListScreen extends StatefulWidget {
  final ThemeService themeService;
  final LocaleService localeService;
  const DeviceListScreen(
      {super.key, required this.themeService, required this.localeService});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<WledDevice> devices = [];
  bool isLoading = true;
  bool isDiscovering = false;
  double _globalBrightness = 128;
  WledDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _discoverDevices() async {
    if (isDiscovering) return;

    setState(() {
      isDiscovering = true;
    });

    try {
      final MDnsClient client = MDnsClient();
      await client.start();

      // WLED devices broadcast as _wled._tcp.local
      const String name = '_wled._tcp.local';

      await for (final PtrResourceRecord ptr in client
          .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
        await for (final SrvResourceRecord srv
            in client.lookup<SrvResourceRecord>(
                ResourceRecordQuery.service(ptr.domainName))) {
          await for (final IPAddressResourceRecord ip
              in client.lookup<IPAddressResourceRecord>(
                  ResourceRecordQuery.addressIPv4(srv.target))) {
            final String discoveredIp = ip.address.address;

            // Check if we already have this device
            final exists = devices.any((d) => d.ip == discoveredIp);
            if (!exists) {
              final newDevice = WledDevice(
                name: 'WLED (${discoveredIp.split('.').last})',
                ip: discoveredIp,
              );

              if (mounted) {
                setState(() {
                  devices.add(newDevice);
                });
                _saveDevices();
                _updateDeviceStatus(newDevice);
              }
            }
          }
        }
      }
      client.stop();
    } catch (e) {
      debugPrint('mDNS discovery error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isDiscovering = false;
        });
      }
    }
  }

  Future<void> _loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? devicesJson = prefs.getString('wled_devices');

    if (devicesJson != null) {
      final List<dynamic> decoded = jsonDecode(devicesJson);
      setState(() {
        devices = decoded.map((item) => WledDevice.fromJson(item)).toList();
      });
      _refreshAllDevices();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(devices.map((d) => d.toJson()).toList());
    await prefs.setString('wled_devices', encoded);
  }

  Future<void> _refreshAllDevices() async {
    setState(() {
      isLoading = true;
    });

    // Start background discovery
    _discoverDevices();

    // Create a copy of the list to iterate over to avoid ConcurrentModificationError
    // if _discoverDevices adds new devices while we are iterating
    final devicesCopy = List<WledDevice>.from(devices);
    for (var device in devicesCopy) {
      await _updateDeviceStatus(device);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _updateDeviceStatus(WledDevice device) async {
    final state = await WledApiService.getDeviceState(device.ip);
    final info = await WledApiService.getDeviceInfo(device.ip);

    if (!mounted) return;

    if (state != null && info != null) {
      setState(() {
        device.isOnline = true;
        device.isOn = state['on'] ?? false;
        device.brightness = state['bri'] ?? 128;
        _updateGlobalBrightness();
      });
    } else {
      setState(() {
        device.isOnline = false;
        _updateGlobalBrightness();
      });
    }
  }

  void _showAddDeviceDialog() {
    final ipController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addDeviceTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.deviceNameLabel,
                hintText: AppLocalizations.of(context)!.deviceNameHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.deviceIpLabel,
                hintText: AppLocalizations.of(context)!.deviceIpHint,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (ipController.text.isNotEmpty) {
                final newDevice = WledDevice(
                  name: nameController.text.isNotEmpty
                      ? nameController.text
                      : 'WLED',
                  ip: ipController.text,
                );
                setState(() {
                  devices.add(newDevice);
                });
                _saveDevices();
                _updateDeviceStatus(newDevice);
                Navigator.pop(context);
              }
            },
            child: const Text('Toevoegen'),
          ),
        ],
      ),
    );
  }

  void _showEditDeviceDialog(WledDevice device) {
    final nameController = TextEditingController(text: device.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apparaat bewerken'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Naam',
                hintText: 'Mijn Lamp',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => WledApiService.identifyDevice(device.ip),
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('Identificeer (Knipper)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  device.name = nameController.text;
                });
                _saveDevices();
                Navigator.pop(context);
              }
            },
            child: const Text('Opslaan'),
          ),
        ],
      ),
    );
  }

  void _deleteDevice(WledDevice device) {
    setState(() {
      devices.remove(device);
    });
    _saveDevices();
  }

  Future<void> _toggleAllPower(bool turnOn) async {
    if (devices.isEmpty) return;

    setState(() {
      for (final d in devices) {
        d.isOn = turnOn;
      }
      _updateGlobalBrightness();
    });

    for (final device in devices) {
      await WledApiService.togglePower(device.ip, turnOn);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(turnOn
              ? 'Alle apparaten worden ingeschakeld'
              : 'Alle apparaten worden uitgeschakeld'),
        ),
      );
    }
  }

  void _updateGlobalBrightness() {
    if (devices.isEmpty) return;

    int totalBrightness = 0;
    int count = 0;

    for (var device in devices) {
      if (device.isOnline) {
        // If the device is off, contribute 0 to the average brightness
        totalBrightness += device.isOn ? device.brightness : 0;
        count++;
      }
    }

    if (count > 0) {
      double avg = totalBrightness / count;
      _globalBrightness = avg.clamp(1.0, 255.0);
    }
  }

  void _changeAllBrightness(double value) {
    setState(() {
      _globalBrightness = value;
      for (final d in devices) {
        if (d.isOnline) d.brightness = value.toInt();
      }
    });
  }

  void _changeAllBrightnessEnd(double value) async {
    for (final device in devices) {
      if (device.isOnline) {
        WledApiService.setBrightness(device.ip, value.toInt());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WLED'),
        centerTitle: true,
        actions: [
          if (isDiscovering)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAllDevices,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings_suggest,
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'WLED Expressive',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settingsTab),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                        themeService: widget.themeService,
                        localeService: widget.localeService),
                  ),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          Widget listContent = isLoading && devices.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : devices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.noDevicesTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.noDevicesSubtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshAllDevices,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: devices.isEmpty ? 0 : devices.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final isAnyOn =
                                devices.any((d) => d.isOn && d.isOnline);

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCirc,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: isAnyOn
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: isAnyOn
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
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                      color: isAnyOn
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .onPrimaryContainer
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onSurface,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .allControlTitle),
                                              ),
                                              AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: isAnyOn
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .onPrimaryContainer
                                                              .withOpacity(0.7)
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onSurfaceVariant,
                                                    ),
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .allControlSubtitle),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ExpressiveSwitch(
                                          value: isAnyOn,
                                          onChanged: (value) =>
                                              _toggleAllPower(value),
                                          activeIcon: const Icon(
                                              Icons.power_settings_new),
                                          inactiveIcon: const Icon(
                                              Icons.power_settings_new),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Icon(Icons.brightness_low,
                                            size: 20,
                                            color: isAnyOn
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Slider(
                                            value: _globalBrightness,
                                            min: 1,
                                            max: 255,
                                            divisions: 20,
                                            label:
                                                '${((_globalBrightness / 255) * 100).round()}%',
                                            activeColor: isAnyOn
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            inactiveColor: isAnyOn
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                    .withOpacity(0.2)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                    .withOpacity(0.2),
                                            onChanged: (val) {
                                              if (Provider.of<ThemeService>(
                                                      context,
                                                      listen: false)
                                                  .enableHaptics) {
                                                HapticFeedback.selectionClick();
                                              }
                                              _changeAllBrightness(val);
                                            },
                                            onChangeEnd: (val) {
                                              if (Provider.of<ThemeService>(
                                                      context,
                                                      listen: false)
                                                  .enableHaptics) {
                                                HapticFeedback.lightImpact();
                                              }
                                              _changeAllBrightnessEnd(val);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(Icons.brightness_high,
                                            size: 20,
                                            color: isAnyOn
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                          width: 44,
                                          child: Text(
                                            '${((_globalBrightness / 255) * 100).round()}%',
                                            textAlign: TextAlign.right,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: isAnyOn
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onPrimaryContainer
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final device = devices[index - 1];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            clipBehavior: Clip.antiAlias,
                            elevation: 0,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (isWide) {
                                  setState(() {
                                    _selectedDevice = device;
                                  });
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeviceControlScreen(device: device),
                                    ),
                                  ).then((_) => _updateDeviceStatus(device));
                                }
                              },
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SafeArea(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.edit),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .editAndIdentify),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _showEditDeviceDialog(device);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .delete,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error)),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _deleteDevice(device);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: device.isOnline
                                                ? (device.isOn
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.2)
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainer)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .errorContainer,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.lightbulb,
                                            size: 24,
                                            color: device.isOnline
                                                ? (device.isOn
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onErrorContainer,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                device.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text(
                                                device.isOnline
                                                    ? device.ip
                                                    : '${AppLocalizations.of(context)!.offline} - ${device.ip}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: device.isOnline
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .onSurfaceVariant
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .error,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (device.isOnline)
                                          ExpressiveSwitch(
                                            value: device.isOn,
                                            onChanged: (value) async {
                                              setState(() {
                                                device.isOn = value;
                                                _updateGlobalBrightness();
                                              });
                                              final success =
                                                  await WledApiService
                                                      .togglePower(
                                                          device.ip, value);
                                              if (!success) {
                                                setState(() {
                                                  device.isOn = !value;
                                                  _updateGlobalBrightness();
                                                });
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Kon apparaat niet bereiken')),
                                                  );
                                                }
                                              }
                                            },
                                            activeIcon: const Icon(
                                                Icons.power_settings_new),
                                            inactiveIcon: const Icon(
                                                Icons.power_settings_new),
                                          ),
                                      ],
                                    ),
                                    if (device.isOnline && device.isOn)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.brightness_low,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Slider(
                                                value: device.brightness
                                                    .toDouble()
                                                    .clamp(1.0, 255.0),
                                                min: 1,
                                                max: 255,
                                                divisions: 20,
                                                label:
                                                    '${((device.brightness / 255) * 100).round()}%',
                                                onChanged: (val) {
                                                  if (Provider.of<ThemeService>(
                                                          context,
                                                          listen: false)
                                                      .enableHaptics) {
                                                    HapticFeedback
                                                        .selectionClick();
                                                  }
                                                  setState(() {
                                                    device.brightness =
                                                        val.toInt();
                                                    _updateGlobalBrightness();
                                                  });
                                                },
                                                onChangeEnd: (val) {
                                                  if (Provider.of<ThemeService>(
                                                          context,
                                                          listen: false)
                                                      .enableHaptics) {
                                                    HapticFeedback
                                                        .lightImpact();
                                                  }
                                                  WledApiService.setBrightness(
                                                      device.ip, val.toInt());
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(Icons.brightness_high,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: 36,
                                              child: Text(
                                                '${((device.brightness / 255) * 100).round()}%',
                                                textAlign: TextAlign.right,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: listContent,
                ),
                Container(
                  width: 1,
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.5),
                ),
                Expanded(
                  flex: 2,
                  child: _selectedDevice != null
                      ? DeviceControlScreen(
                          key: ValueKey(_selectedDevice!.ip),
                          device: _selectedDevice!,
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.important_devices_outlined,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.outline),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!
                                    .selectDeviceToControl,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            );
          }

          return listContent;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDeviceDialog,
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addDeviceButton),
      ),
    );
  }
}
