import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../View_Model/SellerViewModels/sellerShopViewModel.dart';
import '../../View_Model/SharedViewModels/allShopsViewModel.dart';
import '../../core/utils/routes/routes_names.dart';

class allShopsView extends ConsumerStatefulWidget {
  int id;//userId
  allShopsView({required this.id});

  @override
  ConsumerState<allShopsView> createState() => _AllShopsViewState();
}

class _AllShopsViewState extends ConsumerState<allShopsView> {
  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(allShopViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("All Shops")),
      ),
      body: shopState.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Appcolors.blueColor)),
          data: (shops) {
            if (shops.isEmpty) {
              return const Center(child: Text("No Shops Available"));
            }
            return ListView.builder(
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        routesName.SellerShopDetailView,
                        arguments: shop,
                      );
                    },
                    child: ListTile(
                      title: Text(shop?.shopname ?? 'No Name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop?.category?.name ?? 'No Category',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              final parameters={
                                'shopid':shop!.id,
                                'userid':widget.id.toString(),
                              };
                              Navigator.pushNamed(
                                context,
                                routesName.sEditShop,
                                arguments: parameters,
                              );
                            },
                            icon: Icon(Icons.edit, color: Appcolors.blueColor),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await ref.read(sellerShopViewModelProvider(widget.id.toString(),).notifier)
                                  .deleteShop(shop!.id.toString());

                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}'))),

    );
  }
}
