import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/repositories/adRepository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../core/utils/dialogueBox.dart';
import 'AdViewModel.dart';
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
    state = CreateAdState(isLoading: false,adImage: null); // Reset to initial state
  }
  Future<File?> compressImage(File file, BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      print('Error compressing image: $e');
      state = state.copyWith(isLoading: false);
      Utils.flushBarErrorMessage("Error compressing image", context);
      return null;
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final XFile? pickedFile = await pickimage.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        Utils.flushBarErrorMessage("Upload Ad Poster", context);
        return;
      }

      // Convert XFile to File
      final File file = File(pickedFile.path);
      final compressedFile = await compressImage(file, context);

      if (compressedFile != null) {
        state = state.copyWith(adImage: compressedFile);
      }
    } catch (e) {
      print('Error picking images: $e');
      Utils.flushBarErrorMessage("Error selecting images", context);
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
        await ref.read(AdsViewModelProvider.notifier).getAllAds();
      } catch (innerError) {
        print("Error refreshing product lists: $innerError");
        // Continue with success flow despite refresh errors
      }
      await DialogUtils.showSuccessDialog(context,"New Advertisement created.");

      resetState();


    } catch (e) {
      state = state.copyWith(isLoading: false);
      await DialogUtils.showErrorDialog(context,"Try Later!");

      print(e);
    }
  }

}