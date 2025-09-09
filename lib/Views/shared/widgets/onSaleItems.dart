import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getOnSaleProducts.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/notifyUtils.dart';


class onSaleProducts extends ConsumerStatefulWidget {
  int userid;
  onSaleProducts({required this.userid});

  @override
  ConsumerState<onSaleProducts> createState() => _onSaleProductsViewState();
}

class _onSaleProductsViewState extends ConsumerState<onSaleProducts> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted ) {

        ref.read(onSaleViewModelProvider.notifier).getonSaleProduct('All');
      }
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(onSaleViewModelProvider.notifier).getonSaleProduct('All'); }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState =  ref.watch(onSaleViewModelProvider);
    return productState.when(

      loading: () => const Center(child: LinearProgressIndicator(color: Appcolors.baseColor,)),
      data: (products) {
        if (products.isEmpty) {
          return SizedBox(child: const Center(child: Text("No sale on any Product.",style: TextStyle(color: Appcolors.whiteSmoke),)));
        }
        return SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              print("onSale Product ${product?.id}");
              if (product == null || product.id == null) {
                return const SizedBox();
              }
              print("${product.shop!.deliveryPrice ?? 0}",);
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
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        height: 28,
                                        width: 75,
                                        decoration: BoxDecoration(
                                            color: Appcolors.baseColorLight30,
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child:Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.discount_outlined,color: Appcolors.whiteSmoke,size: 12.h,),
                                              SizedBox(width: 4.w,),
                                              Text("${product.saleOffer!.discount}% off",style: TextStyle(fontSize:10.sp,color: Appcolors.whiteSmoke),),
                                            ],
                                          ),
                                        )),
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
                              child: Row(
                                children: [
                                  Text(
                                    "Rs.",
                                    style:  TextStyle(color: Appcolors.baseColorLight30,fontSize: 14.sp,fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${product.price ?? 0}",
                                    style: TextStyle(
                                      color: Appcolors.baseColorLight30,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(width: 3.w,),
                                  Text(
                                    "${product.saleOffer!.price ?? 0}",
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
                              padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
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


