class WledDevice {
  String name;
  String ip;
  bool isOnline;
  bool isOn;
  int brightness;

  WledDevice({
    required this.name,
    required this.ip,
    this.isOnline = false,
    this.isOn = false,
    this.brightness = 128,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ip': ip,
    };
  }

  factory WledDevice.fromJson(Map<String, dynamic> json) {
    return WledDevice(
      name: json['name'],
      ip: json['ip'],
    );
  }
}
