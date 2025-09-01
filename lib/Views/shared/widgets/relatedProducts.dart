import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/utils.dart';

class RelatedProducts extends ConsumerStatefulWidget {
  final int userid;
  final String? category;

  const RelatedProducts({
    required this.userid,
    required this.category,
    Key? key
  }) : super(key: key);

  @override
  ConsumerState<RelatedProducts> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends ConsumerState<RelatedProducts> {
  @override
  void initState() {
    super.initState();
    // Fetch products by category when widget initializes
    if (widget.category != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sharedProductViewModelProvider.notifier)
            .getAllProduct(widget.category!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the product state
    final productState = ref.watch(sharedProductViewModelProvider);

    return productState.when(
      loading: () =>  Center(
        child: SizedBox(
          height: 100.h,
          child: Center(child: LinearProgressIndicator(color: Appcolors.baseColor,)),
        ),
      ),
      data: (products) {
        // Filter products to show only ones in the same category
        final relatedProducts = products.where((product) =>
        product?.category?.name == widget.category).toList();

        if (relatedProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.h),
              child: Text(
                "No related products available.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return SizedBox(
          height: 220.h,
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
                        arguments:  {
                          'id': widget.userid,
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
                                      child:  WishlistButton(color: Appcolors.whiteSmoke, userId: widget.userid.toString(),productId:product!.id!),

                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                        if(product.onSale!)
                          Row(
                            children: [
                              Icon(Icons.discount_outlined,color: Appcolors.baseColor,size: 14.h,),
                              SizedBox(width: 4.w,),
                              Text("onSale",style: TextStyle(fontWeight: FontWeight.w500,fontSize:14.sp,color: Appcolors.baseColor),),
                            ],
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
                                "${product.price ?? 0}",
                                style: TextStyle(
                                  color: Colors.grey, // Different color for strikethrough
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey, // Match text color
                                ),
                              ),
                              SizedBox(width: 3.w), // Slightly more spacing

                              Text(
                                "${product.saleOffer?.price ?? 0}", // Use ?. instead of !.
                                style: TextStyle(
                                    color: Appcolors.baseColorLight30,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500
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
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.0.w,),
                          child:   Row(

                            children: [
                              Icon(Icons.delivery_dining_sharp,color: Colors.grey,size: 15.h,),
                              SizedBox(width: 3.w,),
                              Text(
                                "${product.shop!.deliveryPrice ?? 0}",
                                style: TextStyle(
                                    color: Colors.grey,
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
      error: (err, stack) => Center(child: Text('Error while loading')),
    );
  }
}