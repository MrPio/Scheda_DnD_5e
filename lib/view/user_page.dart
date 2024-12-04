import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/view/partial/card/profile_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';
import '../manager/account_manager.dart';
import '../model/user.dart';

class ProfileArgs {
  final String? title;
  ProfileArgs({this.title});
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ValueNotifier<ProfileArgs?> args = ValueNotifier(null);
  final double avatarRadius = 60;

  // Get the logged-in user from AccountManager
  Future<User?> getLoggedInUser() async {
    return AccountManager().user; // Directly accessing the user from AccountManager
  }

  @override
  Widget build(BuildContext context) {
    args.value ??= ModalRoute.of(context)!.settings.arguments as ProfileArgs?;

    return Scaffold(
      backgroundColor: Palette.background,
      body: Stack(
        children: [
          const GradientBackground(topColor: Palette.backgroundPurple),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding, vertical: Measures.vMarginBig * 1.5),
            child: FutureBuilder<User?>(
              future: getLoggedInUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const Center(child: Text('User not found.'));
                }

                final user = snapshot.data!;
                final String userName = user.nickname;
                final String userEmail = user.email;

                final List<Widget> profileSections = [
                  Padding(
                    padding: const EdgeInsets.only(bottom: Measures.vMarginSmall),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Account",
                        style: Fonts.bold(size: 16),
                      ),
                    ),
                  ),
                  ProfileCard(
                    title: "Lista Amici",
                    description: "Gestisci i tuoi amici",
                    icon: Icons.group,
                    onTap: () {
                      Navigator.pushNamed(context, '/friends');
                    },
                  ),
                  ProfileCard(
                    title: "Cambia Password",
                    description: "Aggiorna la tua password",
                    icon: Icons.lock,
                    onTap: () {
                      Navigator.pushNamed(context, '/change-password');
                    },
                  ),
                  ProfileCard(
                    title: "Cambia Username",
                    description: "Modifica il tuo nome utente",
                    icon: Icons.person,
                    onTap: () {
                      Navigator.pushNamed(context, '/change-username');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: Measures.vMarginSmall, top: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Impostazioni",
                        style: Fonts.bold(size: 16),
                      ),
                    ),
                  ),
                  ProfileCard(
                    title: "Impostazioni",
                    description: "Personalizza le tue preferenze",
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ];

                return Column(
                  children: [
                    Stack(
                      children: [
                        if (args.value != null)
                          Align(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: Measures.vMarginThin,
                                  bottom: Measures.vMarginThin,
                                  left: Measures.hPadding * 3,
                                  right: Measures.hPadding),
                              child: Text(
                                  args.value?.title ?? 'Gestisci il tuo profilo',
                                  style: Fonts.black(size: 18),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        else
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Gestisci il tuo profilo', style: Fonts.black()),
                          ),
                        if (args.value != null)
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Chevron(inAppBar: true),
                          ),
                      ],
                    ),
                    const SizedBox(height: Measures.vMarginBig),
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: avatarRadius,
                                backgroundImage: const AssetImage(
                                  'assets/images/icons/png/icons8-profile-picture-48.png',
                                ),
                                backgroundColor: Palette.background,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle the photo edit action here
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Palette.background,
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Measures.vMarginSmall),
                          Text(
                            userName,
                            style: Fonts.black(size: 20),
                          ),
                          Text(
                            userEmail,
                            style: Fonts.light(size: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Measures.vMarginBig),
                    ...profileSections,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
