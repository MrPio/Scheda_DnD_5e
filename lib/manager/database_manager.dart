import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._();

  factory DatabaseManager() => _instance;

  DatabaseManager._();

  final FirebaseFirestore _database = FirebaseFirestore.instance;
  var paginateKeys = HashMap<String, String?>();


  /// Get an object from the given location
  Future<Map<String, dynamic>> get(String path) async => jsonDecode(
      jsonEncode((await _database.doc(path).get()).data() as Map));

  /// Get a list of object and paginate it
  Future<List<Map<String, dynamic>>?> getList(String collection,
      {pageSize = 30}) async {
    final lastKey = paginateKeys[collection];
    if (paginateKeys.containsKey(collection) && lastKey == null) return null;

    var query = _database.collection(collection).orderBy(FieldPath.documentId);
    if (lastKey != null) query = query.startAfterDocument(await _database.collection(collection).doc(lastKey).get());
    final dataSnapshot = await query.limitToLast(pageSize).get();

    paginateKeys[collection] = dataSnapshot.docs.isNotEmpty ? dataSnapshot.docs.last.id : null;

    List<Map<String, dynamic>> dataList = [];
    for (var doc in dataSnapshot.docs) {
      var data = doc.data();
      data["uid"] = doc.id;
      dataList.add(data);
    }
    return dataList;
  }

  /// Put an object to a given location
  Future<void> put(String path, dynamic object) async =>
      _database.doc(path).set(object);

  /// Push given object in a new child on the giving location. Returns the created key
  Future<String?> post(String collection, dynamic object) async {
    final node = _database.collection(collection).doc();
    await node.set(object);
    return node.id;
  }
}
