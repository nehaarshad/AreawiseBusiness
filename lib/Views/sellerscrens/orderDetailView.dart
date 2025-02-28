import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../View_Model/SellerViewModels/sellerOrderViewModel.dart';
import '../../models/ordersRequestModel.dart';
import '../shared/widgets/infoRow.dart';
import '../shared/widgets/orderStatusColor.dart';

class OrderDetailView extends ConsumerStatefulWidget {
  final OrdersRequestModel orderRequest;

  const OrderDetailView({super.key, required this.orderRequest});

  @override
  ConsumerState<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends ConsumerState<OrderDetailView> {

  late OrdersRequestModel currentOrderRequest;

  @override
  void initState() {
    super.initState();
    // Initialize with the passed orderRequest
    currentOrderRequest = widget.orderRequest;
  }

  @override
  Widget build(BuildContext context) {
    final order = currentOrderRequest.order;
    final cartItems = order?.cart?.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${order?.id}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Details",),
            const SizedBox(height: 16),
            if (cartItems != null)
              ...cartItems.map((item) {
                final product = item.product;
                final imageUrl = product?.images?.isNotEmpty == true
                    ? product?.images!.first.imageUrl
                    : null;

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl != null ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const _ErrorImage(),
                          ) : const _ErrorImage(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product?.name ?? 'Unknown Product', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('Quantity: ${item.quantity}', style: const TextStyle(fontSize: 14)),
                              Text('Price: \$${item.price}', style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              }).toList(),
            const SizedBox(height: 16),
            Center(child: Text("User Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
            const SizedBox(height: 8),
            infoWidget(heading:"Name" ,value: "${order?.cart?.user?.username }" ,),
            infoWidget(heading:"Contact Number" ,value: "${order?.cart?.user?.contactnumber }"),
            const SizedBox(height: 16),
            Center(child: Text("Shipping Address",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
            const SizedBox(height: 8),
            infoWidget(heading:"Address" ,value: "${order?.cart?.user?.address?.address }" ,),
            infoWidget(heading:"City" ,value: "${order?.cart?.user?.address?.city }" ,),
            infoWidget(heading:"Sector" ,value: "${order?.cart?.user?.address?.sector }" ,),
            const SizedBox(height: 8),
            Row(
              children: [
                Text("Current Status:",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                ),),
                Text(
                  " ${currentOrderRequest.status}",
                  style: TextStyle(
                    color: StatusColor(currentOrderRequest.status!),
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (currentOrderRequest.status == "Requested")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => updateStatus("Approved"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Approve"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => updateStatus("Rejected"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Reject"),
                    ),
                  ),
                ],
              ),
            if (currentOrderRequest.status == "Approved")
              ElevatedButton(
                onPressed: () => updateStatus("Dispatched"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Dispatched"),
              ),
            if (currentOrderRequest.status == "Dispatched")
              ElevatedButton(
                onPressed: () => updateStatus("Delivered"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Delivered"),
              ),
            if (currentOrderRequest.status == "Delivered")
              ElevatedButton(
                onPressed: () => updateStatus("Completed"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Mark as Completed"),
              ),
          ],
        ),
      ),
    );
  }

  void updateStatus(String newStatus) async {
    await ref.read(sellerOrderViewModelProvider(currentOrderRequest.sellerId.toString()).notifier).
    updateOrdersStatus(
        currentOrderRequest.orderId!.toString(),
        currentOrderRequest.customerId.toString(),
        currentOrderRequest.orderProductId!,newStatus,context);
    Utils.flushBarErrorMessage("updated to ${newStatus}", context);
    ref.refresh(sellerOrderViewModelProvider(currentOrderRequest.sellerId.toString()));
    setState(() {
      currentOrderRequest = currentOrderRequest.copyWith(status: newStatus);
    });
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