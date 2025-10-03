import 'dart:io';
import 'package:ecommercefrontend/states/reviewStates.dart';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/models/reviewsModel.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../core/utils/notifyUtils.dart';
import '../../repositories/reviewsRepository.dart';

final reviewsModelProvider = StateNotifierProvider.family<reviewsModel, reviewState,String>((ref,id) {
  return reviewsModel(ref,id);
});

class reviewsModel extends StateNotifier<reviewState> {
  final Ref ref;
  final String id;
  reviewsModel(this.ref,this.id) : super(reviewState());

  final ImagePicker pickImage = ImagePicker();

  Future<void> pickImages(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true); // Show loading while processing
      final List<XFile> pickedFiles = await pickImage.pickMultiImage();
      if (pickedFiles.isNotEmpty && state.images.length + pickedFiles.length <= 3) {
        final List<File> compressedImages = [];

        // Compress each selected image
        for (final xFile in pickedFiles) {
          final originalFile = File(xFile.path);
          final compressedFile = await compressImage(originalFile,context);

          if (compressedFile != null) {
            compressedImages.add(compressedFile);
            print('Compressed image: ${originalFile.lengthSync()} -> ${compressedFile.lengthSync()} bytes');
          }
        }

        final newImages = [...state.images, ...compressedImages];
        state = state.copyWith(images: newImages, isLoading: false);
        print('Images updated, total: ${state.images.length}'); // Debug

      }
      else{
        Utils.flushBarErrorMessage("Select only 3 images", context);
        return;
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void resetState(){
    state=state.copyWith(isLoading: false,images: []);
  }
  // Compress image before adding to state
  Future<File?> compressImage(File file,BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85, // Match backend optimization
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      print('Error picking images: $e');
      state = state.copyWith(isLoading: false);
      Utils.flushBarErrorMessage("Error while selecting images", context);
    }
  }

  void removeImage(int index) {
    final newImages = List<File>.from(state.images)
      ..removeAt(index); //[..] Cascade or Chaining Opertor in list
    state = state.copyWith(images: newImages);
    print('Image removed, new image count: ${state.images.length}'); // Debug
  }

  Future<void> addProductReviews(String id,int productId,int Rating,String comment) async {
    try {

     final data= {
        "productId":productId,
    "rating":Rating,
    "comment":comment
  };

      Reviews review = await ref.read(reviewsProvider).addReview(data, id,state.images.whereType<File>().toList());
   getProductReviews(productId.toString());
     resetState();

    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getProductReviews(String id) async {
    try {
      List<Reviews?> review = await ref.read(reviewsProvider).getReview( id);
      state = state.copyWith(review: review.isEmpty ? [] : review,isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteProductReview(String id,String productId) async {
    try {
      await ref.read(reviewsProvider).deleteReview(id);
      getProductReviews(productId);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

}