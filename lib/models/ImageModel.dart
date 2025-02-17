class Image {
  int? id;
  String? imagetype;
  int? entityId;
  Null? imageData;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  Image(
      {this.id,
        this.imagetype,
        this.entityId,
        this.imageData,
        this.imageUrl,
        this.createdAt,
        this.updatedAt});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagetype = json['imagetype'];
    entityId = json['entityId'];
    imageData = json['imageData'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagetype'] = this.imagetype;
    data['entityId'] = this.entityId;
    data['imageData'] = this.imageData;
    data['imageUrl'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}