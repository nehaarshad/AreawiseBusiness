import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/notificationModel.dart';

class NotificationBadgeWidget extends ConsumerWidget {
  final Widget child;
  final Stream<NotificationModel> notificationStream;

  const NotificationBadgeWidget({
    Key? key,
    required this.child,
    required this.notificationStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<NotificationModel>(
      stream: notificationStream,
      builder: (context, snapshot) {
        return Stack(
          children: [
            child,
            if (snapshot.hasData)
              Positioned(
                right: 12,
                top: 7,
                left: 25,
                child: Icon(Icons.circle,color: Appcolors.baseColor,size: 12.h,)
              ),
          ],
        );
      },
    );
  }
}