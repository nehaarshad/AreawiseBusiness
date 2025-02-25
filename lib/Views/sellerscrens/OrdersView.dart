import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/SellerViewModels/sellerOrderViewModel.dart';
import '../shared/Screens/orderDetailView.dart';
import '../shared/widgets/orderStatusColor.dart';


class OrdersView extends ConsumerStatefulWidget {
  final int sellerId;

  const OrdersView({super.key, required this.sellerId});

  @override
  ConsumerState<OrdersView> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrdersView> {
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(sellerOrderViewModelProvider(widget.sellerId.toString()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        elevation: 2,
      ),
      body: orderState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Error loading orders: $err",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Text("No orders available", style: TextStyle(fontSize: 18, color: Colors.grey),),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderRequest = orders[index];
              final order = orderRequest?.order;
              final cartItems = order?.cart?.cartItems;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ExpansionTile(
                  title: Text(
                    "Order #${order!.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status: ${orderRequest!.status}",
                        style: TextStyle(
                          color: StatusColor(orderRequest.status!),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Order Date: ${formatDate(order.createdAt)}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  children: [
                    if (cartItems != null)
                      ...cartItems.map((item) {
                        final product = item.product;
                        final imageUrl = product?.images?.isNotEmpty == true
                            ? product?.images!.first.imageUrl
                            : null;

                        return InkWell(
                          onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) => OrderDetailView(orderRequest: orderRequest),
                                  ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: imageUrl != null
                                      ? Image.network(
                                    imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const _ErrorImage(),
                                  )
                                      : const _ErrorImage(),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(product?.name ?? 'Unknown Product', style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Quantity: ${item.quantity}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'Price: \$${item.price}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  String formatDate(String? dateString) {
    if (dateString == null) return '../../..';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return 'Invalid Date';
    }
  }
}

class _ErrorImage extends StatelessWidget {
  const _ErrorImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[200],
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}