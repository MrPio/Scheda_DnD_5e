import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scheda_dnd_5e/extension_function/int_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tuple/tuple.dart';

enum StorageCollection {
  profilePicture('profile_picture');

  final String folder;

  const StorageCollection(this.folder);
}

class StorageManager {
  static final StorageManager _instance = StorageManager._();

  factory StorageManager() => _instance;

  StorageManager._();

  final StorageFileApi _storage = Supabase.instance.client.storage.from(dotenv.env['BUCKET_NAME']!);
  final Map<String, Tuple2<int, String>> cachedURLs = {};
  static const urlExpiresIn = 300;

  /// Request a 5min URL from the [file] inside the [collection], if not in cache.
  String fetchUrl(StorageCollection collection, String file) {
    final path = '${collection.folder}/$file';
    // Check if the cache already contains a non expired URL for this file
    if (cachedURLs.containsKey(path) &&
        cachedURLs[path]!.item1.elapsedTime.inSeconds >= urlExpiresIn - 5) {
      print(
          '📙 I\'ve fetched the URL for `$path` from the cache. Expires in ${urlExpiresIn - cachedURLs[path]!.item1.elapsedTime.inSeconds} sec');
      return cachedURLs[path]!.item2;
    } else {
      print(path);
      // final url = await _storage.createSignedUrl(path, urlExpiresIn);
      final url = _storage.getPublicUrl(path);
      cachedURLs[path] = Tuple2(DateTime.now().millisecondsSinceEpoch, url);
      return url;
    }
  }
}
