import 'package:ecommercefrontend/repositories/featuredRepositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/featureModel.dart';

final featureProductViewModelProvider = StateNotifierProvider<featureProductViewModel, AsyncValue<List<featureModel?>>>((ref,) {
  return featureProductViewModel(ref);
});

class featureProductViewModel extends StateNotifier<AsyncValue<List<featureModel?>>> {
  final Ref ref;
  featureProductViewModel(this.ref) : super(AsyncValue.loading());

  ///for sellers
  Future<void> getUserFeaturedProducts(String id) async {
    try {
      List<featureModel?> feature = await ref.read(featureProvider).getSellerFeaturedProducts(id);
      state = AsyncValue.data(feature.isEmpty ? [] : feature);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  ///for admin
  Future<void> getAllRequestedFeatured() async {
    try {
      List<featureModel?> feature = await ref.read(featureProvider).getAllRequestedFeaturedProducts();
      state = AsyncValue.data(feature.isEmpty ? [] : feature);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  ///for dashboardView
  Future<void> getAllFeaturedProducts(String category) async {
    try {
      List<featureModel?> feature = await ref.read(featureProvider).getAllFeaturedProducts(category);
      state = AsyncValue.data(feature.isEmpty ? [] : feature);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}