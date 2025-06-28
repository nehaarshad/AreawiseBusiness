import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/repositories/adRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../SharedViewModels/AdViewModel.dart';
import 'AdStates.dart';

final createAdsViewModelProvider = StateNotifierProvider<createAdsViewModel, CreateAdState>((ref,) {
  return createAdsViewModel(ref);
});

class createAdsViewModel extends StateNotifier<CreateAdState> {
  final Ref ref;
  createAdsViewModel(this.ref) : super(CreateAdState(isLoading: false));

  File? uploadimage;
  final ImagePicker pickimage = ImagePicker();


  void resetState() {
    state = CreateAdState(isLoading: false); // Reset to initial state
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final XFile? pickedFiles = await pickimage.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFiles == null) {
        Utils.flushBarErrorMessage("Upload Ad Poster", context);
      }
      else {
        state = state.copyWith(adImage: File(pickedFiles.path));
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void selectExpirationDateTime(DateTime dateTime) {
    state = state.copyWith(expirationDateTime: dateTime);
  }

  Future<void> createAd(String sellerId,BuildContext context) async {
    try {
      if (state.adImage == null || state.expirationDateTime == null) {
        Utils.flushBarErrorMessage("Please Complete missing Fields", context);
        return;
      }
      state = state.copyWith(isLoading: true);

      // Prepare data for ad creation
      final adData = {
        'expire_at': state.expirationDateTime!.toIso8601String(),  ///YYYY-MM-DDTHH:mm:ss.mmm+00:00
      };
      print(adData);
      final response = await ref.read(adProvider).createAd(adData, sellerId, state.adImage);
      try {
        // Invalidate the provider to refresh the product list
        ref.invalidate(AdsViewModelProvider);
        await ref.read(AdsViewModelProvider.notifier).getUserAds(sellerId);
        await ref.read(AdsViewModelProvider.notifier).getAllAds();
      } catch (innerError) {
        print("Error refreshing product lists: $innerError");
        // Continue with success flow despite refresh errors
      }
      state = state.copyWith(isLoading: false);

      Utils.toastMessage("AD Created Successfully!");
      Navigator.pop(context);

    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    }
  }

}