import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:ecommercefrontend/models/serviceProviderModel.dart';
import 'package:ecommercefrontend/models/servicesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SellerViewModels/sellerServicesViewModel.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';

class Serviceprovidersview extends ConsumerStatefulWidget {
  final Services service;
  final bool isAdmin;
  const Serviceprovidersview({super.key,required this.service,required this.isAdmin});

  @override
  ConsumerState<Serviceprovidersview> createState() => _ServiceprovidersviewState();
}

class _ServiceprovidersviewState extends ConsumerState<Serviceprovidersview> {
  @override
  Widget build(BuildContext context) {
    final location = ref.watch(selectLocationViewModelProvider);

    List<ServiceProviders> providers = [];

    if (widget.service.providers != null && widget.service.providers!.isNotEmpty) {
      if (location != null && location.isNotEmpty) {
        // Filter by location if location is selected
        providers = widget.service.providers!
            .where((p) => p.location == location)
            .toList();
      } else if(widget.isAdmin) {
        providers = widget.service.providers!;
      }
      else{
        providers = widget.service.providers!;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Providers for ${widget.service.name}",
          softWrap: true,
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
        backgroundColor: Appcolors.whiteSmoke,
      ),
      backgroundColor: Appcolors.whiteSmoke,
      body: widget.service.providers == null || widget.service.providers!.isEmpty
          ? Center(  // Added Center widget
        child: Text("No Service providers available"),
      )
          : providers.isEmpty
          ? Center(  // Handle case where filtering results in empty list
        child: Text("No providers available in selected location"),
      )
          : ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];
          return ListTile(
              leading: provider.ImageUrl != null && provider.ImageUrl!.isNotEmpty
                  ? Image.network(
                provider.ImageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported);
                },
              )
                  : const Icon(Icons.image_not_supported),
              title: Text(widget.service.name ?? "Service",style: AppTextStyles.body,),
              subtitle: Text(provider.providerName ?? "Unknown provider"),
              trailing:  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(widget.isAdmin)
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        routesName.updateServiceProvider,
                        arguments: provider,
                      );
                    },
                    icon: Icon(Icons.edit, color: Appcolors.baseColor),
                    tooltip: "Edit Product",
                  ),
                  if(widget.isAdmin)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      if (provider.id != null) {
                        await ref.read(sellerServiceViewModelProvider(provider.providerID!.toString()).notifier)
                            .deleteProvider(provider.id.toString());
                      }
                    },
                    tooltip: "Delete",
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  routesName.serviceDetailsView,
                  arguments: provider,
                );
              },
            );
        },
      ),
    );
  }
}
