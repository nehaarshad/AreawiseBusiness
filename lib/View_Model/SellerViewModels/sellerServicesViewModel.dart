import 'package:ecommercefrontend/models/serviceProviderModel.dart';
import 'package:ecommercefrontend/repositories/serviceProvidersRepository.dart';
import 'package:ecommercefrontend/repositories/serviceRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/servicesModel.dart';
import '../adminViewModels/ShopViewModel.dart';

final sellerServiceViewModelProvider = StateNotifierProvider.family<sellerServiceViewModel, AsyncValue<List<ServiceWithProvider?>>, String>((ref, id) {
  return sellerServiceViewModel(ref, id);
});

class sellerServiceViewModel extends StateNotifier<AsyncValue<List<ServiceWithProvider?>>> {
  final Ref ref;
  String id;
  sellerServiceViewModel(this.ref, this.id) : super(const AsyncValue.loading()) {
    getUserServices(id);
  }

  Future<void> getUserServices(String userid) async {
    try {
      int id = int.tryParse(userid)!;
      print("user id ${id}");
      List<Services?> services = await ref.read(serviceProvider).getServices();
       print(services.map((m)=>m!.name!));
      List<ServiceWithProvider?> userServices =[];
      if (services != null || services.isNotEmpty){
        userServices = services
            .where((service) =>
        service?.providers != null && service!.providers!.isNotEmpty)
            .expand((service) =>
            service!.providers!
                .where((provider) => provider.providerID == id)
                .map((provider) =>
                ServiceWithProvider(
                  serviceName: service.name,
                  provider: provider,
                )))
            .toList();
    }

      state = AsyncValue.data(userServices.isEmpty ? [] : userServices);

    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteProvider(String id) async {
    try {
      print(id);
      await ref.read(serviceProvidersDetailsProvider).deleteService(id);
      await getUserServices(this.id); //Rerender Ui or refetch shops if shop deleted
      ref.invalidate(serviceProvider);///refetch all shops when owner delete its any shop
      await ref.read(shopViewModelProvider.notifier).getShops();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
