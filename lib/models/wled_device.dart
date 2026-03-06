class WledDevice {
  String name;
  String ip;
  bool isOnline;
  bool isOn;
  int brightness;
  bool isLive;
  String liveIp;

  WledDevice({
    required this.name,
    required this.ip,
    this.isOnline = false,
    this.isOn = false,
    this.brightness = 128,
    this.isLive = false,
    this.liveIp = "",
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
