import 'dart:io';

import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/material.dart';

import '../../../models/shopModel.dart';

Widget UpdateImage(dynamic image) {
  if (image is File) {
    // For local files, use Image.file
    return Image.file(
      image,
      fit: BoxFit.cover,
      width: 100,
      height: 100,
    );
  } else if (image is ShopImages || image is ProductImages) {
    // For ShopImages, check if it's a local file or a URL
    if (image.file != null) {
      return Image.file(
        image.file!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }
    else if (image.imageUrl != null) {
      // If the imageUrl is a network URL, use Image.network
      return Image.network(
        image.imageUrl!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.error, color: Colors.red),

      );
    }
  } else if (image is String) {
    // For strings that represent URLs, use Image.network
    return Image.network(
      image,
      fit: BoxFit.cover,
      width: 100,
      height: 100,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.error, color: Colors.red),
    );
  }
  return Icon(Icons.broken_image, size: 100);
}
