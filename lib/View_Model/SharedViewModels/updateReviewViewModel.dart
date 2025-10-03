import 'dart:io';
import 'package:ecommercefrontend/View_Model/SharedViewModels/ReviewsViewModel.dart';
import 'package:ecommercefrontend/states/reviewStates.dart';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/models/reviewsModel.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../core/utils/notifyUtils.dart';
import '../../models/imageModel.dart';
import '../../repositories/reviewsRepository.dart';

final updateReviewsModelProvider = StateNotifierProvider.family<updateReviewsModel, reviewState,String>((ref,id) {
  return updateReviewsModel(ref,id);
});

class updateReviewsModel extends StateNotifier<reviewState> {
  final Ref ref;
  final String id;
  updateReviewsModel(this.ref,this.id) : super(reviewState());

  final ImagePicker pickImage = ImagePicker();

  void initializeExistingImages(List<ImageModel?> reviewImages) async {
    try {
      state = state.copyWith(isLoading: true);

      final tempDir = await getTemporaryDirectory();
      final List<File> allImageFiles = [];
      final List<ImageModel> existingUrls = [];

      for (final img in reviewImages) {
        if (img?.imageUrl != null) {
          try {
            final response = await http.get(Uri.parse(img!.imageUrl!));
            if (response.statusCode == 200) {
              final file = File(
                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_${img.imageUrl!.split('/').last}',
              );
              await file.writeAsBytes(response.bodyBytes);
              allImageFiles.add(file);
              existingUrls.add(img);
              print('Downloaded existing image: ${img.imageUrl}');
            }
          } catch (e) {
            print('Error downloading image ${img?.imageUrl}: $e');
          }
        } 
      }

      state = state.copyWith(
        images: allImageFiles,
        existingImages: existingUrls,
        isLoading: false,
      );

      print('Initialized ${allImageFiles.length} images as files');
    } catch (e) {
      print('Error initializing existing images: $e');
      state = state.copyWith(isLoading: false);
    }
  }


  Future<void> pickImages(BuildContext context) async {
    try {
      final List<XFile> pickedFiles = await pickImage.pickMultiImage();

      if (pickedFiles.isEmpty) return;

      if (state.images.length + pickedFiles.length > 3) {
        Utils.flushBarErrorMessage("You can only select 3 images total", context);
        return;
      }

      final List<File?> compressedFiles = await Future.wait(
        pickedFiles.map((xFile) async {
          try {
            final File file = File(xFile.path);
            return await compressImage(file, context);
          } catch (e) {
            print('Error processing image: $e');
            return null;
          }
        }),
      );

      // Get successful compressions
      final List<File> successfulCompressions = compressedFiles.whereType<File>().toList();

      // Add new Files to existing list (existing images + new images)
      final List<File> updatedAllImages = [...state.images, ...successfulCompressions];

      state = state.copyWith(images: updatedAllImages);


    } catch (e) {
      print('Error picking images: $e');
      Utils.flushBarErrorMessage("Error selecting images", context);
    }
  }

  void resetState() {
    state = state.copyWith(
      isLoading: false,
      images: [],
      existingImages: [],
    );
  }
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
      ..removeAt(index); //
    state = state.copyWith(images: newImages);
    print('Image removed, new image count: ${state.images.length}'); // Debug
  }

  Future<void> updateProductReviews(String id,String productId,String comment) async {
    try {

      Reviews review = await ref.read(reviewsProvider).updateReview(id, comment,state.images.whereType<File>().toList());
      await ref.read(reviewsModelProvider(this.id).notifier).getProductReviews(productId);
      resetState();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

}