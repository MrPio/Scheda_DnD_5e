import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class GlassCard extends StatefulWidget {
  final double? width, height;
  final Widget? child;
  final bool clickable;
  final void Function()? onTap;

  const GlassCard(
      {super.key,
      this.width,
      this.height,
      this.child,
      this.clickable = true,
      this.onTap});

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  final double borderRadiusUp = 16, borderRadiusDown = 10;

  get _borderRadius => _down ? 10.0 : 16.0;
  get _scale => _down ? 0.95 : 1.0;
  get _opacity => _down ? 0.55 : 1.0;

  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => widget.clickable ? setState(() => _down = true) : null,
      onTapUp: (_) => widget.clickable ? setState(() => _down = false) : null,
      onTapCancel: () =>
          widget.clickable ? setState(() => _down = false) : null,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Opacity(
          opacity: _opacity,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: AnimatedContainer(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                  color:
                      Palette.card.withOpacity(Palette.card.opacity * _opacity),
                  borderRadius: BorderRadius.circular(_borderRadius)),
              child: widget.child,
            ),
          ),
                ),
        ),
    );
  }
}
