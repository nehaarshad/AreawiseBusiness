import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class infoWidget extends StatelessWidget {
  final String heading;
  final String value;

  const infoWidget({required this.heading, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$heading: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}
