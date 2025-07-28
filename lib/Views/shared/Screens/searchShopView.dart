import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SellerViewModels/sellerShopViewModel.dart';
import '../../../View_Model/SharedViewModels/allShopsViewModel.dart';
import '../../../View_Model/SharedViewModels/searchedShopViewMode.dart';
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
      await ref.read(searchShopViewModelProvider.notifier).searchShops(widget.search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolors.whiteColor,
          leading: IconButton(
            onPressed: () async {
              await ref.read(allShopViewModelProvider.notifier).getAllShops();
              if (mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: Appcolors.whiteColor,
        body:Consumer(builder: (context, ref, child) {
              final shopState = ref.watch(searchShopViewModelProvider);
              return shopState.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: Appcolors.blueColor)),
                  data: (shops) {
                    if (shops.isEmpty) {
                      return const Center(child: Text("No Shops Available"));
                    }
                    return ListView.builder(
                      shrinkWrap: true, // Add this to prevent scrolling issues
                      physics: NeverScrollableScrollPhysics(), // Add this
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final shop = shops[index];

                        if (shop == null) {
                          return SizedBox.shrink();
                        }

                        return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                routesName.SellerShopDetailView,
                                arguments: shop,
                              );
                            },
                            child: ListTile(
                              title: Text(shop.shopname ?? 'No Name'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shop.category?.name ?? 'No Category',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {

                                      if (shop.id != null) {
                                        final parameters = {
                                          'shopid': shop.id,
                                          'userid': widget.userid.toString(),
                                        };
                                        Navigator.pushNamed(
                                          context,
                                          routesName.sEditShop,
                                          arguments: parameters,
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.edit, color: Appcolors.blueColor),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      // Safe null check
                                      if (shop.id != null) {
                                        await ref.read(sellerShopViewModelProvider(widget.userid.toString()).notifier)
                                            .deleteShop(shop.id.toString());
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );

                      },
                    );
                  },
                  error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}'))
              );
            })

    );
  }
}