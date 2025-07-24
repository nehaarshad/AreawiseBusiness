import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SellerViewModels/sellerOrderViewModel.dart';
import '../../../View_Model/buyerViewModels/ordersHistoryViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/orderStatusColor.dart';

class OrdersHistoryView extends ConsumerStatefulWidget {
  String id;
   OrdersHistoryView({super.key,required this.id});

  @override
  ConsumerState<OrdersHistoryView> createState() => _OrdersHistoryViewState();
}

class _OrdersHistoryViewState extends ConsumerState<OrdersHistoryView> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() => loadHistory());
  }
  void loadHistory() {

      ref.read(orderHistoryViewModelProvider(widget.id.toString()).notifier).getCustomerOrdersHistory(widget.id.toString());

  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderHistoryViewModelProvider(widget.id.toString()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders History"),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(sellerOrderViewModelProvider(widget.id.toString()));
            },
          ),
        ],
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
              child: Text("No orders available", style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final cartItems = order?.cart?.cartItems;

              return Card(
                elevation: 3,
                margin:  EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                child: ExpansionTile(
                  title: Text(
                    "Order #${order?.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total: \$${order?.total?.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Order Date: ${_formatDate(order?.createdAt)}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  children: [
                    if (cartItems != null && cartItems.isNotEmpty)
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            const Divider(),
                             Text(
                              "Ordered Items",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                             SizedBox(height: 8.h),
                            ...cartItems.map((item) {
                              final product = item.product;
                              final imageUrl = product?.images?.isNotEmpty == true
                                  ? product?.images?.first.imageUrl
                                  : null;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: imageUrl != null
                                          ? Image.network(
                                        imageUrl,
                                        width: 80.w,
                                        height: 80.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                        const _ErrorImage(),
                                      )
                                          : const _ErrorImage(),
                                    ),
                                     SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product?.name ?? 'Unknown Product',
                                            style:  TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                           SizedBox(height: 4.h),
                                          Text(
                                            'Quantity: ${item.quantity}',
                                            style:  TextStyle(fontSize: 14.sp),
                                          ),
                                          Text(
                                            'Price: \$${item.price}',
                                            style:  TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Status: ${item.status}',
                                            style: TextStyle(
                                              color: _getItemStatusColor(item.status),
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Color _getItemStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

}

class _ErrorImage extends StatelessWidget {
  const _ErrorImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.h,
      color: Colors.grey[200],
      child:  Icon(
        Icons.image_not_supported,
        size: 40.h,
        color: Colors.grey,
      ),
    );
  }
}