import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/NewArrivalsViewModel.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../widgets/DashBoardProductsView.dart';
import '../widgets/categoryTopBar.dart';
import '../widgets/getAllAds.dart';
import '../widgets/getAllFeatureProducts.dart';
import '../widgets/getNewArrivals.dart';
import '../widgets/onSaleItems.dart';

class appHomeview extends ConsumerStatefulWidget {
  final int id;
  appHomeview({required this.id});

  @override
  ConsumerState<appHomeview> createState() => _appHomeviewState();
}

class _appHomeviewState extends ConsumerState<appHomeview> {

 @override
  void initState() {
    super.initState();
    // Initial load with 'All' category - moved to didChangeDependencies to avoid provider issues
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SingleChildScrollView(
        child:  Column(
            children: [

              SizedBox(height: 15.h),
              const getAdsView(),
              Divider(),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                    child: Text(
                      "Categories",
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),

                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              CategoriesButton(id: widget.id.toString(),),
              SizedBox(height: 10.h),
              // onSale
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                            child: Text(
                              "Sale's Offer",
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500,color: Appcolors.blackColor),
                            ),
                          ),

                        ],
                      ),
                      onSaleProducts(userid: widget.id,),
               SizedBox(height: 10.h),
              // New Arrivals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                    child: Text(
                      "New Arrivals",
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      Text("See All", style: TextStyle(color: Colors.grey,fontSize: 12.sp)),
                      Icon(Icons.arrow_forward_ios_sharp, size: 9.h,color: Colors.grey,),
                    ],
                  ),
                ],
              ),
              NewArrivals(userid: widget.id,),
              SizedBox(height: 10.h),
              // Featured Products
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                    child: Text(
                      "Featured Products",
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                       Text("See All", style: TextStyle(color: Colors.grey,fontSize: 12.sp)),
                       Icon(Icons.arrow_forward_ios_sharp, size: 9.h,color: Colors.grey,),
                    ],
                  ),
                ],
              ),
              AllFeaturedProducts(userid: widget.id),
              //All Products
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                        child: Text(
                          "Recommended for You",
                          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
               ],
             ),
              AllProducts(userid: widget.id),
            ],
          ),

      );

  }
}
