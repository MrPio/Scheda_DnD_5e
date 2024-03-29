import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class GlassCard extends StatefulWidget {
  final double width, height;
  final Widget? child;
  final bool clickable;
  final void Function()? onTap;

  const GlassCard(
      {super.key,
      this.width=double.infinity,
      this.height=double.infinity,
      this.child,
      this.clickable = true, this.onTap});

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  final double borderRadiusUp = 16, borderRadiusDown = 16;
  final double marginUp = 0, marginDown = 3;
  final double opacityUp = 1, opacityDown = 0.75;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => widget.clickable ? setState(() => _down = true) : null,
      onTapUp: (_) => widget.clickable ? setState(() => _down = false) : null,
      onTapCancel: () =>
          widget.clickable ? setState(() => _down = false) : null,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: EdgeInsets.all(_down ? marginDown : marginUp),
          decoration: BoxDecoration(
              color: Palette.card.withOpacity(
                  Palette.card.opacity * (_down ? opacityDown : opacityUp)),
              borderRadius: BorderRadius.circular(
                  _down ? borderRadiusDown : borderRadiusUp)),
          child: Opacity(
            opacity: _down ? opacityDown : opacityUp,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
