import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../core/resources/app_APIs.dart';
import '../models/UserAddressModel.dart';

final addressProvider=Provider<AddressRepositories>((ref){
  return AddressRepositories();
});

class AddressRepositories{
  AddressRepositories();

  baseapiservice apiservice=networkapiservice();

  Future<Address> addAddress(dynamic data,String id) async{
    try{
      dynamic response=await apiservice.PostApiWithJson(AppApis.AddUserAddressEndPoints.replaceFirst(':id', id), data,{});
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<Address> getAddress(String id) async{
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.GetUserAddressEndPoints.replaceFirst(':id', id));
      return response;
    }catch(e){
      throw e;
    }
  }

  // Future<UserAddressModel> updateAddress(Map<String,dynamic> data,String id) async{
  //   try{
  //
  //     final jsonData=jsonEncode(data);
  //     final headers = {'Content-Type': 'application/json'};
  //     dynamic response=await apiservice.getUpdateapiresponce(AppApis.UpdateUserAddressEndPoints.replaceFirst(':id', id), jsonData,headers);
  //     return response;
  //   }catch(e){
  //     throw e;
  //   }
  // }

  Future<dynamic> deleteAddress(dynamic data,String id) async{
    try{
      dynamic response=await apiservice.DeleteApiResponce(AppApis.DeleteUserAddressEndPoints.replaceFirst(':id', id));
      return response;
    }catch(e){
      throw e;
    }
  }

}