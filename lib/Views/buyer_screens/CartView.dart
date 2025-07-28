import 'package:ecommercefrontend/View_Model/buyerViewModels/OrderViewModel.dart';
import 'package:ecommercefrontend/View_Model/buyerViewModels/cartViewModel.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/cartModel.dart';
import '../shared/widgets/cartBottomBar.dart';
import '../../core/utils/colors.dart';

class Cartview extends ConsumerStatefulWidget {
  int id; //user id...
  Cartview({required this.id});

  @override
  ConsumerState<Cartview> createState() => _CartviewState();
}

class _CartviewState extends ConsumerState<Cartview> {
   Cart? userCart;
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
        backgroundColor: Appcolors.whiteColor,
        automaticallyImplyLeading: false,
        title: Text("Cart",style: AppTextStyles.headline,),
        actions: [
          state.when(
            loading: () => const SizedBox.shrink(),
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
      backgroundColor: Appcolors.whiteColor,
      body: state.when(
        loading: () => const Center(
      child: CircularProgressIndicator(color: Appcolors.blueColor),
    ),
    data: (cart) {
    if (kDebugMode) {
    print("Cart Data: ${cart?.toJson()}");
    }

    if (cart == null || cart.cartItems == null || cart.cartItems!.isEmpty) {
      userCart = cart;
    return const Center(child: Text("No Active Cart Found!"));
    }
    userCart=cart;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
          child: Column(
          children: [
          ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
          return  Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child:
              (item.product!.images?.isNotEmpty == true &&
              item.product!.images!.first.imageUrl?.isNotEmpty == true)
              ? Image.network(
              item.product!.images!.first.imageUrl!,
              fit: BoxFit.cover,
              width: 60.w,
              height: 50.h,
              errorBuilder: (context, error, stackTrace) {
              return  SizedBox(
              width: 60.w,
              height: 50.h,
              child: Icon(
              Icons.image_not_supported,
              size: 50.h,
              color: Colors.grey,
              ),
              );
              },
              )
                  :  SizedBox(
              width: 100.w,
              height: 100.h,
              child: Icon(
              Icons.image_not_supported,
              size: 50.h,
              color: Colors.grey,
              ),
              ),
              ),
               SizedBox(width: 16.w),
              Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Row(
                children: [
                  Text(
                  "${item.product!.name}",
                  style:  TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                  'Rs.${item.product!.price}',
                  style:  TextStyle(
                  fontSize: 14.sp,

                  ),
                  ),

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
                      Text('${item.quantity!}', style:  TextStyle(fontSize: 16.sp),),
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
                    ],
                  ),
                ],
              ),

              ],
              ),
              ),

              ],
              ),
              Divider()
            ],
          ),
          );

          },
          ),


          ],
          ),
          ),
        ),
      ],
    );
    },
    error: (error, stackTrace) =>
    Center(child: Text('Error: ${error.toString()}')),
    ),
      // Only show the bottom widget if userCart is not null
      bottomNavigationBar: userCart != null ? SafeArea(
          child: cartViewBottomWidget(cart: userCart!)
      ) : null,
    );
  }
}
