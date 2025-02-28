import 'orderModel.dart';

class OrdersRequestModel {
  int? id;
  int? sellerId;
  int? customerId;
  int? orderId;
  int? orderProductId;
  String? status;
  String? createdAt;
  String? updatedAt;
  orderModel? order;

  OrdersRequestModel(
      {this.id,
        this.sellerId,
        this.customerId,
        this.orderId,
        this.orderProductId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.order});

  OrdersRequestModel copyWith({
    int? id,
    int? sellerId,
    int? customerId,
    int? orderId,
    int? orderProductId,
    String? status,
    String? createdAt,
    String? updatedAt,
    orderModel? order,
  }) {
    return OrdersRequestModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      customerId: customerId ?? this.customerId,
      orderId: orderId ?? this.orderId,
      orderProductId: orderProductId ?? this.orderProductId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      order: order ?? this.order,
    );
  }

  OrdersRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['sellerId'];
    customerId = json['customerId'];
    orderId = json['orderId'];
    orderProductId = json['orderProductId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    order = json['Order'] != null ? new orderModel.fromJson(json['Order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sellerId'] = this.sellerId;
    data['customerId'] = this.customerId;
    data['orderId'] = this.orderId;
    data['orderProductId'] = this.orderProductId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.order != null) {
      data['Order'] = this.order!.toJson();
    }
    return data;
  }
}









