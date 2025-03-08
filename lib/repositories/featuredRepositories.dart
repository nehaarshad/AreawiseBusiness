import 'dart:convert';

import 'package:ecommercefrontend/models/featureModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../core/resources/app_APIs.dart';

final featureProvider = Provider<featureRepositories>((ref) {
  return featureRepositories();
});

class featureRepositories {
  featureRepositories();

  baseapiservice apiservice = networkapiservice();


  Future<featureModel> createProductFeatured(String id, Map<String, dynamic> request) async {
    try {
      final data = jsonEncode(request);
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.PostApiWithJson(AppApis.createProductFeaturedEndPoints.replaceFirst(':id', id), data, headers);
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
      dynamic response=await apiservice.GetApiResponce(AppApis.getUserFeaturedProductsEndPoints.replaceFirst(':id', id));
      if (response is List) {
        return response.map((order) => featureModel.fromJson(order as Map<String, dynamic>)).toList();
      }
      orders = [featureModel.fromJson(response)];
      return orders;
    }catch(e){
      rethrow;
    }
  }

  Future<List<featureModel?>> getAllFeaturedProducts()async{
    List<featureModel> orders;
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getAllFeaturedProductsEndPoints);
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
      dynamic response=await apiservice.GetApiResponce(AppApis.getAllRequestedFeaturedProductsEndPoints);
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
      final responseData=jsonEncode(status);
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.UpdateApiWithJson(AppApis.updateFeaturedProductsEndPoints.replaceFirst(':id', id), responseData, headers,);
      return featureModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

}
