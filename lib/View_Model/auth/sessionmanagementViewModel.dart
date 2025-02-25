import 'package:ecommercefrontend/repositories/auth_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/auth_users.dart';

final sessionProvider = StateNotifierProvider<sessionViewModel, UserModel?>((
  ref,
) {
  return sessionViewModel(ref);
});

class sessionViewModel extends StateNotifier<UserModel?> {
  final Ref ref;
  sessionViewModel(this.ref) : super(null) {
    getuser();
  }

  Future<void> saveuser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('username', user.username!.toString());
    sp.setString('email', user.email!.toString());
    sp.setString('role', user.role!.toString());
    sp.setString('token', user.token!.toString());
    sp.setInt('id', user.id!.toInt());
    sp.setInt('contactnumber', user.contactnumber!.toInt());
    state = user;
  }

  Future<UserModel?> getuser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (!sp.containsKey('token')) {
      return null;
    }

    final String? username = sp.getString('username');
    final String? email = sp.getString('email');
    final String? role = sp.getString('role');
    final String? token = sp.getString('token');
    final int? id = sp.getInt('id');
    final int? contactnumber = sp.getInt('contactnumber');
    UserModel user = UserModel(
      username: username,
      email: email,
      role: role,
      token: token,
      id: id,
      contactnumber: contactnumber,
    );
    state = user;
    return user;
  }

  Future<bool> logout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('token');
    if (token != null) {
      await ref.read(authprovider).logoutApi(token);
      await sp.clear();
      state = null;
      return true;
    }
    return false;
  }
}
