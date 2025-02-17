import 'dart:convert';
import 'dart:io';

import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../core/resources/app_APIs.dart';
import '../models/UserDetailModel.dart';

final userProvider=Provider<UserRepositories>((ref){
  return UserRepositories();
});

class UserRepositories{
  UserRepositories();

  baseapiservice apiservice=networkapiservice();

  Future<List<UserDetailModel>> getAllUsers() async{
    try{
      List<UserDetailModel> userlist=[];
      dynamic response=await apiservice.GetApiResponce(AppApis.getAllUserEndPoints);
      if (response is List){
      return response.map((user)=>UserDetailModel.fromJson(user as Map<String,dynamic>)).toList();
      }
      userlist=[UserDetailModel.fromJson(response)];
      return userlist;
    }catch(e){
      throw e;
    }
  }

  Future<UserDetailModel> getuserbyrole(String role) async{
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.SearchUsersByRoleEndPoints.replaceFirst(':role', role));
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<UserDetailModel> getuserbyname(String username) async{
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.SearchUserBynameEndPoints.replaceFirst(':username', username));
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<UserDetailModel> getuserbyid(String id) async{
    try{
      UserDetailModel user;
      dynamic response=await apiservice.GetApiResponce(AppApis.SearchUserByIdEndPoints.replaceFirst(':id', id));
      user=UserDetailModel.fromJson(response);
      return user;
    }catch(e){
      throw e;
    }
  }

  Future<Map<String, dynamic>> updateUser(Map<String,dynamic> data,String id,File? image) async{
    try{
      dynamic response=await apiservice.SingleFileUpdateApiWithMultiport(AppApis.UpdateUserEndPoints.replaceFirst(':id', id), data,image);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> deleteUser(String id) async{
    try{
      dynamic response=await apiservice.DeleteApiResponce(AppApis.DeleteUserEndPoints.replaceFirst(':id', id));
      return response;
    }catch(e){
      throw e;
    }
  }

}