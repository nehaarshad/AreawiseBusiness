import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../View_Model/SharedViewModels/searchProductViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/searchBar.dart';
import '../widgets/wishListButton.dart';

class searchView extends ConsumerStatefulWidget {
  final String search;
  final int userid;
  searchView({super.key,required this.search,required this.userid});

  @override
  ConsumerState<searchView> createState() => _searchViewState();
}

class _searchViewState extends ConsumerState<searchView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(searchProductViewModelProvider.notifier).searchProduct(widget.search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(top: 18.0.h,left: 8.w,right: 8.w,bottom: 5.h),
          child: Consumer(
            builder: (context, ref, child) {
              final productState = ref.watch(searchProductViewModelProvider);

              return productState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text("No Products available."));
                  }
                  return SizedBox(
                    height: 700.h,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 15.h,
                        childAspectRatio: 0.75, // Adjusted to prevent overflow
                      ),
                      itemCount: products.length,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 4.w), // Added padding instead of individual margins
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
                            margin: EdgeInsets.symmetric(horizontal: 4.w), // Reduced margin
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
                                            color: Appcolors.blueColor,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.r),
                                            ),
                                          ),
                                          child: WishlistButton(
                                            color: Appcolors.whiteColor,
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
                                      Text(
                                        "Rs.${product.price ?? 0}",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14.sp,
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
          ),
        ),
      ),
    );
  }
}