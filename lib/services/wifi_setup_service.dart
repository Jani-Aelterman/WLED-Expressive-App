import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class WifiSetupService {
  static const String _ignoredAPsKey = 'wled_ignored_aps';

  // Return true if the user hasn't ignored this AP
  static Future<bool> isApIgnored(String ssid) async {
    final prefs = await SharedPreferences.getInstance();
    final ignored = prefs.getStringList(_ignoredAPsKey) ?? [];
    return ignored.contains(ssid);
  }

  // Add the AP to the ignore list
  static Future<void> ignoreAp(String ssid) async {
    final prefs = await SharedPreferences.getInstance();
    final ignored = prefs.getStringList(_ignoredAPsKey) ?? [];
    if (!ignored.contains(ssid)) {
      ignored.add(ssid);
      await prefs.setStringList(_ignoredAPsKey, ignored);
    }
  }

  // Scan for WLED APs. Only works on Android.
  // Returns the SSID of the first found WLED AP, or null if none found.
  static Future<String?> scanForWledAp() async {
    if (!Platform.isAndroid) return null;

    final status = await Permission.location.request();
    if (!status.isGranted) return null;

    final canScan = await WiFiScan.instance.canStartScan();
    if (canScan != CanStartScan.yes) return null;

    await WiFiScan.instance.startScan();

    // Give it a moment to scan
    await Future.delayed(const Duration(seconds: 2));

    final canGetResults = await WiFiScan.instance.canGetScannedResults();
    if (canGetResults != CanGetScannedResults.yes) return null;

    final results = await WiFiScan.instance.getScannedResults();

    for (var network in results) {
      if (network.ssid.isNotEmpty &&
          (network.ssid.startsWith('WLED-AP') ||
              network.ssid.startsWith('WLED-') ||
              network.ssid.startsWith('ESP_'))) {
        // Check if ignored
        if (!(await isApIgnored(network.ssid))) {
          return network.ssid; // Return the first one found that isn't ignored
        }
      }
    }

    return null;
  }

  // Check if an AP is secured based on the most recent scan results
  static Future<bool> isApSecure(String ssid) async {
    if (!Platform.isAndroid) return true; // Default to WPA

    final canGetResults = await WiFiScan.instance.canGetScannedResults();
    if (canGetResults != CanGetScannedResults.yes) return true;

    final results = await WiFiScan.instance.getScannedResults();
    for (var network in results) {
      if (network.ssid == ssid) {
        final cap = network.capabilities.toUpperCase();
        if (cap.contains('WPA') || cap.contains('WEP') || cap.contains('RSN')) {
          return true;
        } else {
          return false;
        }
      }
    }
    return true; // Default to true if not found in recent scan
  }

  // Connect to the specified AP. Returns true on success.
  static Future<bool> connectToAp(String ssid) async {
    // Check if the AP requires a password
    final isSecure = await isApSecure(ssid);

    // WLED default AP password is "wled1234"
    final connected = await WiFiForIoTPlugin.connect(
      ssid,
      password: isSecure ? "wled1234" : "",
      security: isSecure ? NetworkSecurity.WPA : NetworkSecurity.NONE,
      joinOnce: true,
      withInternet: false, // AP mode usually doesn't have internet
    );
    if (connected && Platform.isAndroid) {
      // Force Android to route traffic over this Wi-Fi network, even without internet
      await WiFiForIoTPlugin.forceWifiUsage(true);
      // Wait for DHCP to assign the 4.3.2.1 IP address
      await Future.delayed(const Duration(seconds: 4));
    }

    return connected;
  }

  // Disconnect and restore normal routing
  static Future<void> disconnectFromAp() async {
    if (Platform.isAndroid) {
      await WiFiForIoTPlugin.forceWifiUsage(false);
      await WiFiForIoTPlugin.disconnect();
    }
  }
}
