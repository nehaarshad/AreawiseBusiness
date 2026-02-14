import 'package:ecommercefrontend/models/mappers/serviceMappers.dart';
import 'package:ecommercefrontend/models/serviceProviderModel.dart';
import 'package:ecommercefrontend/models/servicesModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../models/hiveModels/servicesHiveModel.dart';

final serviceLocalDataSourceProvider = Provider<serviceLocalDataSource>((ref) {
  final dataSource = serviceLocalDataSource();
  dataSource.init();
  return dataSource;

});

class serviceLocalDataSource {
  static const String allServicesBox = 'all_services_cache';

  late Box<ServicesHiveModel> _servicesBox;

  Future<void> init() async {
    _servicesBox = await Hive.openBox<ServicesHiveModel>(allServicesBox);
  }

  Future<void> cacheAllServices(List<Services> services) async {
    // Clear old cache
    await _servicesBox.clear();

    try{
      // Save all ads
      for (var serv in services) {
        if (serv.id != null) {
          ///convert to hive model for storage
          final hiveModel = ServiceMapper.toHiveModel(serv);
          await _servicesBox.put(serv.id, hiveModel);  // Use ad ID as key
        }
      }
    }catch(e){
      throw e;
    }
  }

  List<Services> getAllServices() {
    return _servicesBox.values
        .map((hive) => ServiceMapper.fromHiveModel(hive))
        .toList();
  }

  List<ServiceProviders> getServiceProviders(int id) {
    final hiveModel = _servicesBox.get(id);
    Services? service = hiveModel != null ? ServiceMapper.fromHiveModel(hiveModel) : null;

   if(service != null){
     if(service.providers != null && service.providers!.isNotEmpty)
     {
       return service.providers!;
     }
     return [];
   }
   return [];

  }

  List<ServiceWithProvider> findUserServiceProviders(int id) {
    final allServices = _servicesBox.values
        .map((hive) => ServiceMapper.fromHiveModel(hive))
        .toList();

    return allServices
        .where((service) => service.providers != null && service.providers!.isNotEmpty)
        .expand((service) => service.providers!
        .where((provider) => provider.providerID == id)
        .map((provider) => ServiceWithProvider(
      serviceName: service.name,
      provider: provider,
    )))
        .toList();
  }


  Services? findService(int id){
    final hiveModel = _servicesBox.get(id);
    return hiveModel != null ? ServiceMapper.fromHiveModel(hiveModel) : null;

  }

  bool hasCachedData() {
    return _servicesBox.isNotEmpty;
  }


}