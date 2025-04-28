import 'ProductModel.dart';
import 'UserDetailModel.dart';
import 'messagesModel.dart';

class Chat {
  int? id;
  int? buyerId;
  int? sellerId;
  int? productId;
  String? lastMessageAt;
  String? createdAt;
  String? updatedAt;
  UserDetailModel? user;
  ProductModel? product;
  List<Message>? messages;

  Chat(
      {this.id,
        this.buyerId,
        this.sellerId,
        this.productId,
        this.lastMessageAt,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.product,
        this.messages});

  Chat copyWith({
    int? id,
    int? buyerId,
    int? sellerId,
    int? productId,
    String? lastMessageAt,
    String? createdAt,
    String? updatedAt,
    UserDetailModel? user,
    ProductModel? product,
    List<Message>? messages,
  }) {
    return Chat(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      productId: productId ?? this.productId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      product: product ?? this.product,
      messages: messages ?? this.messages,
    );
  }

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyerId = json['buyerId'];
    sellerId = json['sellerId'];
    productId = json['productId'];
    lastMessageAt = json['lastMessageAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new UserDetailModel.fromJson(json['user']) : null;
    product =
    json['product'] != null ? new ProductModel.fromJson(json['product']) : null;
    if (json['Messages'] != null) {
      messages = <Message>[];
      json['Messages'].forEach((v) {
        messages!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buyerId'] = this.buyerId;
    data['sellerId'] = this.sellerId;
    data['productId'] = this.productId;
    data['lastMessageAt'] = this.lastMessageAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



