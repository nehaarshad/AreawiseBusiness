import 'package:ecommercefrontend/repositories/featuredRepositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/notifyUtils.dart';
import '../../models/featureModel.dart';

final featureProductViewModelProvider = StateNotifierProvider.family<FeatureProductViewModel, AsyncValue<List<featureModel?>>, String>((ref, id) {
  return FeatureProductViewModel(ref, id);
});

class FeatureProductViewModel extends StateNotifier<AsyncValue<List<featureModel?>>> {
  final Ref ref;
  String id;
  bool _isDisposed = false;

  FeatureProductViewModel(this.ref, this.id) : super(AsyncValue.loading());

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // For sellers - gets only their featured products
  Future<void> getUserFeaturedProducts(String id) async {
    if (_isDisposed) return;
    state = AsyncValue.loading();

    try {
      List<featureModel?> feature = await ref.read(featureProvider).getSellerFeaturedProducts(id);
      if (!_isDisposed) {
        state = AsyncValue.data(feature.isEmpty ? [] : feature);
      }
    } catch (e) {
      if (!_isDisposed) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  // For admin - gets only requested products
  Future<void> getAllRequestedFeatured() async {
    if (_isDisposed) return;
    state = AsyncValue.loading();

    try {
      List<featureModel?> feature = await ref.read(featureProvider).getAllRequestedFeaturedProducts();
      if (!_isDisposed) {
        state = AsyncValue.data(feature.isEmpty ? [] : feature);
      }
    } catch (e) {
      if (!_isDisposed) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  // For admin
  Future<void> getFeaturedProducts(String category) async {
    if (_isDisposed) return;
    state = AsyncValue.loading();

    try {
      List<featureModel?> feature = await ref.read(featureProvider).getAllFeaturedProducts(category);
      if (!_isDisposed) {
        state = AsyncValue.data(feature.isEmpty ? [] : feature);
      }
    } catch (e) {
      if (!_isDisposed) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  // For dashboardView - gets featured products by category
  Future<void> getAllFeaturedProducts(String category) async {

    state = AsyncValue.loading();

    try {
      List<featureModel?> feature = await ref.read(featureProvider).getAllFeaturedProducts(category);

        state = AsyncValue.data(feature.isEmpty ? [] : feature);

    } catch (e) {
      if (!_isDisposed) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  Future<void> deleteFeatureProduct(String featureId, String sellerId, BuildContext context) async {
    try {
      // Delete the featured product
      await ref.read(featureProvider).deleteFeaturedProducts(featureId);

      // Check which screen we're on and refresh accordingly
      if (!_isDisposed) {
        // Determine which refresh method to call based on the current context
        final currentRoute = ModalRoute.of(context)?.settings.name;

        if (currentRoute == routesName.activefeature) {
          // We're on the Featured Products screen
          await getAllFeaturedProducts('All');
          await getFeaturedProducts('All');
        } else {
          // We're on the Requests screen
          await getAllRequestedFeatured();
        }

        Utils.toastMessage("Product removed successfully");
      }
    } catch (e) {
      if (!_isDisposed) {
        Utils.toastMessage("Failed to delete product: ${e.toString()}");
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }
}