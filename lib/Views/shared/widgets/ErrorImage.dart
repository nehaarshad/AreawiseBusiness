import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _ErrorImage extends StatelessWidget {
  const _ErrorImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.h,
      color: Colors.grey[200],
      child:  Icon(
        Icons.image_not_supported,
        size: 40.h,
        color: Colors.grey,
      ),
    );
  }
}