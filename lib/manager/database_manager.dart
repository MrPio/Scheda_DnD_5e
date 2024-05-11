import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
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

  // Get an identifiable object from the given location
  Future<T> get<T extends WithUID>(String collection, String uid) async =>
      (JSONSerializable.modelFactories[T]!((await _database.doc(collection+uid).get()).data()) as T)..uid=uid;

  // Get a list of documents and paginate it
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
      if (T is WithUID) {
        data['uid'] = doc.id;
      }
      dataList.add(data);
    }
    return dataList.map((e) => JSONSerializable.modelFactories[T]!(e)).toList().cast<T>() ;
  }

  // Get all the identifiable documents corresponding to the given UIDs
  Future<List<T>?> getListFromUIDs<T extends WithUID>(String collection,
      List<String> uids) async {
    final dataSnapshot = await _database.collection(collection).where(FieldPath.documentId, whereIn: uids).get();

    List<Map<String, dynamic>> dataList = [];
    for (var doc in dataSnapshot.docs) {
      var data = doc.data();
        data['uid'] = doc.id;
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
