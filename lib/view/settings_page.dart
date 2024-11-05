import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/iterable_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/dummy_manager.dart';
import 'package:scheda_dnd_5e/model/setting.dart';
import 'package:scheda_dnd_5e/view/partial/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:scheda_dnd_5e/view/partial/glass_checkbox.dart';

import '../constant/fonts.dart';
import 'partial/gradient_background.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final settings = DummyManager().getSettings();
  final List<SettingMenu> activeSettings = [];
  final iconWidth = 48.0;

  Map<String, Object?> settingsValues = {};

  @override
  void initState() {
    final allSettings = settings.map((e) => e.settings).flatten;
    Future.delayed(Duration.zero, () async {
      settingsValues = Map.fromIterables(allSettings.map((e) => e.id),
          await Future.wait(allSettings.map((e) async => (await e.value) ?? e.defaultValue)));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.background),
          // Header + Body
          SafeArea(
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    flexibleSpace: // Header
                        Padding(
                      padding: const EdgeInsets.only(top: Measures.vMarginMed),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Chevron(inAppBar: true),
                          'info'.toIcon(
                              onTap: () {},
                              margin: const EdgeInsets.only(right: Measures.hMarginMed),
                              padding: Measures.chevronPadding)
                        ],
                      ),
                    ),
                    leading: Container(),
                    collapsedHeight: 80,
                    expandedHeight: 80,
                    backgroundColor: Colors.transparent,
                    floating: true,
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: Measures.vMarginBig),
                    // Page Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Impostazioni', style: Fonts.black())),
                    ),
                    const SizedBox(height: Measures.vMarginSmall),
                    ...settings.map((e) => settingMenu(e))
                  ],
                ),
              ),
            ),
          ),
          // Bottom vignette
          const BottomVignette(height: 0, spread: 50),
        ],
      ),
    );
  }

  Widget settingMenu(SettingMenu settingMenu) => Column(
        children: [
          Clickable(
            onTap: () => setState(() {
              activeSettings.contains(settingMenu)
                  ? activeSettings.remove(settingMenu)
                  : activeSettings.add(settingMenu);
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Measures.hPadding, vertical: Measures.vMarginThin),
              child: Row(
                children: [
                  SizedBox(
                    width: iconWidth,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: settingMenu.icon
                            .toIcon(margin: const EdgeInsets.only(left: Measures.hMarginSmall))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(settingMenu.title, style: Fonts.bold()),
                      if (settingMenu.subtitle != null) Text(settingMenu.subtitle!, style: Fonts.light()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (activeSettings.contains(settingMenu))
            Container(
              color: Palette.card,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Measures.hPadding, right: Measures.hPadding, top: Measures.vMarginSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: settingMenu.settings
                      .map((setting) => Clickable(
                            onTap: () => setState(() {
                              settingsValues[setting.id] = !(settingsValues[setting.id] as bool);
                            }),
                            child: Padding(
                              padding: EdgeInsets.only(left: iconWidth, bottom: Measures.vMarginSmall),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(setting.title, style: Fonts.bold()),
                                      if (setting.subtitle != null)
                                        Text(setting.subtitle!, style: Fonts.light()),
                                    ],
                                  ),
                                  GlassCheckbox(
                                      value: settingsValues[setting.id] as bool,
                                      color: Palette.primaryBlue)
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
        ],
      );
}
