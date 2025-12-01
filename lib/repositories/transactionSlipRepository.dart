import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/services/app_APIs.dart';
import '../models/imageModel.dart';

final transcriptsProvider = Provider<transcriptsRepositories>((ref) {
  return transcriptsRepositories(ref);
});

class transcriptsRepositories {
  Ref ref;
  transcriptsRepositories(this.ref);
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  baseapiservice apiservice = networkapiservice();


  Future<  List<ImageModel>> getTranscript(Map<String,dynamic> data) async {
    List<ImageModel> images = [];
    try {
      final body=jsonEncode(data);
      dynamic response = await apiservice.PostApiWithJson(
          AppApis.getTransactionSlipEndPoints,body,headers()
      );
      print("slips ${response}");
      if (response is List) {
        return response.map((products) =>
            ImageModel.fromJson(products as Map<String, dynamic>),)
            .toList();
      }
      images = [ImageModel.fromJson(response)];
      return images;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> addTranscript(
      Map<String, dynamic> data,
      File? image,
      ) async
  {
    try {
      dynamic response = await apiservice.SingleFileUploadApiWithMultiport(
          AppApis.uploadTransactionSlipEndPoints,
          data,
          image,
          headers()
      );
      print(response);
      return response;
    } catch (e) {
      throw e;
    }
  }

}