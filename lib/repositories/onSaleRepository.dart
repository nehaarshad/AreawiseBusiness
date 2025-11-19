import 'dart:convert';
import 'package:ecommercefrontend/models/salesModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/app_APIs.dart';

final onSaleProvider = Provider<onSaleRepositories>((ref) {
  return onSaleRepositories(ref: ref);
});

class onSaleRepositories {
  Ref ref;
  onSaleRepositories({required this.ref});
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  baseapiservice apiservice = networkapiservice();


  Future<SaleOffer> updateOnSaleProduct(String id,Map<String,dynamic> data) async {
    try {

      dynamic response = await apiservice.UpdateApiWithJson(AppApis.updateOnSaleProductEndPoints.replaceFirst(':id', id),data, headers(),);

     final sale = SaleOffer.fromJson(response);
      return sale;
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> addOnSaleProduct(Map<String, dynamic> data, String id, ) async {
    try {

      dynamic response = await apiservice.PostApiWithJson(AppApis.addOnSaleEndPoints.replaceFirst(':id', id), jsonEncode(data), headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteOnSaleProduct(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteOnSaleEndPoints.replaceFirst(':id', id), headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
