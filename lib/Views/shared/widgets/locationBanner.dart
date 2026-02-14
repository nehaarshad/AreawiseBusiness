import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../core/utils/dialogueBox.dart';

class Locationbanner extends ConsumerStatefulWidget {
  const Locationbanner({super.key});

  @override
  ConsumerState<Locationbanner> createState() => _LocationbannerState();
}

class _LocationbannerState extends ConsumerState<Locationbanner> {
  @override
  Widget build(BuildContext context) {
    final location = ref.watch(selectLocationViewModelProvider);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: 22.h
      ),
      color: Appcolors.baseColor,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.0.w,vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 4.w,

              children: [
                Icon(Icons.location_on,color: Appcolors.whiteSmoke,size: 15.h,),
                Text("Your location:",style: TextStyle(fontSize: 12.sp,color: Appcolors.whiteSmoke)),
                location != null
                    ?
                Text("${location}",style: TextStyle(fontSize: 12.sp,color: Appcolors.whiteSmoke))
                    :
                Text(" Not Selected",style: TextStyle(fontSize: 12.sp,color: Appcolors.whiteSmoke,fontWeight: FontWeight.w500)),


              ],
            ),
            InkWell(
              onTap:(){
                DialogUtils.showLocationDialog(context);
              } ,
                child: Text("Tap to change",
                  style: TextStyle(color: Appcolors.whiteSmoke,fontSize: 12.sp,fontWeight: FontWeight.w500,decoration: TextDecoration.underline,decorationColor: Appcolors.whiteSmoke,decorationStyle: TextDecorationStyle.dotted,decorationThickness: 2.0),)

            )

          ],
        ),
      ),
    );
  }
}
