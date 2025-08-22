import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SellerViewModels/sellerOrderViewModel.dart';
import '../../../View_Model/SharedViewModels/notificationViewModel.dart';
import '../../../View_Model/buyerViewModels/ordersHistoryViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/orderStatusColor.dart';

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
        title: const Text("Notifications"),
        elevation: 2,
      ),
      body: notifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (notificationList) {

          if (notificationList.isEmpty) {
            return const Center(
              child: Text("No Notifications Yet",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: notificationList.length,
            itemBuilder: (context, index) {
              final notify = notificationList[index];

              return ListTile(
                onTap: (){
                  print(notify.id);
                  if (notify.id != null && notify.read==false) {
                    ref.read(NotificationViewModelProvider(widget.id).notifier)
                        .markNotificationAsRead(
                      notify.id!,
                      int.parse(widget.id),
                    );
                  }
                },
                leading: notify.read == true
                    ? Icon(Icons.notifications, size: 20, color: Appcolors.baseColor)
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 12, color: Appcolors.baseColorLight30),
                    Icon(Icons.notifications, size: 20, color: Appcolors.baseColor),
                  ],
                ),

                title: notify.read == true
                    ? Text(notify.message ?? "no message",
                    style: TextStyle(color: Colors.grey,fontSize: 12, fontWeight: FontWeight.normal,),maxLines: 2,)
                    : Text(notify.message ?? "no message",
                    style: TextStyle(color: Appcolors.baseColor,fontSize: 12,  fontWeight: FontWeight.w600),maxLines: 2,overflow: TextOverflow.ellipsis,),

                trailing: Text(formatDate(notify.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 9.sp)),
              );
            },
          );
        },
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Error loading Notifications: $err",
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