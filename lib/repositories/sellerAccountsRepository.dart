import 'dart:convert';

import 'package:ecommercefrontend/models/paymentAccountModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/network/app_APIs.dart';

final accountProvider = Provider<AccountsRepositories>((ref) {
  return AccountsRepositories(ref: ref);
});

class AccountsRepositories {
  Ref  ref;
  AccountsRepositories({required this.ref});
  baseapiservice apiservice = networkapiservice();


  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<paymentAccount> addSellerAccount( Map<String,dynamic> data,) async {
    try {

      final body=jsonEncode(data);
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.createSellerPayementAccountEndPoints,
        body,
        headers(),
      );
      print("paymentAccount repository: ${response}");
      if (response is Map<String, dynamic>) {
        return paymentAccount.fromJson(response);
      }
      throw Exception("invalid Response");
    } catch (e) {
      throw e;
    }
  }

  Future<List<paymentAccount>> getUserPaymentAccount(String id) async {
    try {
       List<paymentAccount> accounts=[];
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getSellerPayementAccountEndPoints.replaceFirst(':id', id), headers(),
      );
       if (response is List) {
         return response.map((acc) => paymentAccount.fromJson(acc as Map<String, dynamic>)).toList();
       }
       accounts = [paymentAccount.fromJson(response)];
       return accounts;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteAccount(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.deleteSellerPayementAccountEndPoints.replaceFirst(':id', id), headers(),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

}
