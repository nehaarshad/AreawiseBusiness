import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/models/notificationModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/socketService.dart';
import '../../repositories/UserDetailsRepositories.dart';

final NotificationViewModelProvider = StateNotifierProvider.family<NotificationViewModel, AsyncValue<List<NotificationModel>>,String>((ref,id) {
  return NotificationViewModel(ref,id);
});

class NotificationViewModel extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final Ref ref;
  final String id;
  NotificationViewModel(this.ref,this.id) : super(AsyncValue.loading()){
    getNotification(this.id);
  }


  Future<void> getNotification(String id) async {
    try {
      List<NotificationModel> notify = await ref.read(userProvider).getUserNotifications(id);
      state = AsyncValue.data( notify);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> markNotificationAsRead(int notificationId, int userId) async {
    try {
      // Update local state first for immediate UI feedback
      final currentState = state;
      if (currentState is AsyncData<List<NotificationModel>>) {
        final updatedNotifications = currentState.value.map((notify) {
          if (notify.id == notificationId) {
            return notify.copyWith(read: true);
          }
          return notify;
        }).toList();

        state = AsyncValue.data(updatedNotifications);
      }

      // Send to server via socket
      ref.read(socketServiceProvider).markNotificationAsRead(
        notificationId: notificationId,
        userId: userId,
      );

    } catch (e) {
      print('Error marking notification as read: $e');
      // Revert UI change if needed
    }
  }
}