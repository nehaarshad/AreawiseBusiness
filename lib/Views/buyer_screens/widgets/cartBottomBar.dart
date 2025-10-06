import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/adminViewModels/DeliveryOrderAttributesViewModel.dart';
import '../../../View_Model/buyerViewModels/OrderViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/cartModel.dart';
import '../../../core/utils/colors.dart';

class cartViewBottomWidget extends ConsumerStatefulWidget {
  final Cart cart;
  cartViewBottomWidget({super.key,required this.cart});

  @override
  ConsumerState<cartViewBottomWidget> createState() => _cartViewBottomWidgetState();
}

class _cartViewBottomWidgetState extends ConsumerState<cartViewBottomWidget> {

   int discount=0;
   String Offer='0.0';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(attributesViewModelProvider.notifier)
          .getAttributes()
          .then((_) {
        final attribute =
            ref
                .read(attributesViewModelProvider)
                .value;
        print('Loaded Attributes: ${attribute}');
        if (attribute != null) {
         String discountString = attribute.discount!;
         double discountDouble = double.parse(discountString);
          discount = (discountDouble * 100).toInt();

         Offer=attribute.totalBill!;
        }
      });
    });
  }
  // Calculate subtotal from cart items
  double calculateSubtotal(Cart cart) {
    double subtotal = 0;
    if (cart.cartItems != null) {
      for (var item in cart.cartItems!) {
        if (item != null && item.price != null) {
          subtotal += item.price!;
        }
      }
    }
    return subtotal;
  }

  @override
  Widget build(BuildContext context) {


    double subtotal = calculateSubtotal(widget.cart);
    double total = subtotal ;

    return Container(
      height: 240.h,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r),topRight: Radius.circular(40.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 1.r,
            blurRadius: 5.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            "Order Summary",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold
            ),
          ),
           SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal:"),
              Text("Rs.${subtotal.toStringAsFixed(2)}", style:  TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
           SizedBox(height: 8.h),

          total < (double.tryParse(Offer) ?? 5000.0 )
              ?
          Center(child: Text("${discount}% Discount is Offer, if you spent RS.${Offer} ", style:  TextStyle(fontWeight: FontWeight.w300,color: Appcolors.baseColor)))
              :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Discount:"),
              Text("Rs.${discount}%", style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
           Divider(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
              total < (double.tryParse(Offer) ?? 5000.0 )
                  ?
              Text("Rs.${(total ).toStringAsFixed(2)}",
                  style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Appcolors.baseColor
                  )
              ):
              Text( "Rs.${(total-(total*discount/100))}",
                  style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Appcolors.baseColor
                  )
              ),

            ],
          ),
           SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: widget.cart.id != null && widget.cart.cartItems != null && widget.cart.cartItems!.length>0 ? () async {

              final cartid=  await ref.read(orderViewModelProvider.notifier).checkOut(widget.cart.id.toString(), total,Offer, context);
                final parameters = {
                  'CartId': cartid,
                  'userid': widget.cart.userId.toString(),
                };
                print("parameters ${parameters}");
                Navigator.pushNamed(
                    context,
                    routesName.deliveryAddress,
                    arguments: parameters
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.baseColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0.r),
                ),
              ),
              child:  Text(
                "CHECKOUT",
                style: TextStyle(
                  color: Appcolors.whiteSmoke,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

    