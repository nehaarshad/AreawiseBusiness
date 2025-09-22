import 'package:ecommercefrontend/View_Model/buyerViewModels/OrderViewModel.dart';
import 'package:ecommercefrontend/Views/buyer_screens/onlineTransactionInstructions.dart';
import 'package:ecommercefrontend/Views/buyer_screens/widgets/paymentMethodSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/notifyUtils.dart';
import '../../models/paymentModel.dart';

class deliveryAddress extends ConsumerStatefulWidget {
  int cartId;
  String userid;
  deliveryAddress({required this.userid,required this.cartId});

  @override
  ConsumerState<deliveryAddress> createState() => _deliveryAddressState();
}

class _deliveryAddressState extends ConsumerState<deliveryAddress> {

  final GlobalKey<FormState> deliveryFormKey  = GlobalKey<FormState>();
  PaymentMethodSelection paymentMethod=PaymentMethodSelection.COD;
  bool isOnline=false;

  Widget formFields(OrderViewModelProvider model) {
    return Column(
      children: [
        TextFormField(
          controller: model.sector,
          decoration: const InputDecoration(labelText: "Sector"),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter sector';
            }
            return null;
          },
        ),
         SizedBox(height: 10.h),
        TextFormField(
          controller: model.city,
          decoration: const InputDecoration(labelText: "City"),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter city';
            }
            return null;
          },
        ),
         SizedBox(height: 10.h),
        TextFormField(
          controller: model.address,
          decoration: const InputDecoration(labelText: "Address"),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget sendAddress(AsyncValue<List<paymentModel> > state, OrderViewModelProvider viewModel, BuildContext context,) {
    return InkWell(
      onTap: (){
        deliveryAddressData(viewModel, widget.cartId,context);
      },
      child: Container(
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 25.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Appcolors.baseColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child:Text("Place Order", style: TextStyle(color: Appcolors.whiteSmoke,fontWeight: FontWeight.bold,fontSize: 15.sp)),
        ),
      ),
    );
  }

  void deliveryAddressData(OrderViewModelProvider viewModel, int cartId,BuildContext context) {
    if (paymentMethod == null) {
      Utils.flushBarErrorMessage("Please select a payment method", context);
      return;
    }
    if (viewModel.key.currentState!.validate()) {
      final data = {
        'cartId':cartId,
        'sector': viewModel.sector.text,
        'city': viewModel.city.text,
        'address': viewModel.address.text,
        'paymentMethod':"cash",
        'paymentStatus':"cashOnDelivery"
      };
      print('Form Data: $data');
      viewModel.placeOrder(data,widget.userid,context);

    }
    else {
      Utils.flushBarErrorMessage("provide Shipping Address", context);
    }
  }

  @override
  Widget build(BuildContext context) {
   final state=ref.watch(orderViewModelProvider);
    final viewModel=ref.read(orderViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () async{
              await viewModel.cancelOrder(widget.cartId.toString());
              Navigator.of(context).pop();
            },
            child: const Text('Back'),
          ),
        ],
      ),
      body: state.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: Appcolors.blackColor),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (user) {
          if (user != null) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: viewModel.key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add Address",style: TextStyle(color: Appcolors.baseColorLight30,fontWeight: FontWeight.bold,fontSize: 18.sp),),
                    SizedBox(height: 10.h),
                    formFields(viewModel),

                    SizedBox(height: 20.h),
                    Text("Make Payment",style: TextStyle(color: Appcolors.baseColorLight30,fontWeight: FontWeight.bold,fontSize: 18.sp),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: PaymentMethodSelection.COD,
                              groupValue: paymentMethod,
                              onChanged: ( value) {
                                setState(() {
                                  paymentMethod = value!;
                                  isOnline=false;
                                });
                              },
                            ),
                            Text('cash on delivery'),
                          ],
                        ),

                        SizedBox(width: 15),
                        Row(
                          children: [
                            Radio(
                              value: PaymentMethodSelection.online,
                              groupValue: paymentMethod,
                              onChanged: ( value) {
                                setState(() {
                                  paymentMethod = value!;
                                  isOnline=true;
                                });
                              },
                            ),
                            Text('Online Transaction'),
                          ],
                        ),

                      ],
                    ),

                    if(isOnline)
                      paymentInstructions(order: state.value!,userid: widget.userid,cartId: widget.cartId,),



                    SizedBox(height: 20.h),
                    if(!isOnline)
                    sendAddress(state,viewModel,context),
                  ],
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
