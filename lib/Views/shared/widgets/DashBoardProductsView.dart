import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/utils.dart';


class AllProducts extends ConsumerStatefulWidget {
  int userid;
  AllProducts({required this.userid});

  @override
  ConsumerState<AllProducts> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<AllProducts> {
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
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (products) {
            if (products.isEmpty) {
              return const Center(child: Text("No Products available."));
            }
            return SizedBox(
              height: 480.h,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 0.70,
                ),
                itemCount: products.length,
                physics: const ScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, index) {
                  final product = products[index];
                  if (product == null) return const SizedBox.shrink();

                  return GestureDetector(
                    onTap: () {
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
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 170.w,// Reduced margin
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Prevent column from expanding
                        children: [
                          // Image Section
                          AspectRatio(
                            aspectRatio: 1,
                            child: Stack(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: product.images?.isNotEmpty ?? false
                                      ? Image.network(
                                    product.images!.first.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (_, __, ___) =>
                                        Container(
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image_not_supported),
                                        ),
                                  )
                                      : Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),

                                // Wishlist Button
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    height: 30.h,
                                    width: 35.w,
                                    decoration: BoxDecoration(
                                      color: Appcolors.baseColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20.r),
                                      ),
                                    ),
                                    child: WishlistButton(
                                      color: Appcolors.whiteSmoke,
                                      userId: widget.userid.toString(),
                                      productId: product.id!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Product Info
                          Padding(
                            padding: EdgeInsets.only(top: 4.h, left: 4.w, right: 4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  product.name ?? "Unknown",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.h),
                                product.onSale! ? Padding(
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
                                ) : Padding(
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

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
                                      Row(

                                        children: [
                                          Text(
                                            "${product.ratings ?? 0}",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),

                                          SizedBox(width: 3.w,),
                                          Icon(Icons.star,color: Appcolors.baseColorLight30,size: 15.h,),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
          error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        );
      },
    );
  }


}