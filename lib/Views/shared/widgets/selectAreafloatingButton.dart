import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/dialogueBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locationDropDown.dart';

class selectLocationFloatingButton extends StatelessWidget {


  const selectLocationFloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  50.0.w ,
      height: 45.0.h ,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23.r),
        color: Colors.white,
        border: Border.all(
        color: Appcolors.baseColor,
        width: 4.0,
    ),
      ),
      child: FloatingActionButton(
        onPressed: (){
          DialogUtils.showLocationDialog(context);
        },
        backgroundColor: Appcolors.baseColor,
        elevation:  6.0,
        tooltip: "Set Location",
        child: Icon(
          Icons.location_on,
          color: Appcolors.whiteSmoke,
          size:  22.0.h ,

        ),
      ),
    );
  }
}