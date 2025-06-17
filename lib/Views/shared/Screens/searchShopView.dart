import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SellerViewModels/sellerShopViewModel.dart';
import '../../../View_Model/SharedViewModels/allShopsViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';

class searchShopView extends ConsumerStatefulWidget {
  final String search;
  final int userid;
   searchShopView({super.key,required this.search,required this.userid});

  @override
  ConsumerState<searchShopView> createState() => _searchShopViewState();
}

class _searchShopViewState extends ConsumerState<searchShopView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(allShopViewModelProvider.notifier).searchShops(widget.search);
    });
  }


  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(allShopViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.whiteColor,
      ),
      backgroundColor: Appcolors.whiteColor,

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
                                'userid':widget.userid.toString(),
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
                              await ref.read(sellerShopViewModelProvider(widget.userid.toString(),).notifier)
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
