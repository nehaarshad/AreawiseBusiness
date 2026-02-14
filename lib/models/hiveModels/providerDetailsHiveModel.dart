import 'package:hive/hive.dart';
part 'providerDetailsHiveModel.g.dart';

@HiveType(typeId: 17)
class ProviderDetailsHiveModel extends HiveObject {

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? serviceDetails;

  @HiveField(2)
  int? cost;

  @HiveField(3)
  int? providerId;

  ProviderDetailsHiveModel({
    this.id,
    this.serviceDetails,
    this.cost,
    this.providerId,
  });

}