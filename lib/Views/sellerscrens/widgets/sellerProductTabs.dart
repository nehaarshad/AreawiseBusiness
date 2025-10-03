import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';

Widget SellerProductTabs(int userId,BuildContext context){
  return  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color:  Appcolors.baseColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Appcolors.baseColor,
              width: 1.5,
            ),
          ),
          child: Text(
            "All",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap:()async{
            Navigator.pushNamed(
              context,
              routesName.sAddProduct,
              arguments: userId.toString(),
            );
          },
          child: Container(
            height: 25.h,
            width: 100.w,
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
                "Add New",
                style: TextStyle(
                  color: Appcolors.baseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap:()async{
            Navigator.pushNamed(
              context,
              routesName.onSale,
              arguments: userId,
            );
          },
          child: Container(
            height: 25.h,
            width: 100.w,
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
                "on sale",
                style: TextStyle(
                  color: Appcolors.baseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap:()async{
            Navigator.pushNamed(
              context,
              routesName.featuredProducts,
              arguments:userId,
            );
          },
          child: Container(
            height: 25.h,
            width: 100.w,
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
                "Featured",
                style: TextStyle(
                  color: Appcolors.baseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}