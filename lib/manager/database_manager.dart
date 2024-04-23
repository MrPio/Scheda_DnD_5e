import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:scheda_dnd_5e/model/campaign.dart';
import 'package:scheda_dnd_5e/model/character.dart';
import 'package:scheda_dnd_5e/model/enchantment.dart';
import 'package:scheda_dnd_5e/model/user.dart' as dnd_user;

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._();

  factory DatabaseManager() => _instance;

  DatabaseManager._();

  static const collections = {
    dnd_user.User: 'users/',
    Campaign: 'campaigns/',
    Character: 'characters/',
    Enchantment: 'enchantments/',
  };
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  var paginateKeys = HashMap<String, String?>();

  // Get an object from the given location
  Future<Map<String, dynamic>> get(String path) async =>
      jsonDecode(jsonEncode((await _database.doc(path).get()).data() as Map));

  // Get a list of object and paginate it
  Future<List<T>?> getList<T extends JSONSerializable>(String collection,
      {pageSize = 30}) async {
    final lastKey = paginateKeys[collection];
    if (paginateKeys.containsKey(collection) && lastKey == null) return null;

    var query = _database.collection(collection).orderBy(FieldPath.documentId);
    if (lastKey != null) {
      query = query.startAfter([lastKey]);
    }
    final dataSnapshot = await query.limit(pageSize).get();

    paginateKeys[collection] =
        dataSnapshot.docs.isNotEmpty ? dataSnapshot.docs.last.id : null;

    List<Map<String, dynamic>> dataList = [];
    for (var doc in dataSnapshot.docs) {
      var data = doc.data();
      if (T is Identifiable) {
        data['uid'] = doc.id;
      }
      dataList.add(data);
    }
    return dataList.map((e) => JSONSerializable.modelFactories[T]!(e)).toList().cast<T>() ;
  }

  // Put an object to a given location
  Future<void> put(String path, dynamic object) async =>
      _database.doc(path).set(object);

  // Push given object in a new child on the giving location. Returns the created key
  Future<String?> post(String collection, dynamic object) async {
    final node = _database.collection(collection).doc();
    await node.set(object);
    return node.id;
  }

  // Delete all the documents under a given collection
  deleteCollection<T>() async {
    final collectionReference = _database.collection(collections[T]!);
    final querySnapshot = await collectionReference.get();
    final batch = _database.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
