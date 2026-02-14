import 'package:ecommercefrontend/models/hiveModels/serviceProvidersHiveModel.dart';
import 'package:hive/hive.dart';
part 'servicesHiveModel.g.dart';

@HiveType(typeId: 13)
class ServicesHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? image;

  @HiveField(3)
  String? status;

  @HiveField(4)
  List<ServiceProviderHiveModel>? providers;

  ServicesHiveModel({
    this.id,
    this.name,
    this.image,
    this.status,
    this.providers
  });
}