import 'package:flutter/material.dart';
import '../../../constant/fonts.dart';
import '../../../constant/measures.dart';
import '../glass_card.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Function()? onTap;

  const ProfileCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: GlassCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            if (icon != null) const SizedBox(width: Measures.hMarginMed),
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
    ),
  );
}
