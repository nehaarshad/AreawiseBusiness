import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:ecommercefrontend/core/utils/CapitalizesFirst.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/notifyUtils.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/ProductModel.dart';

class Productcard extends StatefulWidget {
   final ProductModel product;
  final int userid;
  const Productcard({super.key,required this.product,required this.userid});

  @override
  State<Productcard> createState() => _ProductcardState();
}

class _ProductcardState extends State<Productcard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.product != null) {
            Navigator.pushNamed(
              context,
              routesName.productdetail,
              arguments:  {
                'id': widget.userid,
                'productId':widget.product.id,
                'product': widget.product
              },
            );
          } else {
            Utils.toastMessage("Product information is not available");
          }
        },
        child: Container(

          margin: EdgeInsets.symmetric(horizontal: 8.w),
          width: 168.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    if (widget.product.images != null && widget.product.images!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl:  widget.product.images!.first.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorWidget: (context, error, stackTrace) =>
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
                            child:  WishlistButton(color: Appcolors.whiteSmoke, userId: widget.userid.toString(),productId:widget.product.id!),

                          ),
                        )
                    ),
                  ],
                ),
              ),

              if(widget.product.onSale!)
                Row(
                  children: [
                    Icon(Icons.discount_outlined,color: Appcolors.baseColor,size: 14.h,),
                    SizedBox(width: 4.w,),
                    Text("on sale",style: TextStyle(fontWeight: FontWeight.w500,fontSize:14.sp,color: Appcolors.baseColor),),
                  ],
                ),
              // Product Info
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 4.w),
                child: Text(
                 capitalizeFirst(widget.product.name!),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              widget.product.onSale! ?
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
                      "${widget.product.price ?? 0}",
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
                      "${widget.product.saleOffer?.price ?? 0}", // Use ?. instead of !.
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
                      "${widget.product.price ?? 0}",
                      style: TextStyle(
                          color: Appcolors.baseColorLight30,
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
  }
}
