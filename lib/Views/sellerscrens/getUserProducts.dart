import 'package:ecommercefrontend/Views/shared/widgets/SetDateTime.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/productViewModels.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/colors.dart';

class getSellerProductView extends ConsumerStatefulWidget {
  final String sellerId;
  getSellerProductView({required this.sellerId});

  @override
  ConsumerState<getSellerProductView> createState() => _getSellerProductView();
}

class _getSellerProductView extends ConsumerState<getSellerProductView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(sharedProductViewModelProvider.notifier).getUserProduct(widget.sellerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(sharedProductViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              "My Products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.h)
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            return productState.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: LinearProgressIndicator(color: Appcolors.baseColor),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No Products Available"),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    if (product == null) {
                      return const SizedBox.shrink();
                    }
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            routesName.productdetail,
                            arguments: {
                              'id': int.tryParse(widget.sellerId),
                              'productId':product.id,
                              'product': product
                            },
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: (product.images != null &&
                                    product.images!.isNotEmpty &&
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
                                product.name ?? 'No Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                product.category?.name ?? 'No Category',
                                style:  TextStyle(fontSize: 12.h),
                              ),
                            ),
                            Divider(height: 1.h),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 12.0.h, vertical: 8.0.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            routesName.sEditProduct,
                                            arguments: product,
                                          );
                                        },
                                        icon: Icon(Icons.edit, color: Appcolors.baseColor),
                                        tooltip: "Edit Product",
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          if (product.id != null) {
                                            await ref.read(sharedProductViewModelProvider.notifier)
                                                .deleteProduct(product.id.toString(), widget.sellerId);
                                          }
                                        },
                                        tooltip: "Delete Product",
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await ref.read(createfeatureProductViewModelProvider(widget.sellerId).notifier)
                                          .createFeatureProduct(widget.sellerId,product.id!,context);
                                    },
                                    icon: Icon(Icons.star, size: 16.h),
                                    label: Text("Request to Feature"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Appcolors.baseColor,
                                      foregroundColor: Colors.white,
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
                );
              },
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48.h),
                      SizedBox(height: 16.h),
                      Text('Error loading products: ${error.toString()}'),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(sharedProductViewModelProvider.notifier).getUserProduct(widget.sellerId);
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}