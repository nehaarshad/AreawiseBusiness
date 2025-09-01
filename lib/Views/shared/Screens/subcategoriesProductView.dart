import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/subCategoriesProductViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/wishListButton.dart';

class Subcategoriesproductview extends ConsumerStatefulWidget {
  final int userid;
  final String name;
  const Subcategoriesproductview({super.key,required this.userid,required this.name});

  @override
  ConsumerState<Subcategoriesproductview> createState() => _SubcategoriesproductviewState();
}

class _SubcategoriesproductviewState extends ConsumerState<Subcategoriesproductview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final productState = ref.watch(subCategoryProductViewModelProvider(widget.name));

          return productState.when(
            loading: () => const Center(child: LinearProgressIndicator(color: Appcolors.baseColor,)),
            data: (products) {
              if (products.isEmpty) {
                return const Center(child: Text("No Products available."));
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.70,
                ),
                itemCount: products.length,
                physics: const ScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, index) {
                  final product = products[index];
                  if (product?.name == null)  return const Center(child: Text("No Products available."));

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
              );
            },
            error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
          );
        },
      ),
    );
  }
}
