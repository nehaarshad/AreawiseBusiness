import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/colors.dart';

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
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.h,vertical: 8.h),
                  width: 170.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child:product?.images != null && product!.images!.isNotEmpty
                                  ? Image.network(
                                product!.images!.first.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                                  : const Icon(Icons.image_not_supported),


                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding:  EdgeInsets.only(top: 0.0.h,left: 6.h),
                            child: Text(
                              product?.name ?? "Unknown",
                              style: const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                          // WishlistButton( userId: widget.userid.toString(),product:product!),

                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                            child: Text(
                              "Rs.${product?.price ?? 0}",
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
