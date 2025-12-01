import 'dart:convert';
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:ecommercefrontend/core/services/app_APIs.dart';

import '../core/localDataSource/userLocalSource.dart';

final authprovider = Provider<AuthRepositories>((ref) {
  return AuthRepositories(ref);
});

class AuthRepositories {
  Ref ref;
  AuthRepositories(this.ref);
  baseapiservice apiservice = networkapiservice();

  UserLocalDataSource get localDataSource => ref.read(userLocalDataSourceProvider);

  Future<dynamic> loginapi(dynamic data) async {
    try {
      print("Login Data: $data");
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.loginEndPoints,
        data,
        {},
      );
      UserDetailModel? user = UserDetailModel.fromJson(response);
      await localDataSource.cacheUserById(user);
      if (kDebugMode) {
        print("Login Response: $response");
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("Login Response: $e");
      }
      throw e;
    }
  }

  Future<dynamic> sinupapi(Map<String,dynamic> data) async {
    try {

      final request=jsonEncode(data);
      print("Send Data As: ${request}");
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.signUpEndPoints,
        request,
        headers,
      );

      UserDetailModel? user = UserDetailModel.fromJson(response);
      await localDataSource.cacheUserById(user);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> forgetPassword(Map<String,dynamic> data) async {
    try {

      final request=jsonEncode(data);
      print("Send Data As: ${request}");
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.forgetPasswordEndPoints,
        request,
        headers,
      );
      return response;
    } catch (e) {
      throw e;
    }
  }


  Future<dynamic> logoutApi(String token) async {
    try {
      Map<String, String> headers = {
        'Authorization':
            'Bearer $token', // Include the token in the Authorization header
      };
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.logoutEndPoints,
        null,
        headers,
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}
