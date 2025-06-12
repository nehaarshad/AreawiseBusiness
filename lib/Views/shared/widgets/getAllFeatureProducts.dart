import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../../core/utils/utils.dart';

class AllFeaturedProducts extends ConsumerWidget {
  final int userid;
  const AllFeaturedProducts({required this.userid, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the featured products state
    final featuredProducts = ref.watch(featureProductViewModelProvider(userid.toString()));

    return featuredProducts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text("No Featured Products available."));
        }
        return SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final featuredProduct = products[index];
              return GestureDetector(
                onTap: () {
                  print(featuredProduct!.product!);
                  if (featuredProduct?.product != null) {
                    Navigator.pushNamed(
                      context,
                      routesName.productdetail,
                      arguments: {
                        'id': userid,
                        'product': featuredProduct.product!
                      },
                    );
                  } else {
                    Utils.toastMessage("Product information is not available");
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: Container(
                    width: 170.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: featuredProduct?.product?.images != null && featuredProduct!.product!.images!.isNotEmpty
                              ? Image.network(
                            featuredProduct.product!.images!.first.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                              : const Icon(Icons.image_not_supported),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            featuredProduct?.product?.name ?? "Unknown",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                          child: Text(
                            "\$${featuredProduct?.product?.price ?? 0}",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
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