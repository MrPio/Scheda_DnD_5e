import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class GlassCheckbox extends StatelessWidget {
  final bool? value;
  final Function()? onChanged;
  final Color color;

  const GlassCheckbox({super.key,this.value, this.onChanged, this.color=Palette.onBackground});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        side: MaterialStateBorderSide.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? const BorderSide(color: Colors.transparent)
              : const BorderSide(color: Palette.card2, width: 1),
        ),
        activeColor: color,
        checkColor: Palette.onBackground,
        value: value,
        onChanged: (_) => onChanged?.call());
  }
}
