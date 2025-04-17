import 'dart:convert';
import 'dart:io';

import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../core/services/app_APIs.dart';
import '../models/UserDetailModel.dart';
import '../models/adsModel.dart';

final adProvider = Provider<AdsRepositories>((ref) {
  return AdsRepositories();
});

class AdsRepositories {
  AdsRepositories();

  baseapiservice apiservice = networkapiservice();

  Future<List<adsModel>> getAllAds() async {
    try {
      List<adsModel> adlist = [];
      dynamic response = await apiservice.GetApiResponce(AppApis.getAllAdsEndPoints);
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
      dynamic response = await apiservice.GetApiResponce(AppApis.getUserAdsEndPoints.replaceFirst(':id', id));
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
      dynamic response = await apiservice.SingleFileUploadApiWithMultiport(AppApis.createAdEndPoints.replaceFirst(':id', id), data, image);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteAd(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteAdEndPoints.replaceFirst(':id', id));
      return response;
    } catch (e) {
      throw e;
    }
  }
}
