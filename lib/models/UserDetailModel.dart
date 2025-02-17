import 'UserAddressModel.dart';

class UserDetailModel {
  int? id;
  String? username;
  String? email;
  int? contactnumber;
  String? password;
  String? role;
  String? createdAt;
  String? updatedAt;
  Address? address;
  ProfileImage? image;

  UserDetailModel({
    this.id,
    this.username,
    this.email,
    this.contactnumber,
    this.password,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.image,
  });

  UserDetailModel copyWith({
    int? id,
    String? username,
    String? email,
    int? contactnumber,
    String? password,
    String? role,
    String? createdAt,
    String? updatedAt,
    Address? address,
    ProfileImage? image,
  }) {
    return UserDetailModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      contactnumber: contactnumber ?? this.contactnumber,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      address: address ?? this.address,
      image: image ?? this.image,
    );
  }

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    contactnumber = json['contactnumber'];
    password = json['password'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    image =
        json['Image'] != null ? new ProfileImage.fromJson(json['Image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['contactnumber'] = this.contactnumber;
    data['password'] = this.password;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.image != null) {
      data['Image'] = this.image!.toJson();
    }
    return data;
  }
}

class ProfileImage {
  int? id;
  String? imagetype;
  int? entityId;
  Null? imageData;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  ProfileImage({
    this.id,
    this.imagetype,
    this.entityId,
    this.imageData,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  ProfileImage copyWith({
    int? id,
    String? imagetype,
    int? entityId,
    dynamic imageData,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
  }) {
    return ProfileImage(
      id: id ?? this.id,
      imagetype: imagetype ?? this.imagetype,
      entityId: entityId ?? this.entityId,
      imageData: imageData ?? this.imageData,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ProfileImage.fromJson(Map<String, dynamic> json) {
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
