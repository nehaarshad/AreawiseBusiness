import 'package:ecommercefrontend/Views/buyer_screens/widgets/paymentMethod.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/models/paymentModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/buyerViewModels/OrderViewModel.dart';

class paymentInstructions extends ConsumerStatefulWidget {
  final List<paymentModel> order;
  final String userid;
  final int cartId;
   paymentInstructions({super.key,required this.order,required this.userid,required this.cartId});

  @override
  ConsumerState<paymentInstructions> createState() => _paymentInstructionsState();
}

class _paymentInstructionsState extends ConsumerState<paymentInstructions> {

  bool showInstructuons=true;
  bool showProducts=false;
  int expectedTranscriptUpload=0;
  final GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();
  PaymentMethod paymentMethod=PaymentMethod.jazzCash;
  // Track uploaded slips for each seller
  Map<String, bool> uploadedSlips = {};

  @override
  void initState() {
    super.initState();
    expectedTranscriptUpload=widget.order.length;
    // Initialize uploaded slips tracking
    for (var order in widget.order) {
      if (order.sellerId != null) {
        uploadedSlips[order.sellerId!] = false;
      }
    }
    print("expectedslips ${expectedTranscriptUpload}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    expectedTranscriptUpload=widget.order.length;
    print("expectedslips ${expectedTranscriptUpload}");
  }

  // Method to check if all slips are uploaded
  bool areAllSlipsUploaded() {
    return uploadedSlips.values.every((uploaded) => uploaded);
  }

  // Method to get count of uploaded slips
  int getUploadedSlipsCount() {
    return uploadedSlips.values.where((uploaded) => uploaded).length;
  }

  Widget sendAddress(AsyncValue<List<paymentModel> > state, OrderViewModelProvider viewModel, BuildContext context,) {
    bool allSlipsUploaded = areAllSlipsUploaded();

    return InkWell(
      onTap: allSlipsUploaded ? (){
        deliveryAddressData(viewModel, widget.cartId,context);
      } : (){
        Utils.flushBarErrorMessage("Please upload transaction slips for all sellers", context);
      },
      child: Container(
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 25.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: allSlipsUploaded ? Appcolors.baseColor : Colors.grey,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child:Text(
              allSlipsUploaded ? "Place Order" : "Upload All Slips First (${getUploadedSlipsCount()}/${expectedTranscriptUpload})",
              style: TextStyle(
                  color: Appcolors.whiteSmoke,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp
              )
          ),
        ),
      ),
    );
  }

