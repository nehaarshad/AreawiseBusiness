import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/services/app_APIs.dart';
import '../models/adsModel.dart';

final adProvider = Provider<AdsRepositories>((ref) {
  return AdsRepositories(ref: ref);
});

class AdsRepositories {
  Ref ref;
  AdsRepositories({required this.ref});
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  baseapiservice apiservice = networkapiservice();

  Future<List<adsModel>> getAllAds() async {
    try {

      print('in getAllADs repository ${headers()}');
      List<adsModel> adlist = [];
      dynamic response = await apiservice.GetApiResponce(AppApis.getAllAdsEndPoints, headers(),);
      if (response is List) {
        return response.map((ads) => adsModel.fromJson(ads as Map<String, dynamic>)).toList();
      }
      adlist = [adsModel.fromJson(response)];
      return adlist;
    } catch (e) {
      throw e;
    }
  }

  Future<List<adsModel>> getUserAds(String id) async {
    try {

      List<adsModel> adlist = [];
      dynamic response = await apiservice.GetApiResponce(AppApis.getUserAdsEndPoints.replaceFirst(':id', id), headers(),);
      if (response is List) {
        return response.map((ads) => adsModel.fromJson(ads as Map<String, dynamic>)).toList();
      }
      adlist = [adsModel.fromJson(response)];
      return adlist;
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> createAd(Map<String, dynamic> data, String id, File? image) async {
    try {

      dynamic response = await apiservice.SingleFileUploadApiWithMultiport(AppApis.createAdEndPoints.replaceFirst(':id', id), data, image, headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteAd(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteAdEndPoints.replaceFirst(':id', id), headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
