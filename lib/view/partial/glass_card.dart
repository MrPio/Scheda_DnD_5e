import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/fonts.dart';
import '../../constant/measures.dart';

class GlassCard extends StatefulWidget {
  final double? width, height, shimmerHeight;
  final Widget? child;
  final bool clickable, isShimmer, isLight;
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
      this.isLight = false});

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  final double borderRadiusUp = 14;

  get _borderRadius => _down ? 12.0 : 16.0;

  get _opacity => _down ? 0.55 : 1.0;

  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      active: widget.clickable,
      onTap: widget.onTap,
      bottomSheetArgs: widget.bottomSheetArgs,
      onDownChange: (value) => setState(() => _down = value),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedContainer(
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
              color:
                  Palette.card.withOpacity(Palette.card.opacity * _opacity * (widget.isLight ? 0.35 : 1)),
              borderRadius: BorderRadius.circular(_borderRadius)),
          child: widget.child,
        ),
      ),
    );
  }
}
