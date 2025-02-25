import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/buyerViewModels/WishListViewModel.dart';
import '../../../core/utils/utils.dart';
import 'package:flutter/material.dart';

class WishlistButton extends ConsumerWidget {
  final String userId;
  final ProductModel product;

  WishlistButton({required this.userId, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        await ref.read(wishListViewModelProvider(product.id.toString()).notifier).addToWishList(userId, product.id!);
        await ref.read(wishListViewModelProvider(product.id.toString()).notifier).getUserWishList(userId);
        Utils.toastMessage("Added Successfully!");
      },
      icon: Icon(
        Icons.favorite_border_outlined,
        color: Colors.red,
      ),
    );
  }
}