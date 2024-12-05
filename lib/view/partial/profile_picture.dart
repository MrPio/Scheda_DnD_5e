import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/storage_manager.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';

import '../../constant/palette.dart';
import '../../model/user.dart';
import 'clickable.dart';

class ProfilePicture extends StatefulWidget {
  final User? user;

  const ProfilePicture({this.user, super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  String? url;

  @override
  void initState() {
    Future.delayed(
        Durations.short3,
        () async =>
            setState(() =>
            url = StorageManager().fetchUrl(StorageCollection.profilePicture, 'anonymous.png')));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 144,
          height: 144,
          decoration: BoxDecoration(
            color: (url != null && widget.user!=null)?Color(widget.user!.pictureColor):Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: url != null
                ? CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: url!,
                  )
                : GlassCard(isShimmer: true),
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Clickable(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(999),color: Palette.background),
                child: 'png/edit'.toIcon(height: 20, onTap: (){},padding: const EdgeInsets.all(12)),
              ),
            )),
      ],
    );
  }
}
