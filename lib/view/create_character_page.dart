import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';

import '../enum/fonts.dart';
import '../enum/measures.dart';
import '../enum/palette.dart';
import '../mixin/validable.dart';
import '../model/character.dart' hide Alignment;

class CreateCharacterPage extends StatefulWidget {
  const CreateCharacterPage({super.key});

  @override
  State<CreateCharacterPage> createState() => _CreateCharacterPageState();
}

class _CreateCharacterPageState extends State<CreateCharacterPage>
    with Validable {
  Character character = Character();
  late final PageController _pageController;
  late final TextEditingController _nameController;

  List<Widget>? _screens;

  final _hasBottomButton = [true];
  var _index = 0;

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _index = _pageController.page?.toInt() ?? 0;
        });
      });
    _nameController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screens ??= [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Measures.vMarginBig),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: 'chevron_left'.toIcon(height: 24),
            ),
            const SizedBox(height: Measures.vMarginSmall),
            // Body
            Expanded(
              child: Column(children: [
                const SizedBox(height: Measures.vMarginMed),
                // Page Title
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Qual è il suo nome?', style: Fonts.black())),
                const SizedBox(height: Measures.vMarginMed),
                // Search TextField
                GlassTextField(
                  iconPath: 'search_alt',
                  hintText: 'Il nome del personaggio',
                  textController: _nameController,
                  autofocus: true,
                  onSubmitted: (text) {
                    if (validate(() => character.name = text)) {
                      next();
                    }
                  },
                  textInputAction: TextInputAction.next,
                ),
              ]),
            ),
          ],
        ),
      ),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundBlue),
          // Page content
          PageView(
            controller: _pageController,
            children: _screens!,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Measures.hPadding, vertical: Measures.vMarginMed),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Continue button
                  if (_hasBottomButton[_index])
                    GlassButton(
                      'PROSEGUI',
                      color: Palette.primaryBlue,
                      onTap: () {
                        if (validate(
                            () => character.name = _nameController.text)) {
                          next();
                        }
                      },
                    ),
                  const SizedBox(height: Measures.vMarginMed),
                  // Bottom Progress
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                          (_screens?.length ?? 0 )+5,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3.2),
                            child: Container(
                                height: _index==index?13:11,
                                width: _index==index?13:11,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: _index==index?Palette.onBackground:Palette.card)),
                          )))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  next() {
    _pageController.nextPage(
        duration: Durations.medium1, curve: Curves.easeOutCubic);
  }
}
