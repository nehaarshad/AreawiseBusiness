import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/sellerShopViewModel.dart';
import '../../core/utils/routes/routes_names.dart';

class SellerShopsView extends ConsumerStatefulWidget {
  int id;//userId
  SellerShopsView({required this.id});

  @override
  ConsumerState<SellerShopsView> createState() => _ShopsViewState();
}

class _ShopsViewState extends ConsumerState<SellerShopsView> {
  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(sellerShopViewModelProvider(widget.id.toString()));
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop's",style: TextStyle(color: Appcolors.blueColor,fontSize: 25.sp,fontWeight: FontWeight.bold),),
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
                          style:  TextStyle(fontSize: 12.sp),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                routesName.sAddShop,
                arguments: widget.id,//send userId
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.blueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            child:  Text(
              "Add New Shop",
              style: TextStyle(
                color: Appcolors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),

      ),
    );
  }
}
