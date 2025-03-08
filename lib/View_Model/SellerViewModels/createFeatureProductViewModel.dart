import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/repositories/adRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/featureModel.dart';
import '../../repositories/featuredRepositories.dart';
import '../SharedViewModels/AdViewModel.dart';
import '../SharedViewModels/featuredProductViewModel.dart';
import 'AdStates.dart';
import 'featureStates.dart';

final createfeatureProductViewModelProvider = StateNotifierProvider<createfeatureProductViewModel, createFeatureProductState>((ref,) {
  return createfeatureProductViewModel(ref);
});

class createfeatureProductViewModel extends StateNotifier<createFeatureProductState> {
  final Ref ref;
  createfeatureProductViewModel(this.ref) : super(createFeatureProductState(isLoading: false));

  Future<void> selectExpirationDateTime(DateTime dateTime) async{
    state = state.copyWith(expirationDateTime: dateTime);
  }

  ///for seller
  Future<void> createFeatureProduct(String sellerId,int productID,BuildContext context) async {
    try {
      if (state.expirationDateTime == null) {
        Utils.flushBarErrorMessage("Please Complete missing Fields", context);
        return;
      }
      state = state.copyWith(isLoading: true);

      final reqData = {
        'productID':productID,
        'expire_at': state.expirationDateTime!.toIso8601String(),  ///YYYY-MM-DDTHH:mm:ss.mmm+00:00
      };
      print('productID: ${reqData['productID'].runtimeType} expire_at:${reqData['expire_at'].runtimeType}');
      final response = await ref.read(featureProvider).createProductFeatured(sellerId,reqData);
      try {
        // Invalidate the provider to refresh the product list
        ref.invalidate(featureProductViewModelProvider);
        await ref.read(featureProductViewModelProvider.notifier).getUserFeaturedProducts(sellerId);
        await ref.read(featureProductViewModelProvider.notifier).getAllRequestedFeatured();
        await ref.read(featureProductViewModelProvider.notifier).getAllFeaturedProducts();
      } catch (innerError) {
        print("Error refreshing product lists: $innerError");
        // Continue with success flow despite refresh errors
      }
      state = state.copyWith(isLoading: false);

      Utils.toastMessage("Request Sent!");

    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    }
  }

  ///for admin  //fetch seller id from featuredRequestProduct
  Future<void> updateFeatureProduct(String featureId,String sellerId, String status,BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await ref.read(featureProvider).updateFeaturedProducts(featureId, status);
      try {
        // Invalidate the provider to refresh the product list
        ref.invalidate(featureProductViewModelProvider);
        await ref.read(featureProductViewModelProvider.notifier).getUserFeaturedProducts(sellerId);
        await ref.read(featureProductViewModelProvider.notifier).getAllRequestedFeatured();
        await ref.read(featureProductViewModelProvider.notifier).getAllFeaturedProducts();
      } catch (innerError) {
        print("Error refreshing product lists: $innerError");
        // Continue with success flow despite refresh errors
      }
      state = state.copyWith(isLoading: false);

      Utils.toastMessage("Status Updated!");
      Navigator.pop(context);

    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    }
  }

}