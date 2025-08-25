import 'package:ecommercefrontend/models/paymentAccountModel.dart';

import 'cartItemModel.dart';

class paymentModel {
  String? sellerId;
  int? amount;
  int? orderId;
  List<paymentAccount>? accounts;
  List<CartItems>? items;

  paymentModel({this.sellerId, this.orderId,this.amount, this.accounts, this.items});

  paymentModel.fromJson(Map<String, dynamic> json) {
    sellerId = json['sellerId'];
    amount = json['amount'];
    orderId = json['orderId'];
    if (json['accounts'] != null) {
      accounts = <paymentAccount>[];
      json['accounts'].forEach((v) {
        accounts!.add(new paymentAccount.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = <CartItems>[];
      json['items'].forEach((v) {
        items!.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sellerId'] = this.sellerId;
    data['amount'] = this.amount;
    data['orderId'] = this.orderId;
    if (this.accounts != null) {
      data['accounts'] = this.accounts!.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



