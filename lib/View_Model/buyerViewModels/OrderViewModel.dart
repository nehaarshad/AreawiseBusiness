
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/colors.dart';
import '../../models/cartModel.dart';
import '../../models/orderModel.dart';
import '../../repositories/checkoutRepositories.dart';
import '../auth/sessionmanagementViewModel.dart';
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
  

  Future<void> checkOut(String id,double total,String offer,BuildContext context,) async {
    try {
      final data={
        "total":total
      };
      orderModel order = await ref.read(orderProvider).getUserCheckout(id,data);
      state = AsyncValue.data(order);
      CheckoutDialogView(context,order,total,offer);
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

  void CheckoutDialogView(BuildContext context, orderModel order,double total,String offer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Confirmation'),
          content: SizedBox(
            height: 400, // Fixed height
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Order header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ID: ${order.id}'),
                    Text('Status: ${order.status}',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Cart items section with fixed height scroll
                const Text('Cart Items:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                const Divider(),

                // Scrollable cart items
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: order.cart!.cartItems!.length,
                      itemBuilder: (context, index) {
                        final item = order.cart!.cartItems![index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          elevation: 1,
                          child: ListTile(
                            leading: item.product?.images?.isNotEmpty == true
                                ? Image.network(
                              item.product!.images!.first.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported);
                              },
                            )
                                : const Icon(Icons.image_not_supported),
                            title: Text(item.product!.name!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quantity: ${item.quantity}'),
                                Text('Price: \$${item.price}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Order summary
                const Divider(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Shipping Price:'),
                      Text('Rs.${order.shippingPrice}'),
                    ],
                  ),
                ),
                total < (double.tryParse(offer) ?? 5000.0 )
                    ?
                SizedBox.shrink()
                    :
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount:'),
                      Text('Rs.${order.discount! * 100} %'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      Text('Rs.${order.total}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    await cancelOrder(order.cart!.id.toString());
                    ref.refresh(cartViewModelProvider(order.cart!.userId.toString()));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final parameters = {
                      'CartId': order.cartId,
                      'userid': order.cart!.userId.toString(),
                    };
                    Navigator.pushNamed(
                        context,
                        routesName.deliveryAddress,
                        arguments: parameters
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolors.baseColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  child: const Text(
                    "Proceed",
                    style: TextStyle(
                      color: Appcolors.whiteSmoke,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
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

      ref.invalidate(sessionProvider);
    final user= await ref.read(sessionProvider.notifier).getuser();

          Navigator.pushNamed(context, routesName.confirmOrder,arguments: user);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  

}