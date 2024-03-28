import 'package:collection/collection.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/database_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';

enum SaveMode { post, put }

class DataManager {
  static final DataManager _instance = DataManager._();

  factory DataManager() => _instance;

  DataManager._();

  static const pageSize = 100;

  final anonymous = User();
  List<User> cachedUsers = [];

  /// Load a single User object from a given uid
  Future<User> loadUser(String? uid, {bool force = false}) async {
    if (!force) {
      // Is anonymous?
      if (uid == null) {
        return anonymous;
      }

      // Already cached?
      User? cachedUser =
          cachedUsers.firstWhereOrNull((user) => user.uid == uid);
      if (cachedUser != null) return cachedUser;

      // Is current User?
      if (AccountManager().user.uid == uid) return AccountManager().user;
    }

    // Ask the database for the user and caching it
    User? user = User.fromJson(await DatabaseManager().get("users/$uid"));
    user.uid = uid;
    // loadUserPosts(user);
    cachedUsers.add(user);
    return user;
  }


  // Save Model objects
  save(Object model, [SaveMode mode = SaveMode.put]) async {
    // String path = "users/${mode == SaveMode.put ? model.uid : ''}";
    const path="";
    if (path == '') return;

    // Query the FirebaseRD
    if (model is JSONSerializable) {
      if (mode == SaveMode.put) {
        DatabaseManager().put(path, model.toJSON());
      } else {
        String? uid = await DatabaseManager().post(path, model.toJSON());
        if (uid != null) {
          // Any operations to be performed with the retrieved uid
          // if (model is Post) {
          //   // Add the newly created post to current user's posts list
          //   posts.add(model);
          //   AccountManager().user.postsUIDs.add(uid);
          //   AccountManager().user.posts.add(model);
          //   save(AccountManager().user);
          // }
        }
      }
    }
  }
}
