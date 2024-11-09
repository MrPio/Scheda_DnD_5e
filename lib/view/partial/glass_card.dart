import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:shimmer/shimmer.dart';

class GlassCard extends StatefulWidget {
  final double? width, height, shimmerHeight;
  final Widget? child;
  final bool clickable, isShimmer, isLight, isFlat;
  final void Function()? onTap;
  final BottomSheetArgs? bottomSheetArgs;

  const GlassCard(
      {super.key,
      this.width,
      this.height,
      this.child,
      this.clickable = true,
      this.isShimmer = false,
      this.shimmerHeight,
      this.onTap,
      this.bottomSheetArgs,
      this.isLight = false,
      this.isFlat = false});

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  final double borderRadiusUp = 14;

  get _borderRadius => widget.isFlat
      ? 0.0
      : _down
          ? 10.0
          : 14.0;

  get _opacity => _down ? 0.55 : 1.0;

  get _backgroundColor=>Palette.card
      .withOpacity(Palette.card.opacity * _opacity * (widget.isLight ? 0.35 : 1));

  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (!widget.isFlat || widget.isShimmer)?Colors.transparent: _backgroundColor,
      child: Clickable(
        active: widget.clickable && !widget.isShimmer,
        onTap: widget.onTap,
        bottomSheetArgs: widget.bottomSheetArgs,
        onDownChange: (value) => setState(() => _down = value),
        child: widget.isShimmer
            ? Padding(
                padding: const EdgeInsets.only(bottom: Measures.vMarginMoreThin),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  child: Shimmer(
                    gradient: LinearGradient(
                      begin: const Alignment(1, 1),
                      end: const Alignment(-1, -1),
                      colors: [
                        Palette.card,
                        Palette.card.withOpacity(Palette.card.opacity * 2),
                        Palette.card
                      ],
                      stops: const [0.43, 0.5, 0.57],
                    ),
                    child: Container(
                      width: double.infinity,
                      height: widget.shimmerHeight,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: widget.width,
                height: widget.height,
                child: AnimatedContainer(
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 120),
                  decoration: BoxDecoration(
                      color: widget.isFlat?Colors.transparent: _backgroundColor,
                      borderRadius: BorderRadius.circular(_borderRadius)),
                  child: widget.child,
                ),
              ),
      ),
    );
  }
}
