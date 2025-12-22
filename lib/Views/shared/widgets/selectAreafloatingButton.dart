import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locationDropDown.dart';

class selectLocationFloatingButton extends StatelessWidget {


  const selectLocationFloatingButton({
    Key? key,
  }) : super(key: key);

  Future<void> markLocationAsSet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_set', true);
  }

  Future<void> showLocationDialog(BuildContext context) async {

      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Location',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.baseColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, size: 24.sp),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Location dropdown widget
                const locationDropDown(),

                SizedBox(height: 16.h),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.baseColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Confirm Location',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Mark as set regardless of whether they selected or skipped
      if (result != null) {
        await markLocationAsSet();
      }

  }

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
          showLocationDialog(context);
        },
        backgroundColor: Colors.white38,
        elevation:  6.0,
        tooltip: "Set Location",
        child: Icon(
          Icons.location_on,
          color: Appcolors.baseColor,
          size:  22.0.h ,

        ),
      ),
    );
  }
}