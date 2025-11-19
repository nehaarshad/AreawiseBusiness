import 'dart:convert';
import 'dart:io';
import 'package:ecommercefrontend/models/reviewsModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/app_APIs.dart';

final reviewsProvider = Provider<ReviewsRepositories>((ref) {
  return ReviewsRepositories(ref);
});

class ReviewsRepositories {
  Ref ref;

  ReviewsRepositories(this.ref);

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

  Future<List<Reviews?>> getReview(String id) async {
    try {
      List<Reviews> review = [];
      dynamic response = await apiservice.GetApiResponce(AppApis.getReviewEndPoints.replaceFirst(':id', id),headers());
      if (response is List) {
        return response.map((products) => Reviews.fromJson(products as Map<String, dynamic>),).toList();
      }
      review = [Reviews.fromJson(response)];
      return review;
    } catch (e) {
      throw e;
    }
  }

  Future<Reviews> addReview(Map<String, dynamic> data, String id,List<File>? file) async {
    try {

      dynamic response = await apiservice.PostApiWithMultiport(
          AppApis.AddReviewEndPoints.replaceFirst(':id', id),
          data,
          file,
          headers());
      return Reviews.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<Reviews> updateReview(String id, String comment,List<File>? file) async {
    try {
      final data = {'comment': comment};
      dynamic response = await apiservice.UpdateApiWithMultiport(
        AppApis.UpdateReviewEndPoints.replaceFirst(':id', id),
        data,
        file,
        headers(),
      );
      return Reviews.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteReview(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(AppApis.DeleteReviewEndPoints.replaceFirst(':id', id),headers());
      return response;
    } catch (e) {
      throw e;
    }
  }

}
