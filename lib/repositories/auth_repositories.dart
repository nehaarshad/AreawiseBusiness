import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:ecommercefrontend/core/resources/app_APIs.dart';

final authprovider = Provider<AuthRepositories>((ref) {
  return AuthRepositories();
});

class AuthRepositories {
  AuthRepositories();
  baseapiservice apiservice = networkapiservice();

  Future<dynamic> loginapi(dynamic data) async {
    try {
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.loginEndPoints,
        data,
        {},
      );
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
