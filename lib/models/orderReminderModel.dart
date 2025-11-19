class OrderReminderModel {

  int? id;
  int? sellerOrderId;
  int? sellerId;
  int? orderId;
  bool? status;
  String? reminderDateTime;
  String? createdAt;
  String? updatedAt;

  OrderReminderModel({
        this.id,
        this.status,
        this.sellerId,
        this.orderId,
        this.updatedAt,
        this.sellerOrderId,
        this.createdAt,
        this.reminderDateTime
  });

  OrderReminderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    sellerOrderId = json['sellerOrderId'] != null ? int.tryParse(json['sellerOrderId'].toString()) : null;
    sellerId = json['sellerId'] != null ? int.tryParse(json['sellerId'].toString()) : null;
    orderId = json['orderId'] != null ? int.tryParse(json['orderId'].toString()) : null;
    status = json['status'];
    reminderDateTime = json['reminderDateTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
     }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sellerOrderId'] = this.sellerOrderId;
    data['status'] = this.status;
    data['sellerId'] = this.sellerId;
    data['orderId'] = this.orderId;
    data['reminderDateTime'] = this.reminderDateTime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

}