import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/buyerViewModels/WishListViewModel.dart';
import '../../../core/utils/notifyUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class WishlistButton extends ConsumerWidget {
  final String userId;
  final int productId;
  final color;

  const WishlistButton({Key? key, required this.userId,required this.color, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the wishlist provider to detect changes in the wishlist
    final wishlistState = ref.watch(wishListViewModelProvider(userId));

    // Check if the current product is in the wishlist
    bool isInWishlist = false;

    wishlistState.whenData((wishlistItems) {
      // Check if the product exists in the wishlist
      isInWishlist = wishlistItems.any((item) =>
      item?.productId == productId || item?.product?.id == productId
      );
    });

    return IconButton(
      onPressed: () async {
        if (isInWishlist) {
          // If product is already in wishlist, remove it
          await ref.read(wishListViewModelProvider(userId).notifier)
              .deleteItemFromWishList(userId.toString(), productId!);
          Utils.toastMessage("Removed from wishlist!");
        } else {
          // If product is not in wishlist, add it
          await ref.read(wishListViewModelProvider(userId).notifier)
              .addToWishList(userId, productId!);
          Utils.toastMessage("Added to wishlist!");
        }

        // Refresh the wishlist
        await ref.read(wishListViewModelProvider(userId).notifier)
            .getUserWishList(userId);
      },
      icon: Icon(
        // Change icon based on whether product is in wishlist
        isInWishlist ? Icons.favorite : Icons.favorite_border_outlined,
        color: isInWishlist ? Colors.red : color,
        size: 18.h,
      ),
    );
  }
}