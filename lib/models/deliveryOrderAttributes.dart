class DeliveryOrderAttributes {
  int? id;
  int? shippingPrice;
  String? discount;
  String? totalBill;
  String? createdAt;
  String? updatedAt;

  DeliveryOrderAttributes(
      {this.id,
        this.shippingPrice,
        this.discount,
        this.totalBill,
        this.createdAt,
        this.updatedAt});

  DeliveryOrderAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shippingPrice = json['shippingPrice'];
    discount = json['discount'];
    totalBill = json['totalBill'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shippingPrice'] = this.shippingPrice;
    data['discount'] = this.discount;
    data['totalBill'] = this.totalBill;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
