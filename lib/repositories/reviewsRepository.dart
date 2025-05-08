import 'dart:convert';
import 'dart:io';
import 'package:ecommercefrontend/models/reviewsModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../core/services/app_APIs.dart';

final reviewsProvider = Provider<ReviewsRepositories>((ref) {
  return ReviewsRepositories();
});

class ReviewsRepositories {
  ReviewsRepositories();

  baseapiservice apiservice = networkapiservice();

  Future<List<Reviews?>> getReview(String id) async {
    try {
      List<Reviews> review = [];
      dynamic response = await apiservice.GetApiResponce(AppApis.getReviewEndPoints.replaceFirst(':id', id));
      if (response is List) {
        return response.map((products) => Reviews.fromJson(products as Map<String, dynamic>),).toList();
      }
      review = [Reviews.fromJson(response)];
      return review;
    } catch (e) {
      throw e;
    }
  }

  Future<Reviews> addReview(Map<String, dynamic> data, String id) async {
    try {
      final body = jsonEncode(data);
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.PostApiWithJson(
          AppApis.AddReviewEndPoints.replaceFirst(':id', id),
          body,
          headers);
      return Reviews.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<Reviews> updateReview(String id, String comment) async {
    try {
      final data = jsonEncode({'comment': comment});
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.UpdateApiWithJson(
        AppApis.UpdateReviewEndPoints.replaceFirst(':id', id),
        data,
        headers,
      );
      return Reviews.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteReview(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(AppApis.DeleteReviewEndPoints.replaceFirst(':id', id));
      return response;
    } catch (e) {
      throw e;
    }
  }

}
