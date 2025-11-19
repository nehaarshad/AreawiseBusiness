import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/repositories/orderReminderRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/colors.dart';
import '../../models/ordersRequestModel.dart';
import '../../repositories/sellerOrdersRepository.dart';
import '../buyerViewModels/ordersHistoryViewModel.dart';

final sellerOrderViewModelProvider=StateNotifierProvider.family<sellerOrderViewModel,AsyncValue<List<OrdersRequestModel?>>,String>((ref,id){
  return sellerOrderViewModel(ref:ref,id:id);
});

class sellerOrderViewModel extends StateNotifier<AsyncValue<List<OrdersRequestModel?>>>{
  final Ref ref;
  String id;
  sellerOrderViewModel({required this.ref,required this.id}):super(AsyncValue.loading()){
    getSellerOrdersRequests(id);
  }

  Future<void> getSellerOrdersRequests(String id) async {
    try {
      List<OrdersRequestModel?> items = await ref.read(sellerOrderProvider).getSellerOrders(id);
      state = AsyncValue.data(items);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  //orderId as params ...status and productid as body
  Future<void> updateOrdersStatus(String id,String customerId,int productId,String status,BuildContext context) async {
    try {
      final data={
        'productId':productId,
        'status':status
      };
      OrdersRequestModel items = await ref.read(sellerOrderProvider).updateOrderStatus(id,data);
      print('Update Order Status ${items}');
      try {
        // Invalidate the provider to refresh the product list
        ref.invalidate(orderHistoryViewModelProvider(customerId));
        await ref.read(orderHistoryViewModelProvider(customerId).notifier).getCustomerOrdersHistory(customerId);
      } catch (innerError) {
        print("Error refreshing product lists: $innerError");
        // Continue with success flow despite refresh errors
      }
      Utils.flushBarErrorMessage("Order Status Updated", context);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setReminder(int orderId,int sellerId,BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime reminderDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Check if time is in the future
        if (reminderDateTime.isBefore(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select a future time'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final data={
          "orderId":orderId,
          "reminderDateTime":reminderDateTime.toIso8601String()
        };

        await ref.read(reminderProvider).setReminder(data, sellerId.toString());
       await getSellerOrdersRequests(sellerId.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder set for Order #${orderId}'),
            backgroundColor: Appcolors.baseColor,
          ),
        );
      }
    }
  }

  Future<void> removeReminder(String orderId) async {
    await ref.read(reminderProvider).deleteReminder( orderId);
    getSellerOrdersRequests(id);
  }
}