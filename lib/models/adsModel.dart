class adsModel {
  int? id;
  int? sellerId;
  String? expireAt;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  Image? image;

  adsModel(
      {this.id,
        this.sellerId,
        this.expireAt,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.image});

  adsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['sellerId'];
    expireAt = json['expire_at'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    image = json['Image'] != null ? new Image.fromJson(json['Image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sellerId'] = this.sellerId;
    data['expire_at'] = this.expireAt;
    data['is_active'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.image != null) {
      data['Image'] = this.image!.toJson();
    }
    return data;
  }
}

class Image {
  int? id;
  String? imagetype;
  int? userId;
  int? productId;
  int? shopId;
  int? adId;
  dynamic imageData;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  Image(
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

  Image.fromJson(Map<String, dynamic> json) {
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
