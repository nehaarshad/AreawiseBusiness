import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Views/shared/widgets/colors.dart';
import '../../models/cartModel.dart';
import '../../models/orderModel.dart';
import '../../repositories/checkoutRepositories.dart';
import 'cartViewModel.dart';
import 'ordersHistoryViewModel.dart';

final orderViewModelProvider=StateNotifierProvider<OrderViewModelProvider,AsyncValue<orderModel?>>((ref){
  return OrderViewModelProvider(ref:ref);
});
class OrderViewModelProvider extends StateNotifier<AsyncValue<orderModel?>>{
  final Ref ref;
  OrderViewModelProvider({required this.ref}):super(AsyncValue.loading());

  final key = GlobalKey<FormState>();
  late TextEditingController sector=TextEditingController();
  late TextEditingController city=TextEditingController();
  late TextEditingController address=TextEditingController();
  bool loading = false;


  @override
  void dispose() {
    sector.dispose();
    city.dispose();
    address.dispose();
    super.dispose();
  }

  Future<void> checkOut(String id,BuildContext context) async {
    try {
      orderModel order = await ref.read(orderProvider).getUserCheckout(id);
      state = AsyncValue.data(order);
      CheckoutDialogView(context,order);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> cancelOrder(String id) async {
    try {
      Cart order = await ref.read(orderProvider).cancelOrder(id);
      print(order);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void CheckoutDialogView(BuildContext context, orderModel order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Confirmation'),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ID: ${order.id}'),
                    Text('Status: ${order.status}',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                  ],
                ),
                Center(child: const Text('Cart Items:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                Divider(),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...order.cart!.cartItems!.map((item) {  //al items in order are join as list
                        return ListTile(
                          title: Text(item.product!.name!),
                          subtitle: Text('Quantity: ${item.quantity}, Price: \$${item.price}'),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                Divider(),
                if(order.total != null && order.total! >5000)
                  Text('Discount: 10%'),
                Text('Delivery Charges: \$${order.shippingPrice}'),
                Text('Total: \$${order.total}'),
              ],
            ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async{

                    await cancelOrder(order.cart!.id.toString());
                    ref.refresh(cartViewModelProvider(order.cart!.userId.toString()));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                      onPressed: () async{
                        final parameters={
                          'CartId':order.cartId,
                          'userid':order.cart!.userId.toString(),
                        };
                        Navigator.pushNamed(context, routesName.deliveryAddress,arguments: parameters);
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      child: const Text("Proceed...", style: TextStyle(color: Appcolors.whiteColor, fontWeight: FontWeight.bold, fontSize: 15,),),
                    ),
              ],
            ),
          ],
        );
      },
    );
  }

//only cartId,address are send as req.body
  Future<void> placeOrder(Map<String,dynamic> data,String userId,BuildContext context) async {
    try {
      print('Sending data to API: $data');

      await ref.read(orderProvider).placeUserOrder(data);
      ref.invalidate(cartViewModelProvider(userId));
      await ref.read(cartViewModelProvider(userId).notifier).getUserCart(userId);

      ref.invalidate(orderHistoryViewModelProvider(userId));
      await ref.read(orderHistoryViewModelProvider(userId).notifier).getCustomerOrdersHistory(userId);

      Utils.flushBarErrorMessage("Order Sent Successfully", context);
        if (mounted) {
          Navigator.pushNamed(context, routesName.dashboard,arguments: int.parse(userId));
        } 
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }


}