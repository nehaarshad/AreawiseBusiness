import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/localDataSource/userLocalSource.dart';
import '../core/network/appexception.dart';
import '../core/network/networkChecker.dart';
import '../core/services/app_APIs.dart';
import '../models/UserDetailModel.dart';
import '../models/notificationModel.dart';

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

  UserLocalDataSource get localDataSource => ref.read(userLocalDataSourceProvider);

  NetworkChecker get _networkChecker => ref.read(networkCheckerProvider);

  Future<List<UserDetailModel>> fetchAndCacheAllUsers() async {
    final isConnected = await _networkChecker.isConnected();

      if (localDataSource.hasCachedData()) {
        return localDataSource.getAllUsers();
      }
      return [];
  }
  Future<List<UserDetailModel>> getAllUsers() async {
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getAllUserEndPoints, headers()
        );
        List<UserDetailModel> userlist = (response as List)
            .map((user) => UserDetailModel.fromJson(user as Map<String, dynamic>))
            .toList();
        await localDataSource.cacheAllUsers(userlist);
        return userlist;
      } catch (e) {
        print(e);
        if(localDataSource.hasCachedData()){
          return localDataSource.getAllUsers();
        }
        throw NoInternetException("No internet and no cache data");
      }
    }
    else{
      if(localDataSource.hasCachedData()){
        return localDataSource.getAllUsers();
      }
      throw NoInternetException("No internet and no cache data");
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
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      try {
        List<UserDetailModel> userlist = [];
        dynamic response = await apiservice.GetApiResponce(
            AppApis.SearchUserBynameEndPoints.replaceFirst(
                ':username', username), headers()
        );
        if (response is List) {
          return response
              .map(
                (user) =>
                UserDetailModel.fromJson(user as Map<String, dynamic>),
          )
              .toList();
        }
        userlist = [UserDetailModel.fromJson(response)];
        return userlist;
      } catch (e) {
        print(e);
        if(localDataSource.hasCachedData()){
          return localDataSource.getUserByName(username);
        }
        throw NoInternetException("No internet and no cache data");
      }
    }
    else{
      if(localDataSource.hasCachedData()){
        return localDataSource.getUserByName(username);
      }
      throw NoInternetException("No internet and no cache data");
    }
  }

  Future<UserDetailModel> getuserbyid(String id) async {
    int? userid= int.tryParse(id);
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      try {
        UserDetailModel user;
        dynamic response = await apiservice.GetApiResponce(
            AppApis.SearchUserByIdEndPoints.replaceFirst(':id', id), headers()
        );
        user = UserDetailModel.fromJson(response);
        return user;
      } catch (e) {
        print(e);
        if(localDataSource.hasCachedData()){
          return localDataSource.getUserById(userid!);
        }
        throw NoInternetException("No internet and no cache data");
      }
    }
    else{
      if(localDataSource.hasCachedData()){
        return localDataSource.getUserById(userid!);
      }
      throw NoInternetException("No internet and no cache data");

    }
  }

  Future<List<NotificationModel>> getUserNotifications(String id) async {
    try {
      List<NotificationModel> notifications=[];
      dynamic response = await apiservice.GetApiResponce(
          AppApis.getUserNotificationEndPoints.replaceFirst(':id', id),headers()
      );
      print("Notifications ${response}");
      if (response is List) {
        return response.map((notify) =>
            NotificationModel.fromJson(notify as Map<String, dynamic>),)
            .toList();
      }
      if (response == null) {
        return [];
      }
      notifications = [NotificationModel.fromJson(response)];
      return notifications;
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

  Future<dynamic> changePassword(
      Map<String, dynamic> data,
      String id,
      ) async
  {
    try {
      final body=jsonEncode(data);
      dynamic response = await apiservice.UpdateApiWithJson(
          AppApis.ChangePasswordEndPoints.replaceFirst(':id', id),
          body,
          headers()
      );
      print("in repo ${response['message']}");
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
      print(response);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
