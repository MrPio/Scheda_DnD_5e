import 'dart:core';

import '../manager/io_manager.dart';

class SettingMenu {
  final String icon, title;
  final String? subtitle;
  final Function()? onClick;
  final List<Setting> settings;

  SettingMenu(this.icon, this.title, {this.subtitle, this.onClick, required this.settings});
}

enum SettingType { bool, int, yesNo, action, radio }

enum Setting {
  test('Test 1', SettingType.bool, subtitle: 'Subtitle test 1', defaultValue: false),
  language('%Setting.language.title', SettingType.radio,
      subtitle: '%Setting.language.subtitle', defaultValue: 'itIT');

  final String title;
  final String? subtitle;
  final SettingType type;
  final Object? defaultValue;

  const Setting(this.title, this.type, {this.subtitle, this.defaultValue});

  String get id => name;

  Object? get value => IOManager().get(id) ?? defaultValue;

  set value(newValue) => IOManager().set(id, newValue);
}
