import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../interface/json_serializable.dart';

class IOManager {
  static final IOManager _instance = IOManager._();

  factory IOManager() => _instance;

  IOManager._();

  static const String accountUID = 'accountUID';

  late final SharedPreferences prefs;
  final Map<Type, Future<bool> Function(SharedPreferences, String, dynamic)> _setMethods = {
    String: (sp, key, value) => sp.setString(key, value),
    int: (sp, key, value) => sp.setInt(key, value),
    bool: (sp, key, value) => sp.setBool(key, value),
    double: (sp, key, value) => sp.setDouble(key, value),
    List<String>: (sp, key, value) => sp.setStringList(key, value),
  };
  final Map<Type, Function(SharedPreferences, String)> _getMethods = {
    String: (sp, key) => sp.getString(key),
    int: (sp, key) => sp.getInt(key),
    bool: (sp, key) => sp.getBool(key),
    double: (sp, key) => sp.getDouble(key),
    List<String>: (sp, key) => sp.getStringList(key),
  };
  final Map<String, Object?> _cache = {};

  /// This must be called when the application starts
  init() async => prefs = await SharedPreferences.getInstance();

  // Simple Key/Value entries ==============================================================================
  /// Set/Update an entry both on disc and in the cache
  set<T>(String key, T value) {
    _cache[key] = value;
    _setMethods[T]!(prefs, key, value);
  }

  /// Retrieve an entry from disk. This can be called intensively, as a cache is used.
  T? get<T>(String key) =>
      _cache[key] ?? (_getMethods[T] ?? (sp, key) => sp.get(key))(prefs, key);

  remove(String key) async {
    _cache.remove(key);
    prefs.remove(key);
  }

  // Object Serialization/Deserialization ==================================================================
  serializeObjects<T extends JSONSerializable>(String key, List<T> objects) async {
    key = key.replaceAll('/', '');
    await set(key, jsonEncode(objects.map((e) => e.toJSON()).toList()));
    await set('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
    if (<T>[] is List<WithUID>) {
      await set('${key}_uids', objects.map((e) => (e as WithUID).uid!).toList());
    }
  }

  Future<List<T>> deserializeObjects<T extends JSONSerializable>(String key) async {
    key = key.replaceAll('/', '');
    final List<T> objs = jsonDecode(await get<String>(key) ?? '')
        .map((e) => JSONSerializable.modelFactories[T]!(e) as T)
        .toList()
        .cast<T>();
    if (<T>[] is List<WithUID>) {
      final uids = (await get<List<String>>('${key}_uids')) ?? [];
      for (var (i, e) in objs.indexed) {
        (e as WithUID).uid = uids[i];
      }
    }
    return objs;
  }

  /// Check that the device is connected to the Internet
  Future<bool> hasInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {}
    context.snackbar('Connessione internet assente!', backgroundColor: Palette.primaryRed);
    return false;
  }
}
