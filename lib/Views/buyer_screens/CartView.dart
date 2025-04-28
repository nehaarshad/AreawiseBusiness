import 'package:ecommercefrontend/View_Model/buyerViewModels/OrderViewModel.dart';
import 'package:ecommercefrontend/View_Model/buyerViewModels/cartViewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/cartModel.dart';
import '../shared/widgets/colors.dart';

class Cartview extends ConsumerStatefulWidget {
  int id; //user id...
  Cartview({required this.id});

  @override
  ConsumerState<Cartview> createState() => _CartviewState();
}

class _CartviewState extends ConsumerState<Cartview> {
  Cart? cart;
  var cartId;
  @override
  void initState() {
    super.initState();

    // Force refresh the cart data when this view is opened
    WidgetsBinding.instance.addPostFrameCallback((_) async{
        await ref.read(cartViewModelProvider(widget.id.toString()).notifier).getUserCart(widget.id.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartViewModelProvider(widget.id.toString())); //get user cart
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("CartView"),
        actions: [
          state.when(
            loading: () => const SizedBox.shrink(), // Hide button during loading
            data: (items) {
              cartId = items?.id; // Extract cart ID safely
              return IconButton(
                onPressed:
                    cartId != null
                        ? () async {
                          await ref.read(cartViewModelProvider(widget.id.toString(),).notifier)
                              .deleteUserCart(cartId.toString(),widget.id.toString(), context); //delete cart
                        }
                        : null, // Disable button if cart ID is null
                icon: const Icon(Icons.delete_rounded, color: Colors.red),
              );
            },
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(
              child: CircularProgressIndicator(color: Appcolors.blueColor),
            ),
        data: (cart) {
          if (kDebugMode) {
            print("Cart Data: ${cart?.toJson()}");
          }
          if (cart == null || cart.cartItems == null || cart.cartItems!.isEmpty) {
            return const SizedBox.shrink(
              child: Center(child: Text("No Active Cart Found!")),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.cartItems!.length,
                  itemBuilder: (context, index) {
                    final item = cart.cartItems![index];
                    if (item.product == null) {
                      if (kDebugMode) {
                        print("item have no product");
                      }
                      return const SizedBox.shrink();
                    }
                    if (kDebugMode) {
                      print("Image URL: ${item.product?.images?.first.imageUrl}");
                    }
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  (item.product!.images?.isNotEmpty == true &&
                                          item.product!.images!.first.imageUrl?.isNotEmpty == true)
                                      ? Image.network(
                                        item.product!.images!.first.imageUrl!,
                                        fit: BoxFit.cover,
                                        width:
                                            100, // Fixed width instead of double.infinity
                                        height: 100,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      )
                                      : const SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item.product!.name}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${item.product!.price}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed:
                                            (item.quantity != null &&
                                                    item.quantity! > 1)
                                                ? () {
                                                  int newQuantity =
                                                      item.quantity! -
                                                      1; // Decrease quantity
                                                  if (kDebugMode) {
                                                    print("Decrement to: $newQuantity");
                                                  }
                                                  ref
                                                      .read(
                                                        cartViewModelProvider(
                                                          widget.id.toString(),
                                                        ).notifier,
                                                      )
                                                      .updateCartItem(
                                                        widget.id.toString(),
                                                        item.id!.toString(),
                                                        newQuantity,
                                                      );
                                                }
                                                : null, // Disable button if quantity is 1
                                        icon: const Icon(Icons.remove_circle_outline),
                                      ),
                                      Text('${item.quantity!}', style: const TextStyle(fontSize: 16),),
                                      IconButton(
                                        onPressed:
                                            (item.quantity != null &&
                                                    item.product!.stock != null &&
                                                    item.quantity! <
                                                        item
                                                            .product!
                                                            .stock!) // Correct condition
                                                ? () {
                                                  int newQuantity =
                                                      item.quantity! +
                                                      1; // Increase quantity
                                                  if (kDebugMode) {
                                                    print("Increment to: $newQuantity");
                                                  }
                                                  ref.read(cartViewModelProvider(widget.id.toString(),).notifier,)
                                                      .updateCartItem(widget.id.toString(), item.id!.toString(), newQuantity,);
                                                }
                                                : null, // Disable if max stock is reached
                                        icon: const Icon(Icons.add_circle_outline),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          ref.read(cartViewModelProvider(widget.id.toString(),).notifier,).deleteCartItem(item.id.toString(),widget.id.toString());
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) =>
                Center(child: Text('Error: ${error.toString()}')),),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(100, 0, 100, 100),
        child: SizedBox(
          height: 50.0,
          child: ElevatedButton(
            onPressed: () async{
              print('cart ID Sent: ${cartId}');
              await ref.read(orderViewModelProvider.notifier).checkOut(cartId.toString(), context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.blueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            child: const Text(
              "CheckOut",
              style: TextStyle(
                color: Appcolors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
