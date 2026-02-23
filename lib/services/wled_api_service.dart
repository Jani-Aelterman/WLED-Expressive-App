import 'dart:convert';
import 'package:http/http.dart' as http;

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
    try {
      final response = await http
          .get(Uri.parse('http://$ip/json/eff'))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e.toString()).toList();
      }
    } catch (e) {
      return null;
    }
    return null;
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
    try {
      final response = await http
          .get(Uri.parse('http://$ip/json/pal'))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e.toString()).toList();
      }
    } catch (e) {
      return null;
    }
    return null;
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

  static Future<Map<String, dynamic>?> getPresets(String ip) async {
    try {
      final response = await http
          .get(Uri.parse('http://$ip/presets.json'))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return null;
    }
    return null;
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
          .timeout(const Duration(seconds: 2));
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
}
