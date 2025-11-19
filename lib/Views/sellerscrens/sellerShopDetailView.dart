import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/dialogueBox.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/widgets/imageSlider.dart';
import '../shared/widgets/shopProducts.dart';

class SellerShopDetailView extends ConsumerStatefulWidget {
  int userId;
  ShopModel shop;

  SellerShopDetailView({required this.shop,required this.userId});

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

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSlider(images: widget.shop.images ?? [], height: 250.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 15, 20, 20),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text("${widget.shop.shopname}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.black,)),
                    Text("${widget.shop.shopaddress} | ${widget.shop.sector} | ${widget.shop.city}",style: TextStyle(
                      fontWeight: FontWeight.normal,fontSize: 14.sp, color: Colors.black87,),),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("", style: TextStyle( color: Colors.black,)),
                        Column(
                          children: [
                            Icon(Icons.person,color: Appcolors.baseColor,size: 20.h,),
                            Text(
                              "${widget.shop.user?.username}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Text("|", style: TextStyle( color: Colors.black,)),
                        Column(
                          children: [
                            Icon(Icons.phone,color: Appcolors.baseColor,size: 20.h,),
                            Text(
                              "0${widget.shop.user?.contactnumber}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Text("|", style: TextStyle( color: Colors.black,)),
                        Column(
                          children: [
                            Icon(Icons.category,color: Appcolors.baseColor,size: 20.h,), Text(
                              "${widget.shop.category?.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Text("", style: TextStyle( color: Colors.black,)),
                      ],
                    ),

                    SizedBox(height: 20.h,),
                    Divider()
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12.0.h),
                child:  Text(
                  "Shop Products",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.h,),
              shopProducts(shopId:  widget.shop.id.toString(),id: widget.userId.toString(),),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 22.w),
        child: ElevatedButton.icon(
          onPressed: () async {
            
            if(widget.shop.status=='Active') {
              Navigator.pushNamed(
                context,
                routesName.sAddProduct,
                arguments: widget.shop.userId.toString(),
              );
            }
            else{
              await DialogUtils.showErrorDialog(context, "Shop is not Active. Please wait for admin approval before adding products.");
                 }
          },
          icon: Icon(Icons.add, size: 18.h,color: Appcolors.whiteSmoke,),
          label: Text("Add Product"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Appcolors.baseColor,
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
