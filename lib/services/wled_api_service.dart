import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WledApiService {
  static Future<Map<String, dynamic>?> getDeviceState(String ip) async {
    try {
      final response = await http
          .get(Uri.parse('http://$ip/json/state'))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getDeviceInfo(String ip) async {
    try {
      final response = await http
          .get(Uri.parse('http://$ip/json/info'))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<bool> togglePower(String ip, bool isOn) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"on": isOn}),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setBrightness(String ip, int brightness) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"bri": brightness}),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setColors(String ip, List<List<int>> colors) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "seg": [
                {"col": colors}
              ]
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<List<String>?> getEffects(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'wled_effects_$ip';

    // 1. Try to get from cache first for instant UI response
    final cachedEffects = prefs.getStringList(cacheKey);

    // 2. Fetch from network asynchronously (if cached) or synchronously (if not cached)
    Future<List<String>?> fetchFromNetwork() async {
      try {
        final response = await http
            .get(Uri.parse('http://$ip/json/eff'))
            .timeout(const Duration(seconds: 2));
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          final effectList = data.map((e) => e.toString()).toList();

          // Save to cache
          await prefs.setStringList(cacheKey, effectList);
          return effectList;
        }
      } catch (e) {
        // Silently fail the background refresh
        return null;
      }
      return null;
    }

    if (cachedEffects != null && cachedEffects.isNotEmpty) {
      // We have cache. Kick off background refresh but return cache immediately.
      fetchFromNetwork();
      return cachedEffects;
    } else {
      // No cache, we must wait for network.
      return await fetchFromNetwork();
    }
  }

  static Future<bool> setEffect(String ip, int effectId) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "seg": [
                {"fx": effectId}
              ]
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<List<String>?> getPalettes(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'wled_palettes_$ip';

    // 1. Try to get from cache first
    final cachedPalettes = prefs.getStringList(cacheKey);

    // 2. Fetch from network
    Future<List<String>?> fetchFromNetwork() async {
      try {
        final response = await http
            .get(Uri.parse('http://$ip/json/pal'))
            .timeout(const Duration(seconds: 2));
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          final paletteList = data.map((e) => e.toString()).toList();

          // Save to cache
          await prefs.setStringList(cacheKey, paletteList);
          return paletteList;
        }
      } catch (e) {
        return null; // Silently fail background refresh
      }
      return null;
    }

    if (cachedPalettes != null && cachedPalettes.isNotEmpty) {
      // We have cache. Kick off background refresh but return cache immediately.
      fetchFromNetwork();
      return cachedPalettes;
    } else {
      // No cache, we must wait for network.
      return await fetchFromNetwork();
    }
  }

  static Future<bool> setPalette(String ip, int paletteId) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "seg": [
                {"pal": paletteId}
              ]
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getPresets(String ip,
      {bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'wled_presets_$ip';

    Map<String, dynamic>? cachedPresets;
    if (!forceRefresh) {
      // 1. Try to get from cache first
      final cachedPresetsStr = prefs.getString(cacheKey);
      if (cachedPresetsStr != null) {
        try {
          cachedPresets = jsonDecode(cachedPresetsStr);
        } catch (e) {
          // Cache corrupted, ignore
        }
      }
    }

    // 2. Fetch from network
    Future<Map<String, dynamic>?> fetchFromNetwork() async {
      try {
        final response = await http
            .get(Uri.parse('http://$ip/presets.json'))
            .timeout(const Duration(seconds: 2));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          // Save to cache (as JSON String)
          await prefs.setString(cacheKey, response.body);
          return data;
        }
      } catch (e) {
        return null;
      }
      return null;
    }

    if (cachedPresets != null) {
      // Kick off background refresh
      fetchFromNetwork();
      return cachedPresets;
    } else {
      return await fetchFromNetwork();
    }
  }

  static Future<bool> setPreset(String ip, int presetId) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"ps": presetId}),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getDeviceConfig(String ip) async {
    try {
      final response = await http
          .get(Uri.parse('http://$ip/json/cfg'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> setDeviceConfig(
      String ip, Map<String, dynamic> config) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/cfg'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(config),
          )
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setLiveOverride(String ip, int lorMode) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"lor": lorMode}),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> toggleSync(String ip, bool sync) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "udpn": {"send": sync}
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> toggleTimer(String ip, bool timer) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "nl": {"on": timer}
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> savePreset(String ip, int presetId, String name) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"psave": presetId, "n": name}),
          )
          .timeout(const Duration(seconds: 4));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<void> identifyDevice(String ip) async {
    try {
      final state = await getDeviceState(ip);
      if (state == null) return;
      bool isOn = state['on'] ?? false;

      // Blink sequence
      await togglePower(ip, !isOn);
      await Future.delayed(const Duration(milliseconds: 400));
      await togglePower(ip, isOn);
      await Future.delayed(const Duration(milliseconds: 400));
      await togglePower(ip, !isOn);
      await Future.delayed(const Duration(milliseconds: 400));
      await togglePower(ip, isOn);
    } catch (e) {
      // Ignore errors during identify
    }
  }

  static Future<bool> updateSegment(
      String ip, int segmentId, Map<String, dynamic> data) async {
    try {
      data['id'] = segmentId;
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "seg": [data]
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> createSegment(String ip, int start, int stop) async {
    try {
      // In WLED, appending a segment means sending a start and stop index without an ID,
      // or specifying the next available ID. We provide start and stop.
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "seg": [
                {
                  "start": start,
                  "stop": stop,
                }
              ]
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteSegment(String ip, int segmentId) async {
    try {
      // In WLED, deleting a segment is done by setting stop = 0
      final response = await http
          .post(
            Uri.parse('http://$ip/json/state'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "seg": [
                {
                  "id": segmentId,
                  "stop": 0,
                }
              ]
            }),
          )
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
