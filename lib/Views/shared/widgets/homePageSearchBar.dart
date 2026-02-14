import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/dialogueBox.dart';
import '../../../core/utils/routes/routes_names.dart';

class TopSearchBar extends StatelessWidget {
  final int userid;
  const TopSearchBar({super.key, required this.userid});

  void navigateToSearchView(BuildContext context) {

        Navigator.pushNamed(context, routesName.toSearchProduct, arguments:userid );



  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 18.0.w),
      child:  Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Appcolors.baseWhite
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
               onPressed: ()=> navigateToSearchView(context),
               child: Text("  Search product...",style: TextStyle(color: Colors.grey.shade500,fontSize: 13.sp),)),
            InkWell(
              onTap:  (){
                DialogUtils.showLocationDialog(context);
                },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
              Text(" | ",style: TextStyle(color: Colors.grey.shade500,fontSize: 15.sp,fontWeight: FontWeight.bold),),
                  Icon(Icons.location_on,size: 16.h,color: Colors.grey.shade500,),
                  Text(" location",style: TextStyle(color: Colors.grey.shade500,fontSize: 12.sp),),
                  SizedBox(width: 15.w,)

                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
