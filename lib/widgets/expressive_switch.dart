import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class ExpressiveSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Icon? activeIcon;
  final Icon? inactiveIcon;

  const ExpressiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeIcon,
    this.inactiveIcon,
  });

  @override
  State<ExpressiveSwitch> createState() => _ExpressiveSwitchState();
}

class _ExpressiveSwitchState extends State<ExpressiveSwitch> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (Provider.of<ThemeService>(context, listen: false).enableHaptics) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    if (Provider.of<ThemeService>(context, listen: false).enableHaptics) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _isPressed = false;
    });
    widget.onChanged(!widget.value);
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final trackColor = widget.value
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant.withOpacity(0.2);

    final thumbColor =
        widget.value ? theme.colorScheme.onPrimary : theme.colorScheme.outline;

    final iconColor =
        widget.value ? theme.colorScheme.primary : theme.colorScheme.surface;

    // Dimensions
    const double trackWidth = 52.0;
    const double trackHeight = 32.0;
    const double thumbSize = 24.0;
    final double thumbStretchWidth = _isPressed ? 32.0 : thumbSize;

    // Position calculations
    final double padding = (trackHeight - thumbSize) / 2;

    // When pressed, the thumb stretches, we need to adjust the position so it stretches "inward" or naturally
    final double leftPosition =
        widget.value ? trackWidth - thumbStretchWidth - padding : padding;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCirc,
        width: trackWidth,
        height: trackHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(trackHeight / 2),
          color: trackColor,
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              left: leftPosition,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCirc,
                width: thumbStretchWidth,
                height: thumbSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(thumbSize / 2),
                  color: thumbColor,
                ),
                child: Center(
                  child: widget.value && widget.activeIcon != null
                      ? Icon(
                          widget.activeIcon!.icon,
                          size: 16,
                          color: iconColor,
                        )
                      : !widget.value && widget.inactiveIcon != null
                          ? Icon(
                              widget.inactiveIcon!.icon,
                              size: 16,
                              color: iconColor,
                            )
                          : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
