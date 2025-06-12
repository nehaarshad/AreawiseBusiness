import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';

class shopProducts extends ConsumerStatefulWidget {
  String shopId;
  shopProducts({required this.shopId});

  @override
  ConsumerState<shopProducts> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<shopProducts> {

  @override
  void initState() {
    super.initState();
    // Fetch all products when the widget is first created
    ref.read(sharedProductViewModelProvider.notifier).getShopProduct(widget.shopId);
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
                  Navigator.pushNamed(
                    context,
                    routesName.productdetail,
                    arguments: {'id': int.tryParse(widget.shopId), 'product': product},
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: Container(
                    width: 170.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child:
                          product?.images != null &&
                              product!.images!.isNotEmpty
                              ? Image.network(
                            product.images!.first.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                              : const Icon(Icons.image_not_supported),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product?.name ?? "Unknown",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                          child: Text(
                            "\$${product?.price ?? 0}",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        SizedBox(height: 20.h),
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
