import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/CapitalizesFirst.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/SellerOnSaleProductViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/loadingState.dart';

class Onsaleproducts extends ConsumerStatefulWidget {
  final int userId;
  const Onsaleproducts({super.key,required this.userId});

  @override
  ConsumerState<Onsaleproducts> createState() => _OnsaleproductsState();
}

class _OnsaleproductsState extends ConsumerState<Onsaleproducts> {
  @override
  Widget build(BuildContext context) {

    final productState = ref.watch(sellerOnSaleProductViewModelProvider(widget.userId.toString()));
    return Scaffold(
      appBar: AppBar(
       actions: [ Padding(
         padding: const EdgeInsets.all(10.0),
         child: InkWell(
           onTap:()async{
             Navigator.pushNamed(
               context,
               routesName.addToSale,
               arguments: widget.userId,
             );
           },
           child: Container(
             height: 25.h,
             width: 150.w,
             decoration: BoxDecoration(
               color: Appcolors.whiteSmoke,
               borderRadius: BorderRadius.circular(15.r),
               border: Border.all(  // Use Border.all instead of boxShadow for borders
                 color: Appcolors.baseColor,
                 width: 1.0,  // Don't forget to specify border width
               ),
             ),
             child: Center(
               child: Text(
                 "Create New Sale",
                 style: TextStyle(
                   color: Appcolors.baseColor,
                   fontWeight: FontWeight.bold,
                   fontSize: 15.sp,
                 ),
               ),
             ),
           ),
         ),
       )],
      ),
      body: SingleChildScrollView(
        child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
            "My Sale's Offer",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.h)
        ),
      ),

              Consumer(
                builder: (context, ref, child) {
                  return productState.when(
                    loading: () => const Column(
                      children: [
                        ShimmerListTile(),
                        ShimmerListTile(),
                        ShimmerListTile(),
                        ShimmerListTile(),
                      ],
                    ),
                    data: (products) {
                      if (products.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("No Offers"),
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
                          print("sellerOnSale");
                          print(product.saleOffer?.discount);
                          return  InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  routesName.productdetail,
                                  arguments: {
                                    'id': widget.userId,
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
                                          ? CachedNetworkImage(
                                       imageUrl:  product.images!.first.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, error, stackTrace) {
                                          return const Icon(Icons.error);
                                        },
                                      )
                                          :  Icon(Icons.image_not_supported, size: 40.h),
                                    ),
                                    title: Text(
                                      capitalizeFirst(product.name!),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Expire At: ${formatTime(product.saleOffer?.expireAt)}",
                                          style:  TextStyle(fontSize: 12.h),
                                        ),
                                        Text(
                                          "Discount:${product.saleOffer?.discount}%",
                                          style:  TextStyle(fontSize: 12.h),
                                        ),
                                      ],
                                    ),
                                    trailing:  IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        if (product.id != null) {
                                          await ref.read(sellerOnSaleProductViewModelProvider(widget.userId.toString()).notifier)
                                              .deleteOnSaleProduct(product.saleOffer!.id.toString());
                                        }
                                      },
                                    ),
                                  ),
                                  Divider()

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
                            Text('Error loading products: ${error.toString()}'),
                            SizedBox(height: 16.h),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ]
        ),
      ),
    );

  }
  String formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final hour = dateTime.day;
      final minute = dateTime.month;
      final period = dateTime.year;
      return '$hour/$minute/$period';
    } catch (_) {
      return '';
    }
  }
}
