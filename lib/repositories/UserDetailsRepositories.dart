import 'dart:convert';
import 'dart:io';

import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/services/app_APIs.dart';
import '../models/UserDetailModel.dart';

final userProvider = Provider<UserRepositories>((ref) {
  return UserRepositories(ref);
});

class UserRepositories {
  Ref ref;
  UserRepositories(this.ref);
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  baseapiservice apiservice = networkapiservice();

  Future<List<UserDetailModel>> getAllUsers() async {
    try {
      List<UserDetailModel> userlist = [];
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getAllUserEndPoints,headers()
      );
      if (response is List) {
        return response
            .map(
              (user) => UserDetailModel.fromJson(user as Map<String, dynamic>),
            )
            .toList();
      }
      userlist = [UserDetailModel.fromJson(response)];
      return userlist;
    } catch (e) {
      throw e;
    }
  }

  Future<UserDetailModel> getuserbyrole(String role) async {
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.SearchUsersByRoleEndPoints.replaceFirst(':role', role),headers()
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<List<UserDetailModel>> getuserbyname(String username) async {
    try {
      List<UserDetailModel> userlist = [];
      dynamic response = await apiservice.GetApiResponce(
        AppApis.SearchUserBynameEndPoints.replaceFirst(':username', username),headers()
      );
      if (response is List) {
        return response
            .map(
              (user) => UserDetailModel.fromJson(user as Map<String, dynamic>),
        )
            .toList();
      }
      userlist = [UserDetailModel.fromJson(response)];
      return userlist;
    } catch (e) {
      throw e;
    }
  }

  Future<UserDetailModel> getuserbyid(String id) async {
    try {
      UserDetailModel user;
      dynamic response = await apiservice.GetApiResponce(
        AppApis.SearchUserByIdEndPoints.replaceFirst(':id', id),headers()
      );
      user = UserDetailModel.fromJson(response);
      return user;
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> addUser(
      Map<String, dynamic> data,
      File? image,
      ) async
  {
    try {
      dynamic response = await apiservice.SingleFileUploadApiWithMultiport(
        AppApis.AddUserEndPoints,
        data,
        image,headers()
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> updateUser(
    Map<String, dynamic> data,
    String id,
    File? image,
  ) async
  {
    try {
      dynamic response = await apiservice.SingleFileUpdateApiWithMultiport(
        AppApis.UpdateUserEndPoints.replaceFirst(':id', id),
        data,
        image,headers()
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteUser(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.DeleteUserEndPoints.replaceFirst(':id', id),headers()
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}
