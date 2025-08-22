import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color = Colors.blue;
  final Color textColor = Colors.white;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 25.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Appcolors.baseColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child:
              isLoading
                  ? CircularProgressIndicator(color: Appcolors.whiteSmoke)
                  : Text(text, style: TextStyle(color: Appcolors.whiteSmoke,fontWeight: FontWeight.bold,fontSize: 15.sp)),
        ),
      ),
    );
  }
}
