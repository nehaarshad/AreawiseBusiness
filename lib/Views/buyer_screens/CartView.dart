import 'package:ecommercefrontend/View_Model/buyerViewModels/cartViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../shared/widgets/colors.dart';

class Cartview extends ConsumerStatefulWidget {
  int id;
  Cartview({required this.id});

  @override
  ConsumerState<Cartview> createState() => _CartviewState();
}

class _CartviewState extends ConsumerState<Cartview> {
 // int quantity=1;
  @override
  Widget build(BuildContext context) {
    final state=ref.watch(cartViewModelProvider(widget.id.toString()));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("CartView"),
        actions: [
          IconButton(onPressed: ()async{
            await ref.read(cartViewModelProvider(widget.id.toString()).notifier).deleteUserCart(widget.id.toString(),context);
          },
              icon: Icon(Icons.delete_rounded,color: Colors.red,))
        ],
      ),
body: state.when(
  loading: () => const Center(
    child: CircularProgressIndicator(color: Appcolors.blueColor),
  ),
    data: (items){
    if (items == null || items.cartItems == null || items.cartItems!.isEmpty) {
            return const SizedBox.shrink(child: Center(child: Text("No Active Cart Found!")));
          }

    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.cartItems!.length,
                      itemBuilder: (context, index) {
                      final item = items.cartItems![index];
                      if (item.product == null) {
                        print("item have no product");
                        return const SizedBox.shrink();
                      }
                       return Card(
                           margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                               child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                   ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:item.product?.images?.isNotEmpty == true && item.product?.images?.first.imageUrl != null
                                      ? Image.network(
                                    item.product!.images!.first.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                      : const SizedBox( // Show a placeholder if the image is null
                                    width: 100,
                                    height: 100,
                                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                  ),),
                                 const SizedBox(width: 16),

                                Expanded(
                                child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text("${item.product!.name}", style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                  const SizedBox(height: 8),
                                  Text('\$${item.product!.price!.toStringAsFixed(2)}',style: const TextStyle(fontSize: 16, color: Colors.blue,),),
                                  const SizedBox(height: 8),
                                    Row(
                                    children: [
                                       IconButton(
                                         onPressed: () {
                                           var currentquantity=item.quantity ?? 1;
                                         if (currentquantity > 1) {
                                           currentquantity= currentquantity - 1;
                                             setState(() {
                                               currentquantity;
                                             });
                                        print("decrement to: ${currentquantity}");
                                         ref.read(cartViewModelProvider(widget.id.toString()).notifier)
                                        .updateCartItem(item.id!.toString(),currentquantity,);
                                         }
                                         return;
                                         },
                                         icon: const Icon(Icons.remove_circle_outline),),
                                      Text('${item.quantity}', style: const TextStyle(fontSize: 16),),
                                      IconButton(
                                        onPressed: () {
                                          var currentquantity=item.quantity ?? 1;
                                          if(currentquantity >= 1) {
                                            currentquantity = currentquantity + 1;

                                            setState(() {
                                              currentquantity;
                                            });
                                            print("Increment to: ${currentquantity}");
                                            ref.read(cartViewModelProvider(widget.id.toString()).notifier)
                                                .updateCartItem(item.id!.toString(), currentquantity,);
                                          }},
                                        icon: const Icon(Icons.add_circle_outline),),
                                      const Spacer(),
                                      IconButton(
                                      onPressed: () {
                                       ref.read(cartViewModelProvider(widget.id.toString()).notifier)
                                           .deleteCartItem(item.id.toString());
                                       },
                                     icon: const Icon(Icons.delete_outline, color: Colors.red,),
                                   ),
                                    ],
                                    ),
                                  ],
                                ),
                                ),
                                   ],
                               ),
                            ),
                       );
                       },);
          },
  error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}'),
  ),),
    );
  }
}
