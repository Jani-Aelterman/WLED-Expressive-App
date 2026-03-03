class WledSegment {
  final int id;
  final int start;
  final int stop;
  final int length;
  final int group;
  final int spacing;
  final int offset;
  final bool isOn;
  final int brightness;
  final String name;

  WledSegment({
    required this.id,
    required this.start,
    required this.stop,
    required this.length,
    required this.group,
    required this.spacing,
    required this.offset,
    required this.isOn,
    required this.brightness,
    required this.name,
  });

  factory WledSegment.fromJson(Map<String, dynamic> json) {
    return WledSegment(
      id: json['id'] as int? ?? 0,
      start: json['start'] as int? ?? 0,
      stop: json['stop'] as int? ?? 0,
      length: json['len'] as int? ?? 0,
      group: json['grp'] as int? ?? 1,
      spacing: json['spc'] as int? ?? 0,
      offset: json['of'] as int? ?? 0,
      isOn: json['on'] as bool? ?? true,
      brightness: json['bri'] as int? ?? 255,
      name: json['n'] as String? ?? 'Segment',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': start,
      'stop': stop,
      'len': length,
      'grp': group,
      'spc': spacing,
      'of': offset,
      'on': isOn,
      'bri': brightness,
      'n': name,
    };
  }
}
