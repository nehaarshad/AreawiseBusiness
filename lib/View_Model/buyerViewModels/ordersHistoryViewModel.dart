import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/orderModel.dart';
import '../../models/ordersRequestModel.dart';
import '../../repositories/sellerOrdersRepository.dart';

final orderHistoryViewModelProvider=StateNotifierProvider.family<orderHistoryViewModel,AsyncValue<List<orderModel?>>,String>((ref,id){
  return orderHistoryViewModel(ref: ref,id: id);
});

class orderHistoryViewModel extends StateNotifier<AsyncValue<List<orderModel?>>>{
  final Ref ref;
  String id;//buyers id
  orderHistoryViewModel({required this.ref,required this.id}):super(AsyncValue.loading()){
    getCustomerOrdersHistory(id);
  }

  Future<void> getCustomerOrdersHistory(String id) async {
    try {
      List<orderModel?> items = await ref.read(sellerOrderProvider).getCustomerOrders(id);

      print("Api Response ${items}");
      state = AsyncValue.data(items);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}