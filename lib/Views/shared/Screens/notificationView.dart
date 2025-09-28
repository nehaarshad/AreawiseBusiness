import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SharedViewModels/notificationViewModel.dart';
import '../../../core/utils/routes/notificationRoutes.dart';
import '../../../core/utils/textStyles.dart';
import '../widgets/loadingState.dart';

class NotificationView extends ConsumerStatefulWidget {
  String id;
  NotificationView({super.key,required this.id});

  @override
  ConsumerState<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() => loadData());
  }
  void loadData() {

    ref.read(NotificationViewModelProvider(widget.id.toString()).notifier).getNotification(widget.id.toString());

  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(NotificationViewModelProvider(widget.id.toString()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.whiteSmoke,
        title:  Text("Notifications",style: AppTextStyles.headline,),
        elevation: 2,
      ),
      body: notifications.when(
        loading: () => const Column(
          children: [
            ShimmerListTile(),
            ShimmerListTile(),
            ShimmerListTile(),

          ],
        ),
        data: (notificationList) {

          if (notificationList.isEmpty) {
            return const Center(
              child: Text("No Notifications Yet",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
            itemCount: notificationList.length,
            itemBuilder: (context, index) {
              final notify = notificationList[index];

              return Card(

                elevation: 1,
                child: ListTile(

                  onTap: (){
                    print(notify.id);
                    if (notify.id != null && notify.read==false) {
                      ref.read(NotificationViewModelProvider(widget.id).notifier)
                          .markNotificationAsRead(
                        notify.id!,
                        int.parse(widget.id),
                      );
                    }
                    int userId=int.tryParse(widget.id) ?? 0;
                    navigateBasedOnNotification(message: notify.message!,userId: userId,context: context,ref: ref);

                  },

                  title: notify.read == true
                      ? Text(notify.message ?? "no message",
                      style: TextStyle(color: Colors.black54,fontSize: 14, fontWeight: FontWeight.normal,),maxLines: 2,)
                      : Text(notify.message ?? "no message",
                      style: TextStyle(color: Appcolors.baseColor,fontSize: 14,  fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),

                  trailing: Text(formatDate(notify.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 9.sp)),
                ),
              );
            },
          );
        },
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                "Something went wrong. Try Later!",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),

      ),
    );
  }

  String formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ';
    } catch (e) {
      return 'Invalid Date';
    }
  }

}