import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/colors.dart';
import 'loadingState.dart';


class usedItems extends ConsumerStatefulWidget {
  int userid;
  usedItems({required this.userid});

  @override
  ConsumerState<usedItems> createState() => _usedProductsViewState();
}

class _usedProductsViewState extends ConsumerState<usedItems> {
  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final productState = ref.watch(sharedProductViewModelProvider);

        return productState.when(
          loading: () => const ShimmerListTile(),

          data: (products) {
            if (products.isEmpty) {
              return const Center(child: Text("No Products available."));
            }
            final filteredProducts = products.where((product) => product?.condition == "Used").toList();

            if(filteredProducts.isEmpty){
              return SizedBox(height:50.h,child: Center(child: Text("No Products Available!")));
            }
            return SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                      onTap: () {
                        if (product != null) {
                          Navigator.pushNamed(
                            context,
                            routesName.productdetail,
                            arguments:  {
                              'id': widget.userid,
                              'productId':product.id,
                              'product': product
                            },
                          );
                        }
                      },
                      child: Container(

                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        width: 168.w,
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
                                      child: CachedNetworkImage(
                                       imageUrl:  product.images!.first.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorWidget: (context, error, stackTrace) =>
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
                                          child:  WishlistButton(color: Appcolors.whiteSmoke, userId: widget.userid.toString(),productId:product!.id!),

                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
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
                              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                              child:  Row(
                                children: [
                                  Text(
                                    "${product.ratings}",
                                    style: TextStyle(
                                        color: Appcolors.blackColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Icon(Icons.star,size: 14.h,color: Appcolors.blackColor,),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "(${product.reviews?.length} reviews)",
                                    style: TextStyle(
                                      color: Colors.grey, // Different color for strikethrough
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400, // Match text color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            product.onSale! ?
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                              child:  Row(
                                children: [
                                  Text(
                                    "Rs.",
                                    style: TextStyle(
                                        color: Appcolors.baseColorLight30,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    "${product.saleOffer?.price ?? 0}", // Use ?. instead of !.
                                    style: TextStyle(
                                        color: Appcolors.baseColorLight30,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "Rs.${product.price ?? 0}",
                                    style: TextStyle(
                                      color: Colors.grey, // Different color for strikethrough
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.grey, // Match text color
                                    ),
                                  ),

                                ],
                              ),
                            )
                                :
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                              child: Row(
                                children: [
                                  Text(
                                    "Rs.",
                                    style: TextStyle(
                                        color: Appcolors.baseColorLight30,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    "${product.price ?? 0}",
                                    style: TextStyle(
                                        color: Appcolors.baseColorLight30,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  );
                },
              ),
            );
          },
          error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        );
      },
    );
  }


}