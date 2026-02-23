import 'package:flutter/material.dart';

class ExpressiveSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 16.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    if (!thumbCenter.dx.isFinite) return;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    if (!trackRect.isFinite) return;

    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.blue
      ..isAntiAlias = true;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.grey
      ..isAntiAlias = true;

    final double trackHeight = trackRect.height;
    final double radius = trackHeight / 2;
    const double gap = 6.0;

    // Active track (from start to thumbCenter - gap)
    final double activeRight =
        (thumbCenter.dx - gap).clamp(trackRect.left, trackRect.right);
    if (activeRight > trackRect.left) {
      final Rect activeRect = Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        activeRight,
        trackRect.bottom,
      );
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(activeRect, Radius.circular(radius)),
        activePaint,
      );
    }

    // Inactive track (from thumbCenter + gap to right)
    final double inactiveLeft =
        (thumbCenter.dx + gap).clamp(trackRect.left, trackRect.right);
    if (inactiveLeft < trackRect.right) {
      final Rect inactiveRect = Rect.fromLTRB(
        inactiveLeft,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
      );
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(inactiveRect, Radius.circular(radius)),
        inactivePaint,
      );
    }

    // Dot at the end of inactive track
    final double dotRadius = 2.0;
    final Offset dotCenter =
        Offset(trackRect.right - radius, trackRect.center.dy);
    if (dotCenter.dx > inactiveLeft) {
      context.canvas.drawCircle(
        dotCenter,
        dotRadius,
        activePaint, // The dot is usually the same color as the active track/thumb
      );
    }
  }
}

class ExpressiveSliderThumbShape extends SliderComponentShape {
  final double width;
  final double height;
  final double borderRadius;

  const ExpressiveSliderThumbShape({
    this.width = 4.0,
    this.height = 40.0,
    this.borderRadius = 2.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      paint,
    );
  }
}
