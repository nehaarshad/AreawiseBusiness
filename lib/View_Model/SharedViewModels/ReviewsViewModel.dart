import 'package:ecommercefrontend/models/reviewsModel.dart';
import 'package:ecommercefrontend/repositories/featuredRepositories.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/featureModel.dart';
import '../../repositories/reviewsRepository.dart';

final reviewsModelProvider = StateNotifierProvider.family<reviewsModel, AsyncValue<List<Reviews?>>,String>((ref,id) {
  return reviewsModel(ref,id);
});

class reviewsModel extends StateNotifier<AsyncValue<List<Reviews?>>> {
  final Ref ref;
  final String id;
  reviewsModel(this.ref,this.id) : super(AsyncValue.loading());

  Future<void> addProductReviews(String id,int productId,int Rating,String comment) async {
    try {

     final data= {
        "productId":productId,
    "rating":Rating,
    "comment":comment
  };

      Reviews review = await ref.read(reviewsProvider).addReview(data, id);
     state = const AsyncValue.loading();
   getProductReviews(productId.toString());

    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getProductReviews(String id) async {
    try {
      List<Reviews?> review = await ref.read(reviewsProvider).getReview( id);
      state = AsyncValue.data(review);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  ///for admin
  Future<void> updateProductReviews(String id,String productId,String comment) async {
    try {

      Reviews review = await ref.read(reviewsProvider).updateReview(id, comment);
      getProductReviews(productId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  ///for dashboardView
  Future<void> deleteProductReview(String id,String productId) async {
    try {
      await ref.read(reviewsProvider).deleteReview(id);
      getProductReviews(productId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}