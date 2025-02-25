
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/ordersRequestModel.dart';
import '../../repositories/sellerOrdersRepository.dart';

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
  Future<void> updateOrdersStatus(String id,int productId,String status,BuildContext context) async {
    try {
      final data={
        'productId':productId,
        'status':status
      };
      OrdersRequestModel items = await ref.read(sellerOrderProvider).updateOrderStatus(id,data);
      print('Update Order Status ${items}');
      Utils.flushBarErrorMessage("Order Status Updated", context);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}