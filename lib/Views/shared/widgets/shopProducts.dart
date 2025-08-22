import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/utils.dart';

class shopProducts extends ConsumerStatefulWidget {
  String shopId;
  String id;//userId
  shopProducts({required this.shopId,required this.id});

  @override
  ConsumerState<shopProducts> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<shopProducts> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Add this to ensure fresh data
      ref.invalidate(sharedProductViewModelProvider);
      await ref.read(sharedProductViewModelProvider.notifier).getShopProduct(widget.shopId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      ref.invalidate(sharedProductViewModelProvider);
      await ref.read(sharedProductViewModelProvider.notifier).getShopProduct(widget.shopId);
      return true;
    });
  }


  @override
  Widget build(BuildContext context) {
    final productState =ref.watch(sharedProductViewModelProvider);
    return productState.when(
      loading: () =>  Center(
        child: SizedBox(
          height: 100.h,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.h),
              child: Text(
                "No products available.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  if (product != null) {
                    Navigator.pushNamed(
                      context,
                      routesName.productdetail,
                      arguments: {
                        'id': int.tryParse(widget.id),
                        'productId':product.id,
                        'product': product
                      },
                    );
                  } else {
                    Utils.toastMessage("Product information is not available");
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  width: 170.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Container with fixed aspect ratio
                      AspectRatio(
                        aspectRatio: 1, // Square aspect ratio (1:1)
                        child: Stack(
                          children: [
                            // Image with proper sizing
                            if (product?.images != null && product!.images!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  product.images!.first.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image_not_supported),
                                      ),
                                ),
                              )
                            else
                              Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              ),

                            // Wishlist Button
                            Positioned(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: Appcolors.baseColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(0),
                                            bottomLeft: Radius.circular(20)
                                        )
                                    ),
                                    child:  WishlistButton(color: Appcolors.whiteSmoke, userId: widget.id,productId:int.tryParse(product!.id!.toString())!),

                                  ),
                                )
                            ),
                          ],
                        ),
                      ),

                      // Product Info
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, left: 4.w),
                        child: Text(
                          product?.name ?? "Unknown",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 4.w, top: 4.h),
                        child: Text(
                          "Rs.${product?.price ?? 0}",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );

      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