  Widget instructions(){
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("Online Payment Instructions",style: TextStyle(color: Appcolors.baseColor,fontWeight: FontWeight.w500,fontSize: 15.sp))),
            SizedBox(height: 10.h,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text("⚠️ VERY IMPORTANT:",style: TextStyle(color: Appcolors.baseColorLight30,fontWeight: FontWeight.w400,fontSize: 14.sp)),
                  RichText(text:TextSpan(text: "1. If you have items from multiple sellers, you must pay ALL sellers ",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                  RichText(text:TextSpan(text: "2. You cannot pay only one seller and leave others - this may cause your payment to be lost",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                  RichText(text:TextSpan(text: "3. Each seller needs to receive their payment separately",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                  RichText(text:TextSpan(text: "4. If you upload a wrong or fake receipt, the payment amount doesn't match, or if the receipt is unclear or damaged, you will have to pay Cash on Delivery instead",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Step 1: Choose Your Payment Method",style: TextStyle(color: Appcolors.baseColorLight30,fontWeight: FontWeight.w400,fontSize: 14.sp)),
                  RichText(text:TextSpan(text: "Select one of these payment options: JazzCash, EasyPaisa, Bank Transfer",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Step 2: Send Payment to Each Seller",style: TextStyle(color: Appcolors.baseColorLight30,fontWeight: FontWeight.w400,fontSize: 14.sp)),
                  RichText(text:TextSpan(text: "1. Send the exact amount to each seller's account using your chosen payment method",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                  RichText(text:TextSpan(text: "2. Keep all transaction receipts - you'll need them for proof",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Step 3: Upload Transaction Slips",style: TextStyle(color: Appcolors.baseColorLight30,fontWeight: FontWeight.w400,fontSize: 14.sp)),
                  RichText(text:TextSpan(text: "1. Take a clear photo of your payment receipt/transaction slip",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                  RichText(text:TextSpan(text: "2. Upload the correct receipt for the correct seller",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                  RichText(text:TextSpan(text: "3. Make sure the receipt shows: Payment amount, Date and time, Your phone number, Transaction ID",
                      style: TextStyle(color: Colors.grey,wordSpacing: 5,fontWeight: FontWeight.normal,fontSize: 14.sp)) ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){
                  setState(() {
                    showInstructuons = false;
                  });
                }, child: Text("OK")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget sellerAccountPayment( AsyncValue<List<paymentModel> > state,OrderViewModelProvider viewModel){
    return Column(
      children: [
         Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: paymentMehtodSelection(),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.order.length,
                itemBuilder: (context, index) {
                  final sellers = widget.order[index];
                  if (sellers == null) {
                    return const SizedBox.shrink();
                  }

                  bool isSlipUploaded = uploadedSlips[sellers.sellerId] ?? false;

                  return Card(
                    color: Appcolors.whiteSmoke,
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child:Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: Icon(Icons.store,size: 18.h,),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${sellers.items![0].product!.shop?.shopname}",
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.sp),
                                    ),
                                  ),
                                  if (isSlipUploaded)
                                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                                ],
                              ),
                              Text(
                                "Total: ${sellers.amount}",
                                style: TextStyle(fontWeight: FontWeight.w400,color: Appcolors.baseColor,fontSize: 14.sp),
                              ),
                            ],
                          ),
                          subtitle:sellerAccounts(sellers),
                        ),
                        TextButton(onPressed: () async {
                          if (sellers.sellerId != null) {
                            final parameters={
                              'orderId' : sellers.orderId,
                              'sellerId': int.tryParse(sellers.sellerId!),
                              'shop':sellers.items![0].product!.shop?.shopname
                            };
                            print("Passed parameters ${parameters}");

                            // Navigate and wait for result
                            final result = await Navigator.pushNamed(
                                context,
                                routesName.makePayment,
                                arguments: parameters
                            );

                            // Update upload status when returning
                            if (result == true) {
                              setState(() {
                                uploadedSlips[sellers.sellerId!] = true;
                              });
                            }
                          }
                        }, child: Container(

                          child: Center(
                              child: Text(
                                isSlipUploaded ? "Slip Uploaded ✓" : "Upload Slip",
                                style: TextStyle(
                                  color: isSlipUploaded ? Colors.green : Appcolors.baseColor,
                                ),
                              )
                          ),
                          decoration: BoxDecoration(
                            color: Appcolors.whiteSmoke,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: isSlipUploaded ? Colors.green : Appcolors.baseColor,
                              width: 1.0,
                            ),
                          ),
                          height: 25.h,
                          width: 130.w,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Items from this seller",style: TextStyle(fontWeight: FontWeight.w500),),
                                  IconButton(
                                      onPressed: (){
                                        setState(() {
                                          showProducts=!showProducts;
                                        });
                                      },
                                      icon: showProducts ?
                                      Icon(Icons.arrow_drop_up,size: 30,color: Appcolors.baseColor,)
                                          :
                                      Icon(Icons.arrow_drop_down_outlined,size: 30,color: Appcolors.baseColor,)
                                  )
                                ],
                              ),
                              showProducts ? sellerProductsOrdered(sellers) : SizedBox.shrink()
                            ],
                          ),
                        ),
                        // Show upload status for each seller
                        if (sellers.sellerId != null && !(uploadedSlips[sellers.sellerId!] ?? false))
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                              child: Text(
                                "⚠️ Transaction slip required for this seller",
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

        // Always show the button but make it conditional
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: sendAddress(state,viewModel,context),
        ),
      ],
    );
  }

  Widget paymentMehtodSelection() {
    return    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w400,color: Appcolors.baseColorLight30,fontSize: 15.sp)),
        SizedBox(width: 30.w,),
        Row(
          children: [
            Radio(
              value: PaymentMethod.jazzCash,
              groupValue: paymentMethod,
              onChanged: ( value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),
            Text('jazzCash'),
            SizedBox(width: 8),
            Radio(
              value: PaymentMethod.easyPaisa,
              groupValue: paymentMethod,
              onChanged: ( value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),
            Text('easyPaisa'),

          ],
        ),
        Row(
          children: [
            Radio(
              value: PaymentMethod.bankTransfer,
              groupValue: paymentMethod,
              onChanged: ( value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),
            Text('bankTransfer'),

          ],
        ),

      ],
    );
  }

  Widget sellerAccounts( paymentModel payment){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Available Accounts"),
        Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:payment.accounts?.length,
          itemBuilder: (context, index) {
            final sellers = payment.accounts?[index];
            if (sellers == null) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("HolderName: ${sellers.accountHolderName}"),
                Text("Account Type: ${sellers.accountType}"),
                sellers.accountType=='bankAccount' ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bank: ${sellers.bankName}"),
                    Text("IBAN: ${sellers.IBAN}"),
                  ],
                )
                    :
                SizedBox.shrink()
                ,
                Text("Account Number: ${sellers.accountNumber}"),
                Divider(),

              ],
            );
          },
        ),
      ],
    );
  }

  Widget sellerProductsOrdered( paymentModel payment){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:payment.items?.length,
          itemBuilder: (context, index) {
            final items = payment.items?[index];
            if (items == null) {
              return const SizedBox.shrink();
            }
            return ListTile(
              title:Text("Quantity: ${items.quantity!}"),
              subtitle: Text("Product: ${items.product?.name!}"),
              trailing: Text("Total: ${items.price}"),
            );
          },
        ),
        Divider(),
      ],
    );
  }

  void deliveryAddressData(OrderViewModelProvider viewModel, int cartId,BuildContext context) {

     if (!areAllSlipsUploaded()) {
      Utils.flushBarErrorMessage("Please upload transaction slips for all sellers (${getUploadedSlipsCount()}/${expectedTranscriptUpload})", context);
      return;
    }
    else if (viewModel.key?.currentState?.validate() != true) {
      Utils.flushBarErrorMessage("Please complete shipping address", context);
      return;
    }
    else {
      final data = {
        'cartId':cartId,
        'sector': viewModel.sector.text,
        'city': viewModel.city.text,
        'address': viewModel.address.text,
        'paymentMethod':paymentMethod.value,
        'paymentStatus':"paid"
      };
      print('Form Data: $data');
      viewModel.placeOrder(data,widget.userid,context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state=ref.watch(orderViewModelProvider);
    final viewModel=ref.read(orderViewModelProvider.notifier);
    return Form(
      key: paymentFormKey,
      child: showInstructuons == true ? instructions() : sellerAccountPayment(state, viewModel),
    );
  }
}