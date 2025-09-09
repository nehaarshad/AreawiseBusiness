import 'package:ecommercefrontend/View_Model/SellerViewModels/paymentAccountViewModel.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/widgets/buttons.dart';

class addSellerAccount extends ConsumerStatefulWidget {
  final int userid;
  const addSellerAccount({super.key,required this.userid});

  @override
  ConsumerState<addSellerAccount> createState() => _addSellerAccountState();
}

class _addSellerAccountState extends ConsumerState<addSellerAccount> {

  final formkey = GlobalKey<FormState>();
  bool isBank=false;
  TextEditingController bankName=TextEditingController();
  TextEditingController IBAN=TextEditingController();
  TextEditingController accountNumber=TextEditingController();
  TextEditingController accountHolderName=TextEditingController();
  String? accountType;

  @override
  void dispose() {
    super.dispose();
    bankName.dispose();
    IBAN.dispose();
    accountHolderName.dispose();
    accountNumber.dispose();
    accountType=null;

  }

  Widget accountTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: accountType,
          decoration: InputDecoration(
            hintText: "Account Type",
            prefixIcon: Icon(Icons.account_balance_wallet_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select accountType";
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              accountType = value;
            });

            if(value=="bankAccount"){
              isBank=true;
            }
            else {
              isBank = false;
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

  @override
  Widget build(BuildContext context) {
    final addAccountModel = ref.read(sellerPaymentAccountViewModelProvider(widget.userid.toString()).notifier);

    void handleSubmission(){
      if (formkey.currentState!.validate()) {
       if(accountType== null || accountHolderName.text.trim().isEmpty || accountNumber.text.trim().isEmpty){

         Utils.flushBarErrorMessage("All fields are required to fill", context);
         return;
       }
        else {
         print("${accountType}, ${accountNumber} ${accountHolderName} ${IBAN} ${bankName}");
          addAccountModel.addPaymentAcconts(
              widget.userid,accountType!,bankName.text.trim(),
              accountNumber.text.trim(),IBAN.text.trim(),
              accountHolderName.text.trim(), context);
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 50.h, horizontal: 20.w),
            child: Form(
              key: formkey,

              child: Column(
                spacing: 10.h,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // accountType field
                  accountTypeDropdown(),

                  // accountNumber field
                  TextFormField(
                    controller: accountNumber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Account Number",
                      prefixIcon: Icon(Icons.keyboard_control),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please accountNumber";
                      }
                      return null;
                    },
                  ),

                   if(isBank)
                   TextFormField(
                     controller: bankName,
                     decoration: InputDecoration(
                       hintText: "Bank Name",
                       prefixIcon: Icon(Icons.account_balance_sharp),
                     ),
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return "Please enter bank name";
                       }
                       return null;
                     },
                   ),

                  if(isBank)
                  TextFormField(
                    controller: IBAN,
                    decoration: InputDecoration(
                      hintText: "IBAN ",
                      prefixIcon: Icon(Icons.numbers_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter bank name";
                      }
                      return null;
                    },
                  ),


                  TextFormField(
                    controller: accountHolderName,
                    decoration: InputDecoration(
                      hintText: "Account HolderName",
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter HolderName";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 50.h),
                  // SignUp button
                  Consumer(
                    builder: (context, ref, child) {
                      final loading = ref.watch(sellerPaymentAccountViewModelProvider(widget.userid.toString()));
                      return CustomButton(
                        text: "Add Account",
                        onPressed: handleSubmission,
                        isLoading: false,
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
