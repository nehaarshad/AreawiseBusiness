import 'dart:convert';
import 'package:ecommercefrontend/models/feedbackModel.dart';
import 'package:ecommercefrontend/models/reviewsModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/services/app_APIs.dart';

final feedbackProvider = Provider<feedbackRepositories>((ref) {
  return feedbackRepositories(ref);
});

class feedbackRepositories {
  Ref ref;

  feedbackRepositories(this.ref);

  Map<String, String> headers() {
    final token = ref
        .read(sessionProvider)
        ?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  baseapiservice apiservice = networkapiservice();

  Future<List<feedbackModel>> getFeedback() async {
    try {
      List<feedbackModel> feedback = [];
      dynamic response = await apiservice.GetApiResponce(AppApis.getFeedbackEndPoints,headers());
      if (response is List) {
        return response.map((feedback) => feedbackModel.fromJson(feedback as Map<String, dynamic>),).toList();
      }
      feedback = [feedbackModel.fromJson(response)];
      return feedback;
    } catch (e) {
      throw e;
    }
  }

  Future<feedbackModel> addFeedback(Map<String, dynamic> data) async {
    try {
      final body = jsonEncode(data);

      dynamic response = await apiservice.PostApiWithJson(
          AppApis.submitFeedbackEndPoints,
          body,
          headers());
      return feedbackModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

}
