import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/repositories/adRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../models/featureModel.dart';
import '../../repositories/featuredRepositories.dart';
import '../SharedViewModels/AdViewModel.dart';
import '../SharedViewModels/featuredProductViewModel.dart';
import '../adminViewModels/AdStates.dart';
import 'featureStates.dart';

final createfeatureProductViewModelProvider = StateNotifierProvider<CreateFeatureProductViewModel, createFeatureProductState>((ref) {
  return CreateFeatureProductViewModel(ref);
});

class CreateFeatureProductViewModel extends StateNotifier<createFeatureProductState> {
  final Ref ref;
  CreateFeatureProductViewModel(this.ref) : super(createFeatureProductState(isLoading: false));

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
}