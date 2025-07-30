import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/utils.dart';


class AllFeaturedProducts extends ConsumerStatefulWidget {
  int userid;
  AllFeaturedProducts({required this.userid});

  @override
  ConsumerState<AllFeaturedProducts> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<AllFeaturedProducts> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted ) {

        ref.read(featureProductViewModelProvider(widget.userid.toString()).notifier).getAllFeaturedProducts('All');
      }
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(featureProductViewModelProvider(widget.userid.toString()).notifier).getAllFeaturedProducts('All');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(featureProductViewModelProvider(widget.userid.toString()));
    return productState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (products) {
        if (products.isEmpty) {
          return SizedBox(child: const Center(child: Text("No Featured Products available.")));
        }
        return SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final featuredProduct = products[index];
              final product = featuredProduct?.product;
              print("featured Product ${product?.id}");
              if (product == null || product.id == null) {
                return const SizedBox();
              }
              return GestureDetector(
                onTap: () {
                  print(" on tap featured Product ${product?.id}");

                    Navigator.pushNamed(
                      context,
                      routesName.productdetail,
                      arguments:  {
                        'id': widget.userid,
                        'productId':product.id,
                        'product': product
                      },
                    );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.h),
                  width: 170.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     AspectRatio(
                       aspectRatio: 1,
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
                                       color: Appcolors.blueColor,
                                       borderRadius: BorderRadius.only(
                                           topRight: Radius.circular(0),
                                           bottomLeft: Radius.circular(20)
                                       )
                                   ),
                                   child:  WishlistButton(color: Appcolors.whiteColor, userId: widget.userid.toString(),productId:product.id!),

                                 ),
                               )
                           ),
                         ],
                       ),
                     ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding:  EdgeInsets.only(top: 0.0.h,left: 6.h),
                            child:  Text(
                              product.name ?? "Unknown",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // WishlistButton( userId: widget.userid.toString(),product:product!),

                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                            child: Text(
                              "Rs.${product.price ?? 0}",
                              style:  TextStyle(color: Colors.green,fontSize: 13.h),
                            ),
                          ),
                        ],
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


