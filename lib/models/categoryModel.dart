import 'categoryModel.dart';

class Category {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  catImage? image;

  Category({this.id, this.name, this.createdAt, this.updatedAt,this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    image =
    json['Image'] != null ? new catImage.fromJson(json['Image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.image != null) {
      data['Image'] = this.image!.toJson();
    }
    return data;
  }
}

class catImage {
  int? id;
  String? imagetype;
  int? entityId;
  Null? imageData;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  catImage({
    this.id,
    this.imagetype,
    this.entityId,
    this.imageData,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  catImage copyWith({
    int? id,
    String? imagetype,
    int? entityId,
    dynamic imageData,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
  }) {
    return catImage(
      id: id ?? this.id,
      imagetype: imagetype ?? this.imagetype,
      entityId: entityId ?? this.entityId,
      imageData: imageData ?? this.imageData,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  catImage.fromJson(Map<String, dynamic> json) {
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
