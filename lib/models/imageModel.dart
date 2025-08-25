class ImageModel {
  int? id;
  String? imagetype;
  int? userId;
  int? productId;
  int? shopId;
  int? adId;
  dynamic? imageData;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  ImageModel(
      {this.id,
        this.imagetype,
        this.userId,
        this.productId,
        this.shopId,
        this.adId,
        this.imageData,
        this.imageUrl,
        this.createdAt,
        this.updatedAt});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagetype = json['imagetype'];
    userId = json['UserId'];
    productId = json['ProductId'];
    shopId = json['ShopId'];
    adId = json['AdId'];
    imageData = json['imageData'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagetype'] = this.imagetype;
    data['UserId'] = this.userId;
    data['ProductId'] = this.productId;
    data['ShopId'] = this.shopId;
    data['AdId'] = this.adId;
    data['imageData'] = this.imageData;
    data['imageUrl'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
