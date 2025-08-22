class SaleOffer {
  int? id;
  String? expireAt;
  int? discount;
  int? price;
  int? userId;
  int? productId;
  String? createdAt;
  String? updatedAt;

  SaleOffer(
      {this.id,
        this.expireAt,
        this.discount,
        this.price,
        this.userId,
        this.productId,
        this.createdAt,
        this.updatedAt});

  SaleOffer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expireAt = json['expire_at'];
    discount = json['discount'];
    price = json['price'];
    userId = json['userId'];
    productId = json['productId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expire_at'] = this.expireAt;
    data['discount'] = this.discount;
    data['price'] = this.price;
    data['userId'] = this.userId;
    data['productId'] = this.productId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}