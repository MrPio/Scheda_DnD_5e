import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import '../../../constant/fonts.dart';
import '../../../constant/measures.dart';
import '../glass_card.dart';

class ButtonCard extends StatelessWidget {
  final String title,icon;
  final String? description;
  final Function()? onTap;

  const ButtonCard({
    required this.title,
    required this.icon,
    this.description,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GlassCard(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          icon.toIcon(height:24, margin: const EdgeInsets.only(right:Measures.hMarginBig)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Fonts.bold()),
                if (description != null)
                  Text(description!, style: Fonts.light()),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
