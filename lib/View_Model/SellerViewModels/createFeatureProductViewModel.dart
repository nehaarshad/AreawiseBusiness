import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/repositories/adRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../models/ProductModel.dart';
import '../../models/featureModel.dart';
import '../../repositories/featuredRepositories.dart';
import '../../repositories/onSaleRepository.dart';
import '../../repositories/product_repositories.dart';
import '../SharedViewModels/getOnSaleProducts.dart';
import '../adminViewModels/AdViewModel.dart';
import '../SharedViewModels/featuredProductViewModel.dart';
import '../adminViewModels/AdStates.dart';
import 'SellerOnSaleProductViewModel.dart';
import 'featureStates.dart';

final createfeatureProductViewModelProvider = StateNotifierProvider.family<CreateFeatureProductViewModel, createFeatureProductState,String>((ref,id) {
  return CreateFeatureProductViewModel(ref,id);
});

class CreateFeatureProductViewModel extends StateNotifier<createFeatureProductState> {
  final Ref ref;
  final String id;
  CreateFeatureProductViewModel(this.ref,this.id) : super(createFeatureProductState(isLoading: false)){
    getUserProducts();
  }

  void resetState() {
    getUserProducts();
    state=state.copyWith(selectedPrduct: null,isCustomProduct: false,isLoading: false,expirationDateTime: null);
  }

  Future<void> getUserProducts() async {
    try {
      state = state.copyWith(isLoading: true);
      final products = await ref.read(productProvider).getUserProduct(id);

      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error loading userProducts: $e');
    }
  }


  void setProduct(ProductModel? product) {
    state = state.copyWith(
      selectedPrduct: product,
    );
  }

  void toggleCustomProduct(bool value) {
    state = state.copyWith(
      isCustomProduct: value,
      selectedPrduct: value ? null : state.selectedProduct,
    );
  }

  Future<void> Cancel(String userId,BuildContext context) async{
    resetState();
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
  }

  void showRequestSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Request sent successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectExpirationDateTime(DateTime dateTime) async {
    state = state.copyWith(expirationDateTime: dateTime);
  }

  // For seller
  Future<void> createFeatureProduct(String sellerId, int productID, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      final reqData = {
        'productID': productID,
      };

      await ref.read(featureProvider).createProductFeatured(sellerId, reqData);

      // Show success dialog
      showRequestSentDialog(context);

      // Refresh only seller's featured products
      final viewModel = ref.read(featureProductViewModelProvider(sellerId).notifier);
      await viewModel.getUserFeaturedProducts(sellerId);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      Utils.toastMessage("Error creating feature request: ${e.toString()}");
      print(e);
    }
  }

  // For admin
  Future<void> updateFeatureProduct(String featureId, String sellerId, Map<String, dynamic> data, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      await ref.read(featureProvider).updateFeaturedProducts(featureId, data);

      // Determine which screen we're on and refresh accordingly
      final currentRoute = ModalRoute.of(context)?.settings.name;
      final viewModel = ref.read(featureProductViewModelProvider(sellerId).notifier);

      if (currentRoute == routesName.activefeature) {
        // We're on the Featured Products screen
        await viewModel.getAllFeaturedProducts('All');
      } else {
        // We're on the Requests screen
        await viewModel.getAllRequestedFeatured();
      }

      state = state.copyWith(isLoading: false);
      Utils.toastMessage("Status Updated!");
    } catch (e) {
      state = state.copyWith(isLoading: false);
      Utils.toastMessage("Error updating feature: ${e.toString()}");
      print(e);
    }
  }


  Future<void> addOnSale(String id,int discount,BuildContext context) async {
    try {

      final productId = state.isCustomProduct ? null : state.selectedProduct?.id;
      if(productId == null){
        Utils.flushBarErrorMessage("Please select product", context);
        return;
      }

      if (state.expirationDateTime == null) {
        Utils.flushBarErrorMessage("Please select expiration date and time", context);

        return;
      }

      final data={
        'discountPercent':discount,
        'expire_at':state.expirationDateTime?.toIso8601String(),
        'productId':productId
      };

      state =state.copyWith(isLoading: true);
      await ref.read(onSaleProvider).addOnSaleProduct(data,this.id);
      resetState();
      state =state.copyWith(isLoading: false,selectedPrduct: null,isCustomProduct: false);
      ref.invalidate(sellerOnSaleProductViewModelProvider(this.id));
      ref.invalidate(onSaleViewModelProvider);
      await ref.read(sellerOnSaleProductViewModelProvider(this.id).notifier).getOnSaleProduct(this.id);
      await ref.read(onSaleViewModelProvider.notifier).getonSaleProduct("All");
      Navigator.pop(context);
    } catch (e) {
      Utils.flushBarErrorMessage("  Request Failed!", context);
      print(e);
      Navigator.pop(context);
    }
  }

}