import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/SharedViewModels/productViewModels.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/colors.dart';

class Sellerproductsview extends ConsumerStatefulWidget {
  int id;
  Sellerproductsview({required this.id});

  @override
  ConsumerState<Sellerproductsview> createState() => _SellerproductsviewState();
}

class _SellerproductsviewState extends ConsumerState<Sellerproductsview> {

  @override
  void initState() {
    super.initState();
    // Fetch all products when the widget is first created
    ref.read(sharedProductViewModelProvider.notifier).getUserProduct(widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(sharedProductViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("My Products")),
      ),
      body: productState.when(
          loading: () =>
          const Center(
              child: CircularProgressIndicator(color: Appcolors.blueColor)),
          data: (products) {
            if (products.isEmpty) {
              return Center(child: Text("No Products Available"));
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index]!;
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, routesName.productdetail,
                        arguments: {'id': widget.id, 'product': product},
                      );
                    },
                    child: ListTile(
                      leading: product.images != null &&
                          product.images!.isNotEmpty
                          ? Image.network(
                        product.images!.first.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ) : const Icon(Icons.image_not_supported),
                      title: Text('${product.name}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${product.category}',
                            style: const TextStyle(fontSize: 12),),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                routesName.sEditProduct,
                                arguments: product,
                              );
                            },
                            icon: Icon(Icons.edit, color: Appcolors.blueColor),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await ref.read(sharedProductViewModelProvider.notifier).deleteProduct(product.id.toString(),widget.id.toString());
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
          error: (error, stackTrace) =>
              Center(child: Text('Error: ${error.toString()}'))),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(100, 0, 100, 100),
        child: SizedBox(
          height: 50.0,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                routesName.sAddShop,
                arguments: widget.id, //send userId
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.blueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            child: const Text(
              "Add New Shop",
              style: TextStyle(
                color: Appcolors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
