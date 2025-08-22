import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/textStyles.dart';
import '../../../models/messagesModel.dart';

class MessageView extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageView({
    required this.message,
    required this.isMe,
  }) ;

  @override

  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h,),
                  if (!isMe)

                    Text(
                      message.user?.username ?? 'me',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Appcolors.baseColor,
                      ),
                    ),

                ],
              )
            ),
          ),
          SizedBox(height: 2.h),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75, // Max 75% of screen width
              ),
              margin:  EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
              padding:  EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topRight: isMe ?  Radius.circular(0.r) :  Radius.circular(12.r),
                  topLeft: isMe ?  Radius.circular(12.r) :  Radius.circular(0.r),
                  bottomLeft:  Radius.circular(12.r),
                  bottomRight:  Radius.circular(12.r),
                ),
              ),
              child: IntrinsicWidth(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 3.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        message.msg ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.grey[600],
                  )
              ),
            ),
          ),
        ],

      ),
    );
  }
  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour < 12 ? 'AM' : 'PM';
      final hour12;
      if (hour == 0) {
        hour12 = 12;  // midnight (0:00) → 12 AM
      } else if (hour > 12) {
        hour12 = hour - 12;  // PM hours
      } else {
        hour12 = hour;  // AM hours (1-12)
      }

      return '$hour12:$minute $period';
    } catch (_) {
      return '';
    }
  }
}