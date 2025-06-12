import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static  TextStyle headline = TextStyle(
    fontSize: 25.sp,
    fontWeight: FontWeight.bold,
  );

  static  TextStyle body = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static  TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
//chatView
  static TextStyle msgText = TextStyle(
    fontSize: 10.sp,
  );
  static TextStyle msgTime = TextStyle(
    fontSize: 5.sp,
    color: Colors.grey[600],
  );

}

// Usage
//Text('Custom Headline', style: AppTextStyles.headline);
