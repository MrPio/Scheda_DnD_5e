import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/manager/storage_manager.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';

import '../../constant/fonts.dart';
import '../../constant/measures.dart';
import '../../constant/palette.dart';
import '../../model/user.dart';
import 'clickable.dart';

class ProfilePicture extends StatefulWidget {
  final User? user;
  final bool isEditable;

  /// Displays the user's profile picture .
  ///
  /// If [user] is null, a shimmer effect will be displayed instead of the picture.
  /// Else, if [isEditable], an edit button will be displayed to upload a new profile picture from the gallery.
  const ProfilePicture({this.user, this.isEditable = false, super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  String? url;

  @override
  void initState() {
    Future.delayed(Durations.short3, () async {
      url = await StorageManager()
          .fetchUrl(Collection.profilePicture, widget.user?.picture ?? 'anonymous.png');
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: url != null
          ? CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: url!,
            )
          : GlassCard(isShimmer: true),
    );
    return Clickable(
      active: widget.isEditable && widget.user != null,
      bottomSheetArgs: BottomSheetArgs(
          header: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: (url != null && widget.user != null && widget.user?.picture == null)
                              ? Color(widget.user!.pictureColor)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: avatar,
                      ),
                      const SizedBox(width: Measures.hMarginBig),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.user!.username, style: Fonts.bold()),
                          Text(widget.user!.email, style: Fonts.light()),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(width: Measures.hMarginBig * 2),
              // Flexible(child: HpBar(character.hp, character.maxHp,showText: false,))
            ],
          ),
          items: [
            BottomSheetItem('png/gallery', 'Scegli dalla galleria', changePicture),
            BottomSheetItem('png/delete_2', 'Rimuovi la foto', removePicture),
          ]),
      child: Stack(
        children: [
          Container(
            width: 144,
            height: 144,
            decoration: BoxDecoration(
              color: (url != null && widget.user != null && widget.user?.picture == null)
                  ? Color(widget.user!.pictureColor)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: avatar,
          ),
          if (widget.isEditable)
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(999), color: Palette.background),
                  child: 'png/edit'
                      .toIcon(height: 20, margin: const EdgeInsets.all(12)),
                )),
        ],
      ),
    );
  }

  changePicture() async {
    final newPicture = await IOManager().pickPicture();

    // Upload the picture file and save it inside the user object
    if (newPicture != null) {
      try {
        final filename = await StorageManager().uploadFile(Collection.profilePicture, newPicture);
        if (filename != null) {
          widget.user!.picture = filename;
          url = await StorageManager().fetchUrl(Collection.profilePicture, filename);
          DataManager().save(widget.user!);
          setState(() {});
        }
      } on FileSizeException catch (e) {
        context.snackbar(e.message, backgroundColor: Palette.primaryRed);
      }
    }
  }

  removePicture() async {
    if (widget.user!.picture != null) {
      widget.user!.picture = null;
      url = await StorageManager().fetchUrl(Collection.profilePicture, 'anonymous.png');
      DataManager().save(widget.user!);
      setState(() {});
    }
  }
}
