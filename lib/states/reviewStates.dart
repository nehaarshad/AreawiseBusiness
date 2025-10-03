import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categoryModel.dart';
import '../models/imageModel.dart';
import '../models/reviewsModel.dart';

class reviewState {
  final List<Reviews?> reviews;
  late List<dynamic> images;
  final List<ImageModel> existingImages;
  final bool isLoading;

  reviewState({
    this.reviews = const [],
    this.images = const [],
    this.existingImages = const [],
    this.isLoading = false,
  });

  reviewState copyWith({
    List<Reviews?>? review,
    List<dynamic>? images,
    List<ImageModel>? existingImages,
    bool? isLoading,
  }) {
    return reviewState(
      reviews: review ?? this.reviews,
      images: images ?? this.images,
      existingImages: existingImages ?? this.existingImages,
       isLoading: isLoading ?? this.isLoading,
    );
  }
}
