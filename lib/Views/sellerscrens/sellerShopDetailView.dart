import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/widgets/imageSlider.dart';
import '../shared/widgets/shopProducts.dart';

class SellerShopDetailView extends ConsumerStatefulWidget {
  ShopModel shop;
  SellerShopDetailView({required this.shop});

  @override
  ConsumerState<SellerShopDetailView> createState() => _ShopDetailViewState();
}

class _ShopDetailViewState extends ConsumerState<SellerShopDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [

      ],),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSlider(images: widget.shop.images ?? [], height: 350.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 15, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text("${widget.shop.shopname}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.black,)),
                    Text("${widget.shop.shopaddress} | ${widget.shop.city}",style: TextStyle(
                      fontWeight: FontWeight.normal,fontSize: 15.sp, color: Colors.black87,),),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Text("Seller Name: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,fontWeight: FontWeight.w500),),
                        Text(
                          "${widget.shop.user?.username}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Category: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,fontWeight: FontWeight.w500),),
                        Text(
                          "${widget.shop.category?.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Sector: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,fontWeight: FontWeight.w500),),
                        Text(
                          "${widget.shop.sector}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Divider()
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shop Products",
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
              shopProducts(shopId:  widget.shop.id.toString()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 22.w),
        child: ElevatedButton.icon(
          onPressed: () {
            
            if(widget.shop.status=='Active') {
              Navigator.pushNamed(
                context,
                routesName.sAddProduct,
                arguments: widget.shop,
              );
            }
            else{
              Utils.flushBarErrorMessage("Shop activation pending. Please wait for admin approval before adding products.",context);
            }
          },
          icon: Icon(Icons.add, size: 18.h,color: Appcolors.whiteColor,),
          label: Text("Add Product"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Appcolors.blueColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ),
    );
  }
}
