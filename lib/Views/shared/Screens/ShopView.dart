import 'package:ecommercefrontend/FutureProviders/userShopViewModel.dart';
import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/routes/routes_names.dart';

class ShopsView extends ConsumerStatefulWidget {
  const ShopsView({super.key});

  @override
  ConsumerState<ShopsView> createState() => _ShopsViewState();
}

class _ShopsViewState extends ConsumerState<ShopsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //title: Center(child: Text("Shops",style: TextStyle(fontWeight: FontWeight.bold),)),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final shopState = ref.watch(getAllShopProvider);
          return shopState.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Appcolors.blueColor)),
            data: (shops) {
              if (shops.isEmpty) {
                return Center(child: Text("No shops available."));
              }
              return GridView.builder(
                itemCount: shops.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 2, // Horizontal spacing between grid items
                  mainAxisSpacing:
                      3, // Adjust based on the desired item dimensions
                ),
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          routesName.shopdetail,
                          arguments: shop,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shop image
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(color: Colors.white),
                              child:
                                  shop?.images != null &&
                                          shop!.images!.isNotEmpty
                                      ? Image.network(
                                        shop.images!.first.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                      : Center(
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${shop?.shopname}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${shop?.category?.name}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
      ),
    );
  }
}
