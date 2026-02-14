import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/auth/sessionmanagementViewModel.dart';
import '../utils/dialogueBox.dart';
import '../utils/routes/routes_names.dart';
import 'initCacheService.dart';

final splashserviceProvider = Provider((ref) {
  return splashservice(ref);
});

class splashservice {
  final Ref ref;
  splashservice(this.ref);

  Future<UserDetailModel?> getUserData() async {
    return ref.read(sessionProvider.notifier).getuser();
  }

  Future<String?> getUserLocation() async {
    return ref.read(sessionProvider.notifier).getLocation();
  }

  void checkAuth(BuildContext context, WidgetRef ref) async {
    UserDetailModel? value = await getUserData();
    String? location  = await getUserLocation();
    await Future.delayed(Duration(seconds: 3));
    await  initializeCache();// Initialize cache

    if (value == null || value.token == null || value.token == '') {
      Navigator.pushNamedAndRemoveUntil(context, routesName.login,(route)=>false);
    } else {

     await ref.read(cacheserviceProvider).cacheLocalData(); //cache data before nav to homeView

      if (value.role == 'Admin') {
        Navigator.pushNamedAndRemoveUntil(context, routesName.aHome,(route)=>false, arguments: value);
      }
      else {
        Navigator.pushNamedAndRemoveUntil(context, routesName.dashboard,(route)=>false, arguments: value);
      }
     if (location == null || location == '') {
       await DialogUtils.showLocationDialog(context);
     }
    }
  }

  Future<void> initializeCache() async{
    await  ref.read(cacheserviceProvider).initCache();
  }
}
