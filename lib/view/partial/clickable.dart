import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';

class BottomSheetArgs {
  final Widget? header;
  final List<BottomSheetItem>? items;

  BottomSheetArgs({this.header, this.items});
}

class Clickable extends StatefulWidget {
  final bool active;
  final Function()? onTap;
  final Function(bool)? onDownChange;
  final Widget? child;
  final BottomSheetArgs? bottomSheetArgs;

  const Clickable(
      {super.key, this.child, this.onTap, this.onDownChange, this.bottomSheetArgs, this.active = true});

  @override
  State<Clickable> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<Clickable> {
  get _scale => _down ? 0.95 : 1.0;

  get _opacity => _down ? 0.55 : 1.0;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.active
          ? () {
              if (widget.onTap != null) {
                widget.onTap!();
              } else if (widget.bottomSheetArgs != null) {
                context.bottomSheet(widget.bottomSheetArgs!);
              }
            }
          : null,
      onTapDown: (_) => setDown(true),
      onTapUp: (_) => setDown(false),
      onLongPress: () {
        HapticFeedback.mediumImpact();
        if (widget.active && widget.bottomSheetArgs != null) {
          context.bottomSheet(widget.bottomSheetArgs!);
        }
      },
      onTapCancel: () => setDown(false),
      child: AnimatedScale(
        scale: widget.active ? _scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Opacity(opacity: _opacity, child: widget.child),
      ),
    );
  }

  setDown(bool isDown) {
    setState(() => _down = isDown);
    widget.onDownChange?.call(_down);
  }
}
