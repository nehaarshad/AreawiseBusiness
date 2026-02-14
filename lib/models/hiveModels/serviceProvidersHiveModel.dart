import 'package:ecommercefrontend/models/hiveModels/providerDetailsHiveModel.dart';
import 'package:hive/hive.dart';
part 'serviceProvidersHiveModel.g.dart';

@HiveType(typeId: 16)
class ServiceProviderHiveModel extends HiveObject {

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? providerName;

  @HiveField(2)
  String? ImageUrl;

  @HiveField(3)
  String? email;

  @HiveField(4)
  int? providerID;

  @HiveField(5)
  dynamic contactnumber;

  @HiveField(6)
  String? experience;

  @HiveField(7)
  String? OpenHours;

  @HiveField(8)
  String? location;

  @HiveField(9)
  int? serviceId;

  @HiveField(10)
  List<ProviderDetailsHiveModel>? details;

  ServiceProviderHiveModel({
    this.id,
    this.providerName,
    this.experience,
    this.email,
    this.providerID,
    this.location,
    this.OpenHours,
    this.contactnumber,
    this.ImageUrl,
    this.serviceId,
    this.details
  });

}