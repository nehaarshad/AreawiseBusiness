import 'package:ecommercefrontend/View_Model/SellerViewModels/paymentAccountViewModel.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/colors.dart';
import '../shared/widgets/buttons.dart';

class addSellerAccount extends ConsumerStatefulWidget {
  final int userid;
  const addSellerAccount({super.key,required this.userid});

  @override
  ConsumerState<addSellerAccount> createState() => _addSellerAccountState();
}

class _addSellerAccountState extends ConsumerState<addSellerAccount> {


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(sellerPaymentAccountViewModelProvider(widget.userid.toString()).notifier);

    return Padding(
            padding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 3.w),
            child: Form(
              key: viewModel.formkey,

              child: Column(
                spacing: 10.h,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // accountType field
                  accountTypeDropdown(),

                  // accountNumber field
                  TextFormField(
                    controller: viewModel.accountNumber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Account Number",
                      prefixIcon: Icon(Icons.keyboard_control),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),

                   if(viewModel.isBank)
                   TextFormField(
                     controller: viewModel.bankName,
                     decoration: InputDecoration(
                       hintText: "Bank Name",
                       prefixIcon: Icon(Icons.account_balance_sharp),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8.0.r),
                       ),
                     ),
                     validator: (value) {
                       return null;
                     },
                   ),

                  if(viewModel.isBank)
                  TextFormField(
                    controller: viewModel.IBAN,
                    decoration: InputDecoration(
                      hintText: "IBAN ",
                      prefixIcon: Icon(Icons.numbers_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                    ),
                    validator: (value) {

                      return null;
                    },
                  ),


                  TextFormField(
                    controller: viewModel.accountHolderName,
                    decoration: InputDecoration(
                      hintText: "Account HolderName",
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                    ),
                    validator: (value) {

                      return null;
                    },
                  ),
                  // SignUp button
                  // Consumer(
                  //   builder: (context, ref, child) {
                  //     final loading = ref.watch(sellerPaymentAccountViewModelProvider(widget.userid.toString()));
                  //     return CustomButton(
                  //       text: "Add Account",
                  //       onPressed: handleSubmission,
                  //       isLoading: false,
                  //     );
                  //   },
                  // ),

                ],
              ),
            ),
          );

  }
  Widget accountTypeDropdown() {
    final viewModel = ref.read(sellerPaymentAccountViewModelProvider(widget.userid.toString()).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: viewModel.accountType,
          decoration: InputDecoration(
            hintText: "Account Type",
            prefixIcon: Icon(Icons.account_balance_wallet_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),
          ),
          validator: (value) {
            return null;
          },
          onChanged: (value) {
            setState(() {
              viewModel.accountType = value;
            });

            if(value=="bankAccount"){
              viewModel.isBank=true;
            }
            else {
              viewModel.isBank = false;
            }
          },
          items: const [
            DropdownMenuItem(value: "jazzcash", child: Text("JazzCash")),
            DropdownMenuItem(value: "easypaisa", child: Text("EasyPaisa")),
            DropdownMenuItem(value: "bankAccount", child: Text("Bank Account")),
          ],
        ),
      ],
    );
  }
}
