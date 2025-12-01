import 'package:hive/hive.dart';
part 'userHiveModel.g.dart';

@HiveType(typeId: 14)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? username;

  @HiveField(2)
  String? email;

  @HiveField(3)
  int? contactnumber;

  @HiveField(4)
  String? role;

  @HiveField(5)
  String? token;

  @HiveField(6)
  String? createdAt;

  @HiveField(7)
  String? updatedAt;

  @HiveField(8)
  AddressHiveModel? address;

  @HiveField(9)
  String? imageUrl;

  UserHiveModel({
    this.id,
    this.username,
    this.email,
    this.contactnumber,
    this.role,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.imageUrl,
  });
}

@HiveType(typeId: 15)
class AddressHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? sector;

  @HiveField(2)
  String? city;

  @HiveField(3)
  String? address;

  @HiveField(4)
  int? userId;

  @HiveField(5)
  String? createdAt;

  @HiveField(6)
  String? updatedAt;

  AddressHiveModel({
    this.id,
    this.sector,
    this.city,
    this.address,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });
}
