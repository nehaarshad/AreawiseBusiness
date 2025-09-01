import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../core/utils/colors.dart';

class UserFeaturedProducts extends ConsumerStatefulWidget {
  final int sellerId;

  const UserFeaturedProducts({
    Key? key,
    required this.sellerId,
  }) : super(key: key);

  @override
  ConsumerState<UserFeaturedProducts> createState() => _UserFeaturedProductsState();
}

class _UserFeaturedProductsState extends ConsumerState<UserFeaturedProducts> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid calling setState during build
    Future.microtask(() {
      if (mounted) {
        ref.read(featureProductViewModelProvider(widget.sellerId.toString()).notifier)
            .getUserFeaturedProducts(widget.sellerId.toString()); // Changed from loadUserFeaturedProducts to getUserFeaturedProducts
      }
    });
  }

  Future<void> deleteFeatured(String featureId) async {
    // Check if the widget is still mounted before showing dialog
    if (!mounted) return;

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Are you sure you want to remove this featured product?", style: TextStyle(fontSize: 20.sp)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Use dialogContext
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                // Pop the dialog first
                Navigator.of(dialogContext).pop();

                // Check if still mounted before proceeding
                if (!mounted) return;

                try {
                  // Show loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(width: 16.w),
                          Text("Removing featured product...")
                        ],
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Delete the product
                  await ref.read(featureProductViewModelProvider(widget.sellerId.toString()).notifier)
                      .deleteFeatureProduct(featureId, widget.sellerId.toString(), context);

                  // Check if still mounted before showing success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Product removed successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Refresh the list
                    ref.refresh(featureProductViewModelProvider(widget.sellerId.toString()));
                  }
                } catch (e) {
                  // Check if still mounted before showing error
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to remove product: ${e.toString()}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("Remove", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuredProductsState = ref.watch(featureProductViewModelProvider(widget.sellerId.toString()));

    return Scaffold(
      backgroundColor: Appcolors.whiteSmoke,
      appBar: AppBar(
        title: Text(
            "My Featured Products",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            featuredProductsState.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: LinearProgressIndicator(color: Appcolors.baseColor),
                ),
              ),
              data: (featuredProducts) {
                if (featuredProducts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(Icons.star_border, size: 48.h, color: Colors.grey),
                          SizedBox(height: 16.h),
                          Text("No featured products yet"),
                          SizedBox(height: 8.h),
                          Text(
                            "Request to feature your products for better visibility",
                            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    final featuredProduct = featuredProducts[index];
                    final product = featuredProduct!.product;
                    final status = featuredProduct.status;

                    // Get status color
                    Color statusColor;
                    switch (status) {
                      case 'Featured':
                        statusColor = Colors.orange;
                        break;
                      case 'Requested':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(12),
                            leading: Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: (product?.images != null &&
                                  product!.images!.isNotEmpty &&
                                  product.images!.first.imageUrl != null)
                                  ? Image.network(
                                product.images!.first.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              )
                                  :  Icon(Icons.image_not_supported, size: 40.h),
                            ),
                            title: Text(
                              product?.name ?? 'No Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                        border: Border.all(color: statusColor, width: 0.5.w),
                                      ),
                                      child: Text(
                                        status ?? 'Unknown',
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (featuredProduct.expireAt != null) ...[
                                  SizedBox(width: 8.w),
                                  Icon(Icons.timer_outlined, size: 12.h, color: Colors.grey),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Expires: ${_formatDate(DateTime.parse(featuredProduct.expireAt!))}",
                                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                                  ),
                                ],
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (featuredProduct.id != null) {
                                  deleteFeatured(featuredProduct.id.toString());
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48.h),
                      SizedBox(height: 16.h),
                      Text('Error loading featured products: ${error.toString()}'),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            ref.refresh(featureProductViewModelProvider(widget.sellerId.toString()));
                            ref.read(featureProductViewModelProvider(widget.sellerId.toString()).notifier)
                                .getUserFeaturedProducts(widget.sellerId.toString()); // Changed this line as well
                          }
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}