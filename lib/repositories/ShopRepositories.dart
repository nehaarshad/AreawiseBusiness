import 'dart:convert';
import 'dart:io';
import 'package:ecommercefrontend/core/localDataSource/shopLocalDataSource.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/appexception.dart';
import '../core/network/networkChecker.dart';
import '../core/services/app_APIs.dart';

final shopProvider = Provider<ShopRepositories>((ref) {
  return ShopRepositories(ref);
});

class ShopRepositories {

  Ref ref;

  ShopRepositories(this.ref);

  baseapiservice apiservice = networkapiservice();
  Map<String, String> headers() {
    final token = ref
        .read(sessionProvider)
        ?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  ShopLocalDataSource get _localDataSource => ref.read(shopLocalDataSourceProvider);

  NetworkChecker get _networkChecker => ref.read(networkCheckerProvider);

  Future<List<ShopModel>> fetchAndCacheAllShops() async {

      if(_localDataSource.hasCachedData()){
        return _localDataSource.getAllShops();
      }
      return [];

  }


  Future<dynamic> addShop(
    Map<String, dynamic> data,
    String id,
    List<File>? images,
  ) async
  {
    try {
      dynamic response = await apiservice.PostApiWithMultiport(
        AppApis.AddUserShopEndPoints.replaceFirst(':id', id),
        data,
        images,headers()
      );
      print(response);
      return response;
    } catch (e) {
      throw e;
    }
  }

  
  //All Shops
  Future<List<ShopModel?>> getAllShops() async {

    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      List<ShopModel> shoplist = [];
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.GetAllShopEndPoints, headers()
        );
        if (response is List) {
          shoplist= response
              .map((shop) => ShopModel.fromJson(shop as Map<String, dynamic>))
              .toList();
        }
        else {
          shoplist = [ShopModel.fromJson(response)];
        }
        await _localDataSource.cacheAllShops(shoplist);
        return shoplist;
      } catch (e) {
        print(e);
        if(_localDataSource.hasCachedData()){
          return _localDataSource.getAllShops();
        }
        throw NoInternetException("No Internet and no cache data");
      }
    }
    else{
      if(_localDataSource.hasCachedData()){
        return _localDataSource.getAllShops();
      }
      throw NoInternetException("No Internet and no cache data");
    }
    
  }

  //Seller may have one or more shops
  Future<List<ShopModel>> getUserShop(String id) async {
    int? sellerid= int.tryParse(id);
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      List<ShopModel> shoplist = [];
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.GetUserShopEndPoints.replaceFirst(':id', id), headers()
        );
        if (response is List) {
          return response
              .map((shop) => ShopModel.fromJson(shop as Map<String, dynamic>))
              .toList();
        }
        return shoplist;
      } catch (e) {
        print(e);
        if(_localDataSource.hasCachedData()){
          if(sellerid!=null) {
            return _localDataSource.getSellerShops(sellerid);
          }
        }
        throw NoInternetException("No Internet and no cache data");
      }
    }
    else{
      if(_localDataSource.hasCachedData()){
        if(sellerid!=null) {
          return _localDataSource.getSellerShops(sellerid);
        }
      }
      throw NoInternetException("No Internet and no cache data");
      
    }
  }

  Future<ShopModel> findShop(String id) async {
    
    int? sellerid= int.tryParse(id);
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.FindShopEndPoints.replaceFirst(':id', id), headers()
        );
        return ShopModel.fromJson(response);
      } catch (e) {
        print(e);
        if(_localDataSource.hasCachedData()){
          if(sellerid!=null) {
            return _localDataSource.getShopById(sellerid);
          }
        }
        throw NoInternetException("No Internet and no cache data");
      }
    }
    else{
      if(_localDataSource.hasCachedData()){
        if(sellerid!=null) {
          return _localDataSource.getShopById(sellerid);
        }
      }
      throw NoInternetException("No Internet and no cache data");
    }
  }
  
  Future<List<ShopModel?>> searchShop(String name) async {

    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      List<ShopModel> shoplist = [];
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.GetShopByNameEndPoints.replaceFirst(":name", name),
            headers()
        );
        if (response is List) {
          return response
              .map((shop) => ShopModel.fromJson(shop as Map<String, dynamic>))
              .toList();
        }
        return shoplist;
      } catch (e) {
        print(e);
        if(_localDataSource.hasCachedData()){
            return _localDataSource.searchShop(name);
          
        }
        throw NoInternetException("No Internet and no cache data");
      }
    }
    else{
      if(_localDataSource.hasCachedData()){
          return _localDataSource.searchShop(name);
        
      }
      throw NoInternetException("No Internet and no cache data");
    }
  }

  Future<Map<String, dynamic>> updateShop(
    Map<String, dynamic> data,
    String id,
    List<File>? images,
  ) async
  {
    try {
      dynamic response = await apiservice.UpdateApiWithMultiport(
        AppApis.UpdateUserShopEndPoints.replaceFirst(':id', id),
        data,
        images,headers()
      );
      print(response);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<ShopModel> updateShopStatus(String id, String status,) async {
    try {
      final data = jsonEncode({'status': status});

      dynamic response = await apiservice.UpdateApiWithJson(
        AppApis.updateShopStatusEndPoints.replaceFirst(':id', id),
        data,
        headers(),
      );
      return ShopModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }


  Future<dynamic> deleteShop(String id) async
  {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.DeleteShopEndPoints.replaceFirst(':id', id),headers()
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteUserShop(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.DeleteUserShopEndPoints.replaceFirst(':id', id),headers()
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}
