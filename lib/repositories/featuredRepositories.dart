import 'dart:convert';

import 'package:ecommercefrontend/models/featureModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/app_APIs.dart';

final featureProvider = Provider<featureRepositories>((ref) {
  return featureRepositories(ref);
});

class featureRepositories {
  Ref ref;

  featureRepositories(this.ref);

  baseapiservice apiservice = networkapiservice();
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<featureModel> createProductFeatured(String id, Map<String, dynamic> request) async {
    try {
      final data = jsonEncode(request);
      dynamic response = await apiservice.PostApiWithJson(AppApis.createProductFeaturedEndPoints.replaceFirst(':id', id), data, headers());
      if (response is Map<String, dynamic>) {
        return featureModel.fromJson(response);
      }
      throw Exception("invalid Response");
    } catch (e) {
      throw e;
    }
  }

  Future<List<featureModel?>> getSellerFeaturedProducts(String id)async{
    List<featureModel> orders;
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getUserFeaturedProductsEndPoints.replaceFirst(':id', id),headers());
      if (response is List) {
        return response.map((order) => featureModel.fromJson(order as Map<String, dynamic>)).toList();
      }
      orders = [featureModel.fromJson(response)];
      return orders;
    }catch(e){
      rethrow;
    }
  }

  Future<List<featureModel?>> getAllFeaturedProducts(String category)async{
    List<featureModel> orders;
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getAllFeaturedProductsEndPoints.replaceFirst(':Category', category),headers());
      if (response is List) {
        return response.map((order) => featureModel.fromJson(order as Map<String, dynamic>),).toList();
      }
      orders = [featureModel.fromJson(response)];
      return orders;
    }catch(e){
      rethrow;
    }
  }

  Future<List<featureModel?>> getAllRequestedFeaturedProducts()async{
    List<featureModel> orders;
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getAllRequestedFeaturedProductsEndPoints,headers());
      if (response is List) {
        return response.map((order) => featureModel.fromJson(order as Map<String, dynamic>),).toList();
      }
      orders = [featureModel.fromJson(response)];
      return orders;
    }catch(e){
      rethrow;
    }
  }

  Future<featureModel> updateFeaturedProducts(String id,  Map<String,dynamic>  status) async {
    try {
      print(id);
      final responseData=jsonEncode(status);
      dynamic response = await apiservice.UpdateApiWithJson(AppApis.updateFeaturedProductsEndPoints.replaceFirst(':id', id), responseData, headers(),);
      return featureModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteFeaturedProducts(String id)async{

    try{
      dynamic response=await apiservice.DeleteApiResponce(AppApis.deleteFeaturedProductsEndPoints.replaceFirst(':id', id),headers());

      return response;
    }catch(e){
      rethrow;
    }
  }

}
