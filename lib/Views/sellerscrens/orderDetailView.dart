import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
             SizedBox(height: 16.h),
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
                          borderRadius: BorderRadius.circular(8.r),
                          child: imageUrl != null ? CachedNetworkImage(
                        imageUrl:     imageUrl,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) => const _ErrorImage(),
                          ) : const _ErrorImage(),
                        ),
                         SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product?.name ?? 'Unknown Product', style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                               SizedBox(height: 4.h),
                              Text('Quantity: ${item.quantity}', style:  TextStyle(fontSize: 14.sp)),
                              Text('Price: ${item.price}', style:  TextStyle(fontSize: 14.sp)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              }).toList(),
             SizedBox(height: 16.h),
            Center(child: Text("User Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),)),
             SizedBox(height: 8.h),
            infoWidget(heading:"Name" ,value: "${order?.cart?.user?.username }" ,),
            infoWidget(heading:"Contact Number" ,value: "${order?.cart?.user?.contactnumber }"),
             SizedBox(height: 16.h),
            Center(child: Text("Shipping Address",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp))),
             SizedBox(height: 8.h),
            infoWidget(heading:"Address" ,value: "${order?.cart?.user?.address?.address }" ,),
            infoWidget(heading:"City" ,value: "${order?.cart?.user?.address?.city }" ,),
            infoWidget(heading:"Sector" ,value: "${order?.cart?.user?.address?.sector }" ,),
             SizedBox(height: 8.h),
            Row(
              children: [
                Text("Current Status:",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp
                ),),
                Text(
                  " ${currentOrderRequest.status}",
                  style: TextStyle(
                    color: StatusColor(currentOrderRequest.status!),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp
                  ),
                ),
              ],
            ),
             SizedBox(height: 16.h),
            if (currentOrderRequest.status == "Requested")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => updateStatus("Approved"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Approve",style: TextStyle(color: Appcolors.whiteSmoke),),
                    ),
                  ),
                   SizedBox(width: 16.w),
                  if(widget.orderRequest.order?.paymentStatus != "paid")
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => updateStatus("Rejected"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Reject",style: TextStyle(color: Appcolors.whiteSmoke),),
                    ),
                  ),
                ],
              ),
            if (currentOrderRequest.status == "Approved")
              ElevatedButton(
                onPressed: () => updateStatus("Dispatched"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                child: const Text("Dispatched",style: TextStyle(color: Appcolors.whiteSmoke),),
              ),
            if (currentOrderRequest.status == "Dispatched")
              ElevatedButton(
                onPressed: () => updateStatus("Delivered"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Delivered",style: TextStyle(color: Appcolors.whiteSmoke),),
              ),
            if (currentOrderRequest.status == "Delivered")
              ElevatedButton(
                onPressed: () => updateStatus("Completed"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Mark as Completed",style: TextStyle(color: Appcolors.whiteSmoke),),
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