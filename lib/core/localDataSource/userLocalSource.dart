
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:ecommercefrontend/models/hiveModels/userHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/UserMapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {

  final dataSource = UserLocalDataSource();
  dataSource.init();
  return dataSource;
});

class UserLocalDataSource {
  static const String allUserBox = 'all_user_cache';

  late Box<UserHiveModel> _userBox;

  Future<void> init() async {
    _userBox = await Hive.openBox<UserHiveModel>(allUserBox);
  }

  Future<void> cacheAllUsers(List<UserDetailModel> users) async {
    // Clear old cache
    await _userBox.clear();

    // Save all users
    for (var user in users) {
      if (user.id != null) {
        ///convert to hive model for storage
        final hiveModel = UserMapper.toHiveModel(user);
        await _userBox.put(user.id, hiveModel);  // Use product ID as key
      }
    }
  }

  List<UserDetailModel> getAllUsers() {
    return _userBox.values
        .map((hive) => UserMapper.fromHiveModel(hive))
        .toList();
  }

  List<UserDetailModel> getUserByName(String name) {
    return _userBox.values
        .where((s) => s.username == name)
        .map((hive) => UserMapper.fromHiveModel(hive))
        .toList();
  }

  Future<void> cacheUserById(UserDetailModel user) async {

      if (user.id != null) {
        ///convert to hive model for storage
        final hiveModel = UserMapper.toHiveModel(user);
        await _userBox.put(user.id, hiveModel);  // Use product ID as key
      }

  }

  UserDetailModel getUserById(int id) {
    final hiveModel = _userBox.get(id);
    return UserMapper.fromHiveModel(hiveModel) ;
  }

  bool hasCachedData() {
    return _userBox.isNotEmpty;
  }

}