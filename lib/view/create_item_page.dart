import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/iterable_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/mixin/loadable.dart';
import 'package:scheda_dnd_5e/model/loot.dart';
import 'package:scheda_dnd_5e/view/partial/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/loading_view.dart';

import '../constant/dictionary.dart';
import '../constant/fonts.dart';
import '../constant/measures.dart';
import '../constant/palette.dart';
import '../interface/json_serializable.dart';
import '../mixin/validable.dart';

class CreateItemArgs {
  final Type type;

  CreateItemArgs(this.type);
}

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> with Validable, Loadable {
  CreateItemArgs? args;
  List<InventoryItem?> items = [null, null, null];
  late final PageController _pageController;
  final _nameController = TextEditingController();

  InventoryItem get item => items[_index]!;

  Function get constructor => JSONSerializable.modelFactories[args!.type]!;

  List<Widget>? _screens;
  List<Function()?>? _bottomButtons;

  int _index = 0;

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _index = _pageController.page?.toInt() ?? 0;
        });
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
    args = (ModalRoute.of(context)!.settings.arguments) as CreateItemArgs?;
    items[0] ??= constructor(<String,dynamic>{});
    _screens = [
      // Choose name
      Column(children: [
        // Title
        Row(
          children: [
            InventoryItem.icons[args!.type]!.toIcon(),
            const SizedBox(width: Measures.hMarginMed),
            Align(alignment: Alignment.centerLeft, child: Text('Assegna un nome', style: Fonts.black())),
          ],
        ),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Come vuoi chiamare il tuo nuovo oggetto?', style: Fonts.light()),
        ),
        const SizedBox(height: Measures.vMarginMed),
        // Search TextField
        GlassTextField(
          iconPath: 'png/edit',
          hintText: 'Un nome  di ${InventoryItem.namesSingulars[args!.type]!.toLowerCase()}',
          secondaryIconPath: 'png/random',
          onSecondaryIconTap: () {
            _nameController.text = '${Dictionary.itemNames[args!.type]!.random} ${Dictionary.itemAdjectives.random}';
            setState(() {});
          },
          textController: _nameController,
          autofocus: true,
          onSubmitted: (text) {
            if (validate(() =>item.title = text)) {
              next();
            }
          },
          textInputAction: TextInputAction.next,
        ),
      ]),
    ];
    _bottomButtons ??= [
      () {
        if (validate(() => item.title = _nameController.text)) {
          next();
        }
      }
    ];
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: _index != 5,
        body: Stack(
          children: [
            // Background
            const GradientBackground(topColor: Palette.backgroundBlue),
            // Page content
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _screens!
                  .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                      child: SingleChildScrollView(
                        padding:
                            const EdgeInsets.only(top: Measures.vMarginBig * 2 + Measures.vMarginSmall),
                        child: e,
                      )))
                  .toList(),
            ),
            // Chevron
            Chevron(onTap: previous),
            // Bottom vignette
            const BottomVignette(height: 0, spread: 80),
            // Bottom points
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Measures.hPadding, vertical: Measures.vMarginMed),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Continue button
                    if (_bottomButtons?[_index] != null)
                      GlassButton(
                        'PROSEGUI',
                        color: Palette.primaryBlue,
                        onTap: _bottomButtons?[_index],
                      ),
                    const SizedBox(height: Measures.vMarginMed),
                    // Bottom Progress
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                            _screens?.length ?? 0,
                            (index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3.2),
                                  child: AnimatedContainer(
                                    height: _index == index ? 13 : 11,
                                    width: _index == index ? 13 : 11,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(999),
                                        color: _index == index ? Palette.onBackground : Palette.card),
                                    duration: Durations.medium3,
                                  ),
                                )))
                  ],
                ),
              ),
            ),
            // LoadingView
            LoadingView(visible: isLoading)
          ],
        ),
      ),
    );
  }

  next({int step = 1}) {
    if (_index + step >= (_screens?.length ?? 0)) {
      // The item creation is completed, save the item
      withLoading(() async {
        // item.uid = await DataManager().save(item, SaveMode.post);
        // AccountManager().user.itemsUIDs.add(item.uid!);
        // await DataManager().save(AccountManager().user);
        // Navigator.of(context).pop();
      });
    } else {
      // Cloning the previous state
      for (var i = 1; i <= step; i++) {
        items[_index + i] = constructor(item.toJSON());
      }
      FocusManager.instance.primaryFocus?.unfocus();
      _pageController.animateToPage(_index + step,
          duration: Durations.medium1, curve: Curves.easeOutCubic);
    }
  }

  previous() {
    // Reset the current screen state
    int step = 1; // Skipp-able screens
    if (_index > 0) {
      items[_index - step] = _index > 1 ? constructor(items[_index - step - 1]!.toJSON()) : constructor();
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (_index == 0) {
      Navigator.of(context).pop();
    } else {
      _pageController.animateToPage(_index - step,
          duration: Durations.medium1, curve: Curves.easeOutCubic);
    }
  }
}
