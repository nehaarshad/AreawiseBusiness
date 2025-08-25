import 'package:ecommercefrontend/models/UserDetailModel.dart';

class paymentAccount {
  int? id;
  int? sellerId;
  String? accountNumber;
  String? bankName;
  String? IBAN;
  String? accountHolderName;
  String? accountType;
  String? createdAt;
  String? updatedAt;
  UserDetailModel? user;

  paymentAccount({
    this.id,
    this.user,
    this.sellerId,
    this.accountHolderName,
    this.accountNumber,
    this.IBAN,
    this.createdAt,
    this.updatedAt,
    this.accountType,
    this.bankName
  });

  paymentAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['sellerId'];
    accountNumber = json['accountNumber'];
    bankName = json['bankName'];
    IBAN = json['IBAN'];
    accountHolderName = json['accountHolderName'];
    accountType=json['accountType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user =
    json['user'] != null
        ? new UserDetailModel.fromJson(json['user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sellerId'] = this.sellerId;
    data['accountHolderName'] = this.accountHolderName;
    data['accountNumber'] = this.accountNumber;
    data['IBAN'] = this.IBAN;
    data['accountType'] = this.accountType;
    data['bankName'] = this.bankName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
