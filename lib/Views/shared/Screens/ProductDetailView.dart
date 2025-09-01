import 'package:ecommercefrontend/View_Model/buyerViewModels/WishListViewModel.dart';
import 'package:ecommercefrontend/View_Model/buyerViewModels/cartViewModel.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/getProductDetailsViewModel.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/DashBoardProductsView.dart';
import '../widgets/contactWithSellerButton.dart';
import '../widgets/imageSlider.dart';
import '../widgets/productReviews.dart';
import '../widgets/relatedProducts.dart';
import '../widgets/shopProducts.dart';
import '../widgets/wishListButton.dart';

class productDetailView extends ConsumerStatefulWidget {
  int userid;
  ProductModel? product;
  int productId;

  productDetailView({required this.userid,required this.product, required this.productId});

  @override
  ConsumerState<productDetailView> createState() => _productDetailViewState();
}

class _productDetailViewState extends ConsumerState<productDetailView> {

  @override
  void initState() {
    super.initState();
    print("UserId passed ${widget.userid}");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      ref.invalidate(ProductDetailsViewModelProvider(widget.productId.toString()));
      if (!mounted) return;
      await ref.read(ProductDetailsViewModelProvider(widget.productId.toString()).notifier)
          .getProductDetails(widget.productId.toString());
    });
  }

  int Qty=1;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(ProductDetailsViewModelProvider(widget.productId.toString()));
    return Scaffold(
      appBar: AppBar(
         actions: [
           Row(
             children: [
               WishlistButton( color:Appcolors.blackColor,userId: widget.userid.toString(),productId:widget.productId),
               contactWithSellerButton(
                 userId: widget.userid.toString(),
                 productId: widget.productId.toString(),
                 product: widget.product,
               ),
             ],
           ),
         ],
      ),

      body: SafeArea(
        child: productState.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: LinearProgressIndicator(color: Appcolors.baseColor),
            ),
          ),
          data: (product) {
            if (product == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("No Product Available"),
                ),
              );
            }
            return SingleChildScrollView(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ImageSlider(images: product.images ?? [], height: 350.h),

                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 15, 10, 100),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                                children: [
                                  Icon(Icons.store,color: Colors.grey,),
                                  Text('${product.shop?.shopname!}',style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.sp
                                  ),),

                                ],
                              ),
                          Divider(thickness: 0.4.h,),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: product.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: product.subtitle,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.sp,
                                    wordSpacing: 5,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                    children: [
                                      Text("Price (Rs.): ",style: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,fontWeight: FontWeight.w500),),
                                      product.onSale ?? false ?
                                      Row(
                                          children: [
                                            Text(
                                              "${product.price ?? 0}",
                                              style: TextStyle(
                                                color: Colors.grey, // Different color for strikethrough
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.lineThrough,
                                                decorationColor: Colors.grey, // Match text color
                                              ),
                                            ),
                                            SizedBox(width: 3.w),
                                            Text(
                                              "${product.saleOffer?.price ?? 0}",
                                              style: TextStyle(
                                                  color: Appcolors.baseColor,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                            Icon(Icons.discount_outlined,color: Appcolors.whiteSmoke,size: 12.h,),
                                          ],
                                        )
                                       :
                                      Row(
                                          children: [
                                            Text(
                                              "${product.price ?? 0}",
                                              style: TextStyle(
                                                  color: Appcolors.baseColor,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ],
                                        ),

                                    ],
                                  ),
                              if(product.onSale ?? false)
                              Row(
                                children: [
                                  Icon(Icons.discount_outlined,color: Appcolors.baseColor,size: 14.h,),
                                  Text("${product.saleOffer?.discount}% off",style: TextStyle(fontSize:15.sp,color: Appcolors.baseColor),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Text("Sold: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,fontWeight: FontWeight.w500),),
                              Text(
                                "${product.sold}",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(" (${product.stock} available)",style: TextStyle(color: Colors.red,fontSize: 15.sp,fontWeight: FontWeight.w500),),

                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Text("Qty: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,fontWeight: FontWeight.w500),),
                              Container(
                                height: 35.h,
                                width: 124.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: Colors.grey, width: 1.w),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      iconSize: 20.h,
                                      onPressed: (Qty > 1)
                                          ? () {
                                        setState(() {
                                          Qty = Qty - 1;
                                        });
                                        if (kDebugMode) {
                                          print("Decrement to: $Qty in product View");
                                        }
                                      }
                                          : null,
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text(
                                      '$Qty',
                                      style:  TextStyle(fontSize: 16.sp),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      iconSize: 20.h,
                                      onPressed: (product.stock != null && Qty < product.stock!)
                                          ? () {
                                        setState(() {
                                          Qty = Qty + 1;
                                        });
                                        if (kDebugMode) {
                                          print("Increment to: $Qty in productView");
                                        }
                                      }
                                          : null,
                                      icon: const Icon(Icons.add, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Category: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,fontWeight: FontWeight.w500),),
                                  Text(
                                    "${product.subcategory?.name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 55.w,
                                height: 25.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: Appcolors.baseColor,
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 15.h,
                                    ),
                                    SizedBox(width: 3.w,),
                                    Text('${product.ratings}',style: TextStyle(color: Colors.white,fontSize: 14.sp)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Product Description: ",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: product.description,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.sp,
                                    wordSpacing: 5,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ProductReviews(productId: product.id!,userId: widget.userid,),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h,),
                                child: Text(
                                  "Related Products",
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text("See All", style: TextStyle(color: Colors.grey)),
                                  Icon(Icons.arrow_forward_ios_sharp, size: 10.h),
                                ],
                              ),
                            ],
                          ),
                          RelatedProducts(userid: widget.userid,category: product.category?.name,),
                          SizedBox(height: 20.h,),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "More products from this shop",
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Text("See All", style: TextStyle(color: Colors.grey)),
                                    Icon(Icons.arrow_forward_ios_sharp, size: 10.h),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h,),
                          shopProducts(shopId:  product.shop!.id.toString(),id: widget.userid.toString(),),
                        ],
                      ),


                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48.h),
                  SizedBox(height: 16.h),
                  Text('Error loading product Details: ${error.toString()}'),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        )

      ),

    bottomNavigationBar: Padding(
    padding: const EdgeInsets.all(12.0),
    child: SizedBox(
    width: double.infinity,
    height: 50.h,
    child: ElevatedButton.icon(
    onPressed: () async {
    await ref.read(cartViewModelProvider(widget.userid.toString()).notifier)
        .addToCart(widget.userid.toString(), widget.productId!,Qty);

    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Appcolors.baseColor,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.r),
    ),
    padding:  EdgeInsets.symmetric(horizontal: 20.w),
    ),
    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
    label:  Text(
    'Add to Cart',
    style: TextStyle(color: Colors.white, fontSize: 16.sp),
    ),
    ),
    ),
    )
    );
  }
}
