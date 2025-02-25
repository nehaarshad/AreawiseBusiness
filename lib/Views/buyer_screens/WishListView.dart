import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/buyerViewModels/WishListViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/colors.dart';

class Wishlistview extends ConsumerStatefulWidget {
  int id;
  Wishlistview({required this.id});

  @override
  ConsumerState<Wishlistview> createState() => _WishlistviewState();
}

class _WishlistviewState extends ConsumerState<Wishlistview> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wishListViewModelProvider(widget.id.toString()));
    return Scaffold(
      appBar: AppBar(title: const Text("WishList")),
      body: state.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: Appcolors.blueColor)),
            data: (list) {
              if (list.isEmpty) {
                return const Center(child: Text("No Favourite Items available."));
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  if (item?.product == null) return const SizedBox.shrink();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          routesName.productdetail,
                          arguments:{'id': widget.id, 'product': item?.product} ,
                        );
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: (item?.product?.images?.isNotEmpty == true &&
                            item?.product?.images?.first.imageUrl?.isNotEmpty == true)
                            ? Image.network(
                          item!.product!.images!.first.imageUrl!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )
                            : const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                      title: Text(
                        "${item?.product?.name}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '\$${item?.product?.price}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          await ref
                              .read(wishListViewModelProvider(widget.id.toString()).notifier)
                              .deleteItemFromWishList(widget.id.toString(), item!.productId!);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  );
                },
              );
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
    );
  }
}
