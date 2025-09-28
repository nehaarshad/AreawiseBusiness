import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SellerViewModels/sellerOrderViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/loadingState.dart';
import '../shared/widgets/orderStatusColor.dart';


class OrdersView extends ConsumerStatefulWidget {
  final int sellerId;

  const OrdersView({super.key, required this.sellerId});

  @override
  ConsumerState<OrdersView> createState() => _OrderListScreenState();
}
class _OrderListScreenState extends ConsumerState<OrdersView> {
  String? _selectedStatus; // null means "All"
  List<String> statusOptions = [
    'All',
    'requested',
    'approved',
    'rejected',
    'dispatched',
    'delivered',
    'completed'
  ];

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(sellerOrderViewModelProvider(widget.sellerId.toString()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(sellerOrderViewModelProvider(widget.sellerId.toString()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status filter buttons
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // All button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStatus = null;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        color: _selectedStatus == null
                            ? Appcolors.baseColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Appcolors.baseColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "All",
                        style: TextStyle(
                          color: _selectedStatus == null
                              ? Colors.white
                              : Appcolors.baseColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Status buttons
                  ...statusOptions.where((status) => status != 'All').map((status) =>
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStatus = status;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: _selectedStatus == status
                                ? Appcolors.baseColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Appcolors.baseColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: _selectedStatus == status
                                  ? Colors.white
                                  : Appcolors.baseColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ).toList(),
                ],
              ),
            ),
          ),

          // Orders list
          Expanded(
            child: orderState.when(
              loading: () => const Column(
                children: [
                  ShimmerListTile(),
                  ShimmerListTile(),
                  ShimmerListTile(),
                  ShimmerListTile(),
                ],
              ),
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
                // Filter orders based on selected status
                final filteredOrders = _selectedStatus == null || _selectedStatus == 'All'
                    ? orders
                    : orders.where((order) => order?.status?.toLowerCase() == _selectedStatus?.toLowerCase()).toList();

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Text(
                      _selectedStatus == null || _selectedStatus == 'All'
                          ? "No orders available"
                          : "No $_selectedStatus orders",
                      style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final orderRequest = filteredOrders[index];
                    print(orderRequest?.total);
                    final order = orderRequest?.order;
                    final cartItems = order?.cart?.cartItems;

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                      child: ExpansionTile(
                        title: Text(
                          "Order #${order!.id}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Appcolors.baseColor),
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
                              "Discount %: ${order.discount} , ( - Rs.${order.discountAmount} )",
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Order Date: ${orderedDate(order.updatedAt)}",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text(
                              "Payment Status: ${orderRequest.order?.paymentStatus}",
                              style: TextStyle(fontSize: 12.sp),
                            ),

                            if(orderRequest.order?.paymentStatus == "paid")
                              TextButton(
                                  onPressed: (){
                                    final parameters={
                                      'orderId': orderRequest.orderId,
                                      'sellerId': orderRequest.sellerId
                                    };
                                    print("Passing params: ${parameters}");
                                    Navigator.pushNamed(context, routesName.transactionSlip, arguments: parameters);
                                  },
                                  child: Text("View Receipt")
                              )
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Total ${orderRequest.total?.toStringAsFixed(2)}"),
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
                                  Navigator.pushNamed(context, routesName.orderDetails, arguments: orderRequest);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: imageUrl != null
                                            ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          width: 80.w,
                                          height: 80.h,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, error, stackTrace) => const _ErrorImage(),
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
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              'Quantity: ${item.quantity}',
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                            Text(
                                              'Price: ${item.price!.toStringAsFixed(2)}',
                                              style: TextStyle(fontSize: 14.sp),
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
          ),
        ],
      ),
    );
  }

  String orderedDate(String? dateString) {
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