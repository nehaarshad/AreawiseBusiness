import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/featuredProductViewModel.dart';

class Featuredproductrequestview extends ConsumerStatefulWidget {
  const Featuredproductrequestview({super.key});

  @override
  ConsumerState<Featuredproductrequestview> createState() => _FeaturedproductrequestviewState();
}

class _FeaturedproductrequestviewState extends ConsumerState<Featuredproductrequestview> {
  @override

  void initState() {
    super.initState();
    ref.read(featureProductViewModelProvider.notifier).getAllRequestedFeatured();
  }

  @override
  Widget build(BuildContext context) {
    final featureState = ref.watch(featureProductViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Featured Product Requests"),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(featureProductViewModelProvider);
              ref.read(featureProductViewModelProvider.notifier).getAllRequestedFeatured();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: featureState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (featuredProducts) {
                if (featuredProducts.isEmpty) {
                  return Center(
                    child: Text("No featured product requests available", style: TextStyle(fontSize: 18, color: Colors.grey),),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    final featuredProduct = featuredProducts[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: ListTile(
                        leading: (featuredProduct!.product?.images != null &&
                            featuredProduct.product!.images!.isNotEmpty &&
                            featuredProduct.product?.images!.first.imageUrl != null)
                            ? Image.network(
                          featuredProduct.product!.images!.first.imageUrl!,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        )
                            : const Icon(Icons.image_not_supported),
                        title: Text("${featuredProduct.product?.name}", style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Expires At: ${featuredProduct.expireAt}", style: const TextStyle(fontSize: 14),),
                            Text("Status: ${featuredProduct.status}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500,),
                            ),
                          ],
                        ),
                        trailing: featuredProduct.status == "Requested" ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () async{
                                final data={
                                  "status":"Featured",
                                };
                                await ref.read(createfeatureProductViewModelProvider.notifier).updateFeatureProduct(
                                    featuredProduct.id.toString(), featuredProduct.userID.toString(), data, context);
                                await ref.read(featureProductViewModelProvider.notifier).getAllRequestedFeatured();
                              }
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () async{
                                final data={
                                  "status":"Rejected",
                                };
                               await ref.read(createfeatureProductViewModelProvider.notifier).updateFeatureProduct(
                                    featuredProduct.id.toString(), featuredProduct.userID.toString(), data, context);
                                await ref.read(featureProductViewModelProvider.notifier).getAllRequestedFeatured();
                              },
                            ),
                          ],
                        ) : null,
                      ),
                    );
                  },
                );
              },
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text("Error loading featured product requests: $err",textAlign: TextAlign.center, style: TextStyle(color: Colors.red),),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
