import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'package:scheda_dnd_5e/view/partial/card/button_card.dart';
import 'package:scheda_dnd_5e/view/partial/page_header.dart';
import 'package:scheda_dnd_5e/view/partial/profile_picture.dart';
import 'package:scheda_dnd_5e/view/user_page.dart';

class UserScreen extends StatefulWidget {
  final UserArgs? args;

  const UserScreen({this.args, super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserArgs? get args => widget.args;
  final double avatarRadius = 999;

  /// The user whose profile will be shown.
  /// If no user is given in args, the current user is used
  User? user;

  @override
  void initState() {
    user = args?.user ?? AccountManager().user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
        child: Column(
          children: [
            // Page Title
            PageHeader(title: args?.title ?? 'Gestisci il tuo profilo', isPage: args != null),
            Column(
              children: [
                ProfilePicture(user: user),
                const SizedBox(height: Measures.vMarginThin),
                Text(
                  user!.username,
                  style: Fonts.black(size: 20),
                ),
                Text(
                  user!.email,
                  style: Fonts.light(size: 16),
                ),
              ],
            ),
            const SizedBox(height: Measures.vMarginMed+Measures.vMarginSmall),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text("Account", style: Fonts.bold(size: 16)),
            // ),
            // const SizedBox(height: Measures.vMarginThin),
            ButtonCard(
              title: "Lista Amici",
              icon: 'group',
              description: "Gestisci la tua community, consulta il profilo dei tuoi amici",
              onTap: () {
                Navigator.pushNamed(context, '/friends');
              },
            ),
            const SizedBox(height: Measures.vMarginThin),
            ButtonCard(
              title: "Cambia Password",
              description: 'Modifica le credenziali di accesso al tuo account',
              icon: 'password',
              onTap: () {
                Navigator.pushNamed(context, '/change-password');
              },
            ),
            const SizedBox(height: Measures.vMarginThin),
            ButtonCard(
              title: "Cambia username",
              description: 'Modifica il tuo nome visibile pubblicamente',
              icon: 'person',
              onTap: () {
                Navigator.pushNamed(context, '/change-username');
              },
            ),
            // const SizedBox(height: Measures.vMarginSmall),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text("Impostazioni", style: Fonts.bold(size: 16)),
            // ),
            const SizedBox(height: Measures.vMarginThin),
            ButtonCard(
              title: "Impostazioni",
              icon: 'png/settings',
              description: "Personalizza il comportamento dell'applicazione",
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: Measures.vMarginBig*3),
          ],
        ));
  }
}
