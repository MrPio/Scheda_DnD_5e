import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as path;
import 'package:scheda_dnd_5e/extension_function/int_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tuple/tuple.dart';

/// The bucket where the files are stored
///
/// If [isPrivate], operations require an authentication and URLs have an expiration time.
/// The files of the bucket are organized in the [collections].
enum Bucket {
  main('SchedaDnD5e',
      isPrivate: false, collections: [Collection.profilePicture], maxFileSize: 1 * 1024 * 1024);

  final String name;
  final bool isPrivate;
  final List<Collection> collections;
  final int maxFileSize;

  const Bucket(this.name,
      {this.isPrivate = true, required this.collections, this.maxFileSize = 50 * 1024 * 1024});
}

/// The [folder] of a bucket.
///
/// Each collection belongs to one and only one bucket.
enum Collection {
  profilePicture('profile_picture');

  final String folder;

  const Collection(this.folder);

  /// The bucket where the collection belongs to.
  Bucket get bucket => Bucket.values.firstWhere((bucket) => bucket.collections.contains(this));
}

class FileSizeException implements Exception {
  final String message;

  const FileSizeException(this.message);
}

class StorageManager {
  static final StorageManager _instance = StorageManager._();

  factory StorageManager() => _instance;

  StorageManager._();

  final SupabaseStorageClient _storage = Supabase.instance.client.storage;
  final Map<String, Tuple2<int, String>> cachedURLs = {};
  static const urlExpiresIn = 300;

  /// Request a 5min URL from the [file] inside the [collection], if not in cache.
  Future<String> _fetchPrivateUrl(Collection collection, String file) async {
    final path = '${collection.folder}/$file';
    // Check if the cache already contains a non expired URL for this file
    if (cachedURLs.containsKey(path) &&
        cachedURLs[path]!.item1.elapsedTime.inSeconds >= urlExpiresIn - 5) {
      print(
          '📙 I\'ve fetched the URL for `$path` from the cache. Expires in ${urlExpiresIn - cachedURLs[path]!.item1.elapsedTime.inSeconds} sec');
      return cachedURLs[path]!.item2;
    } else {
      print(path);
      final url = await _storage.from(collection.bucket.name).createSignedUrl(path, urlExpiresIn);
      cachedURLs[path] = Tuple2(DateTime.now().millisecondsSinceEpoch, url);
      return url;
    }
  }

  /// Request a URL for a [file], where the [collection] bucket can be public or private.
  Future<String> fetchUrl(Collection collection, String file) async => collection.bucket.isPrivate
      ? await _fetchPrivateUrl(collection, file)
      : _storage.from(collection.bucket.name).getPublicUrl('${collection.folder}/$file');

  /// Uploads a [file] to the public [collection], returning its filename if no errors occur.
  Future<String?> uploadFile(Collection collection, File file) async {
    if (await file.length() > collection.bucket.maxFileSize) {
      throw FileSizeException(
          "Il file non può essere più grande di ${collection.bucket.maxFileSize ~/ 1024 ~/ 1024} MB");
    }
    try {
      final filename =
          '${DateTime.now().toIso8601String()}_${Random().nextInt(10e3.toInt())}${path.extension(file.path)}';
      final response = await _storage
          .from(collection.bucket.name)
          .upload("${collection.folder}/$filename", file, fileOptions: const FileOptions(upsert: true));
      print('⬆️ Uploaded successfully: $response');
      return filename;
    } catch (e) {
      print('⛔ Error uploading image: $e');
    }
    return null;
  }
}
