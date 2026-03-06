import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../models/wled_device.dart';
import '../models/wled_segment.dart';
import '../services/wled_api_service.dart';
import '../widgets/expressive_switch.dart';

class SegmentsScreen extends StatefulWidget {
  final WledDevice device;

  const SegmentsScreen({super.key, required this.device});

  @override
  State<SegmentsScreen> createState() => _SegmentsScreenState();
}

class _SegmentsScreenState extends State<SegmentsScreen> {
  List<WledSegment> _segments = [];
  bool _isLoading = true;
  int _ledCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchSegments();
  }

  Future<void> _fetchSegments() async {
    setState(() {
      _isLoading = true;
    });

    final info = await WledApiService.getDeviceInfo(widget.device.ip);
    if (info != null && info['leds'] != null) {
      _ledCount = info['leds']['count'] ?? 0;
    }

    final state = await WledApiService.getDeviceState(widget.device.ip);

    if (state != null && state['seg'] != null) {
      final List<dynamic> segsJson = state['seg'];
      _segments = segsJson
          .map((json) {
            // WLED sometimes returns null segments if they were deleted before.
            if (json == null) return null;
            return WledSegment.fromJson(json);
          })
          .whereType<WledSegment>()
          .toList();
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateSegmentPower(WledSegment segment, bool isOn) async {
    final success = await WledApiService.updateSegment(
      widget.device.ip,
      segment.id,
      {'on': isOn},
    );
    if (success) {
      _fetchSegments();
    }
  }

  Future<void> _updateSegmentBrightness(
      WledSegment segment, int brightness) async {
    final success = await WledApiService.updateSegment(
      widget.device.ip,
      segment.id,
      {'bri': brightness},
    );
    if (success) {
      _fetchSegments();
    }
  }

  Future<void> _updateSegmentBounds(
      WledSegment segment, int start, int stop) async {
    final success = await WledApiService.updateSegment(
      widget.device.ip,
      segment.id,
      {'start': start, 'stop': stop},
    );
    if (success) {
      _fetchSegments();
    }
  }

  Future<void> _deleteSegment(WledSegment segment) async {
    final success =
        await WledApiService.deleteSegment(widget.device.ip, segment.id);
    if (success) {
      _fetchSegments();
    }
  }

  Future<void> _addSegment() async {
    // Basic logic for a new segment: usually starts where the last one ended
    int start = 0;
    if (_segments.isNotEmpty) {
      start = _segments.last.stop;
    }
    int stop = _ledCount > start ? _ledCount : start + 10;

    // In actual WLED, pushing a new segment is typically done by giving the next index.
    // If the API allows dynamic push, we append an object with start and stop.
    // Or we simply use updateSegment with the next ID.
    int nextId = _segments.isNotEmpty ? _segments.last.id + 1 : 0;
    bool success = await WledApiService.updateSegment(
      widget.device.ip,
      nextId,
      {'start': start, 'stop': stop},
    );

    if (success) {
      _fetchSegments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSegments,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _segments.isEmpty
              ? const Center(child: Text("No segments found"))
              : RefreshIndicator(
                  onRefresh: _fetchSegments,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _segments.length,
                    itemBuilder: (context, index) {
                      final segment = _segments[index];
                      return _buildSegmentCard(segment);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSegment,
        tooltip: 'Add Segment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSegmentCard(WledSegment segment) {
    // Generate text controllers for the inputs
    final TextEditingController startController =
        TextEditingController(text: segment.start.toString());
    final TextEditingController stopController =
        TextEditingController(text: segment.stop.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: ID, Name, Power Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Segment ${segment.id}: ${segment.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ExpressiveSwitch(
                  value: segment.isOn,
                  onChanged: (val) => _updateSegmentPower(segment, val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Brightness Slider
            Row(
              children: [
                const Icon(Icons.brightness_high),
                Expanded(
                  child: Slider(
                    value: segment.brightness.toDouble(),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    label: '${((segment.brightness / 255) * 100).round()}%',
                    onChanged: (val) {
                      if (Provider.of<ThemeService>(context, listen: false)
                          .enableHaptics) {
                        HapticFeedback.selectionClick();
                      }
                      setState(() {
                        // Optimistic update for UI feel
                        _segments[_segments.indexOf(segment)] = WledSegment(
                            id: segment.id,
                            start: segment.start,
                            stop: segment.stop,
                            length: segment.length,
                            group: segment.group,
                            spacing: segment.spacing,
                            offset: segment.offset,
                            isOn: segment.isOn,
                            brightness: val.round(),
                            name: segment.name);
                      });
                    },
                    onChangeEnd: (val) {
                      if (Provider.of<ThemeService>(context, listen: false)
                          .enableHaptics) {
                        HapticFeedback.lightImpact();
                      }
                      _updateSegmentBrightness(segment, val.round());
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Start and Stop bounds
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startController,
                    decoration: const InputDecoration(
                      labelText: 'Start LED',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (val) {
                      int? parsed = int.tryParse(val);
                      if (parsed != null) {
                        _updateSegmentBounds(segment, parsed, segment.stop);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: stopController,
                    decoration: const InputDecoration(
                      labelText: 'Stop LED',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (val) {
                      int? parsed = int.tryParse(val);
                      if (parsed != null) {
                        _updateSegmentBounds(segment, segment.start, parsed);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Controls Actions: Delete and Save
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (segment.id !=
                    0) // Cannot realistically delete segment 0 for reliability
                  TextButton.icon(
                    onPressed: () => _deleteSegment(segment),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    int? start = int.tryParse(startController.text);
                    int? stop = int.tryParse(stopController.text);
                    if (start != null && stop != null) {
                      _updateSegmentBounds(segment, start, stop);
                    }
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Bounds'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
