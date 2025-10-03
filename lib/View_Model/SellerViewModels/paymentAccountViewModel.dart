import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/models/paymentAccountModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dialogueBox.dart';
import '../../repositories/sellerAccountsRepository.dart';

//for seller to manage payementAccounts
final sellerPaymentAccountViewModelProvider = StateNotifierProvider.family<sellerPaymentAccountViewModel, AsyncValue<List<paymentAccount?>>, String>((ref, id) {
  return sellerPaymentAccountViewModel(ref, id);
});

class sellerPaymentAccountViewModel extends StateNotifier<AsyncValue<List<paymentAccount?>>> {
  final Ref ref;
  String id;
  sellerPaymentAccountViewModel(this.ref, this.id) : super(const AsyncValue.loading()) {
    getPaymentAcconts(id);
  }

  final formkey = GlobalKey<FormState>();
  bool isBank=false;
  TextEditingController bankName=TextEditingController();
  TextEditingController IBAN=TextEditingController();
  TextEditingController accountNumber=TextEditingController();
  TextEditingController accountHolderName=TextEditingController();
  String? accountType;

  @override
  void dispose() {

    bankName.clear();
    IBAN.clear();
    accountHolderName.clear();
    accountNumber.clear();
    accountType=null;

  }

  Future<bool> handleSubmission(int userid,BuildContext context) async{

    if(!formkey.currentState!.validate()) {
      return false;
    }
      if (accountType == null || accountHolderName.text.trim().isEmpty || accountNumber.text.trim().isEmpty) {
        return false;
      }
      else {
        addPaymentAcconts(
            userid,
            accountType!,
            bankName.text.trim(),
            accountNumber.text.trim(),
            IBAN.text.trim(),
            accountHolderName.text.trim(),
            context);

        return false;

      }
  }

  Future<void> getPaymentAcconts(String id) async {
    try {
      List<paymentAccount?> accounts = await ref.read(accountProvider).getUserPaymentAccount(id);
      state = AsyncValue.data(accounts.isEmpty ? [] : accounts);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addPaymentAcconts(int sellerId,String accountType,String bankName, String accountNumber, String IBAN, String accountHolderName,BuildContext context) async {
    try {

      final data = {
        'sellerId': sellerId,
        'bankName': bankName,
        'accountType':accountType,
        'accountNumber': accountNumber,
        'accountHolderName': accountHolderName,
        'IBAN':IBAN,
      };

       await ref.read(accountProvider).addSellerAccount(data);
       dispose();
       await getPaymentAcconts(this.id);

    } catch (e) {
     print(e.toString());
     Utils.flushBarErrorMessage("Payment Account already exist.", context);
    }
  }

  Future<void> deletePaymentAcconts(String id) async {
    try {
      await ref.read(accountProvider).deleteAccount(id);
      getPaymentAcconts(this.id);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}