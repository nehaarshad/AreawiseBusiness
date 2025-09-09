
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/models/paymentModel.dart';
import 'package:ecommercefrontend/repositories/transactionSlipRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/colors.dart';
import '../../models/cartModel.dart';
import '../../models/orderModel.dart';
import '../../repositories/checkoutRepositories.dart';
import '../SharedViewModels/transcriptsViewModel.dart';
import '../auth/sessionmanagementViewModel.dart';
import 'cartViewModel.dart';
import 'ordersHistoryViewModel.dart';

final orderViewModelProvider=StateNotifierProvider<OrderViewModelProvider,AsyncValue<List<paymentModel> >>((ref){
  return OrderViewModelProvider(ref:ref);
});
class OrderViewModelProvider extends StateNotifier<AsyncValue<List<paymentModel> >>{
  final Ref ref;
  OrderViewModelProvider({required this.ref}):super(AsyncValue.loading());

  final key = GlobalKey<FormState>();
  late TextEditingController sector=TextEditingController();
  late TextEditingController city=TextEditingController();
  late TextEditingController address=TextEditingController();
  bool loading = false;
  int trueResponses = 0;

  Future<void> uploadTranscripts() async{
    trueResponses++;
    print("trueResponses ${trueResponses}");
  }

  void resetState(){
    city.clear();
    sector.clear();
    address.clear();
    if (key.currentState != null) {
      key.currentState!.reset();
    }
  }

  Future<int> checkOut(String id,double total,String offer,BuildContext context,) async {
    try {
      resetState();
      final data={
        "total":total
      };
      List<paymentModel> payments = await ref.read(orderProvider).getUserCheckout(id,data);
      int cartid= payments[0].items![0].cartId!;
      state=AsyncValue.data(payments);
      return cartid;
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
      return 0;
    }
  }

  Future<void> cancelOrder(String id) async {
    try {
      Cart order = await ref.read(orderProvider).cancelOrder(id);
      trueResponses=0;
      resetState();
      print(order);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

 //only cartId,address,paymentmethod and status are send as req.body
  Future<void> placeOrder(Map<String,dynamic> data,String userId,BuildContext context) async {
    try {
      print('Sending data to API: $data');

      await ref.read(orderProvider).placeUserOrder(data);
      ref.invalidate(cartViewModelProvider(userId));
      await ref.read(cartViewModelProvider(userId).notifier).getUserCart(userId);

      ref.invalidate(orderHistoryViewModelProvider(userId));
      await ref.read(orderHistoryViewModelProvider(userId).notifier).getCustomerOrdersHistory(userId);

      resetState();
      ref.invalidate(sessionProvider);
    final user= await ref.read(sessionProvider.notifier).getuser();

          Navigator.pushNamed(context, routesName.confirmOrder,arguments: user);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // TextButton(
  // onPressed: () async {
  // await cancelOrder(order.cart!.id.toString());
  // ref.refresh(cartViewModelProvider(order.cart!.userId.toString()));
  // Navigator.of(context).pop();
  // },
  // child: const Text('Close'),
  // ),
  // ElevatedButton(
  // onPressed: () async {
  // final parameters = {
  // 'CartId': order.cartId,
  // 'userid': order.cart!.userId.toString(),
  // };
  // Navigator.pushNamed(
  // context,
  // routesName.deliveryAddress,
  // arguments: parameters
  // );
  // },
  // style: ElevatedButton.styleFrom(
  // backgroundColor: Appcolors.baseColor,
  // shape: RoundedRectangleBorder(
  // borderRadius: BorderRadius.circular(40.0),
  // ),
  // ),
  // child: const Text(
  // "Proceed",
  // style: TextStyle(
  // color: Appcolors.whiteSmoke,
  // fontWeight: FontWeight.bold,
  // fontSize: 15,
  // ),
  // ),
  // ),

}