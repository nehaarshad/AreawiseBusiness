import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/sellerShopViewModel.dart';
import '../../View_Model/auth/sessionmanagementViewModel.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: Appcolors.whiteSmoke,

      ),
      backgroundColor: Appcolors.whiteSmoke,
      body: shopState.when(
        loading: () => const Center(child: LinearProgressIndicator(color: Appcolors.baseColor)),
        data: (shops) {
          if (shops.isEmpty) {
            return const Center(child: Text("No Shops Available"));
          }
          return ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];
              return  InkWell(
                  onTap: () {
                   final userId = ref.read(sessionProvider)?.id;
                    final parameters={
                      'shop':shop,
                      'id':userId
                    };
                    Navigator.pushNamed(
                      context,
                      routesName.SellerShopDetailView,
                      arguments: parameters,
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
                          icon: Icon(Icons.edit, color: Appcolors.baseColor),
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
                );

            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}'))),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                routesName.sAddShop,
                arguments: widget.id,//send userId
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.baseColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            child:  Text(
              "Add Shop",
              style: TextStyle(
                color: Appcolors.whiteSmoke,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),

      ),
    );
  }
}
