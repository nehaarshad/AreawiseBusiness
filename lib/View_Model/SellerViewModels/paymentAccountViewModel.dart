import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/models/paymentAccountModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
       Utils.toastMessage("New Wallet Added");
      await getPaymentAcconts(this.id);
      Navigator.pop(context);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
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