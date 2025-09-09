import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/sellerShopViewModel.dart';
import '../../View_Model/SharedViewModels/searchedShopViewMode.dart';
import '../../View_Model/adminViewModels/ShopViewModel.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/routes/routes_names.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      ref.invalidate(searchShopViewModelProvider);
      await ref.read(searchShopViewModelProvider.notifier).searchShops(widget.search);
      return true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolors.whiteSmoke,
          leading: IconButton(
            onPressed: () async {
              await ref.read(shopViewModelProvider.notifier).getShops();
              if (mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: Appcolors.whiteSmoke,
        body:Consumer(builder: (context, ref, child) {
              final shopState = ref.watch(searchShopViewModelProvider);
              return shopState.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: Appcolors.baseColor)),
                  data: (shops) {

                    if (shops.isEmpty) {
                      return const Center(child: Text("No Shops Available"));
                    }
                    return ListView.builder(
                      itemCount: shops.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        if(shop==null){
                          return SizedBox.shrink();
                        }
                        return  InkWell(
                          onTap: () {
                            final parameters={
                              'shop':shop,
                              'id':widget.userid.toString()
                            };
                            Navigator.pushNamed(
                              context,
                              routesName.SellerShopDetailView,
                              arguments: parameters,
                            );
                          },
                          child: Column(
                            children: [
                              ListTile(
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
                                          'shopid':shop.id,
                                          'userid':widget.userid.toString(),
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
                                        await ref.read(shopViewModelProvider.notifier)
                                            .deleteShop(shop.id.toString(),shop.userId.toString());
                                        Utils.flushBarErrorMessage("Deleted!", context);
                                        await ref.read(searchShopViewModelProvider.notifier).searchShops(widget.search);

                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Container(
                                      child: Text(
                                        "Status: ${  shop?.status ?? "noStatus"}",
                                        style: TextStyle(
                                          color:  shop?.status == 'Active' ? Colors.green[800] : Colors.orange[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(right: 20.w),
                                    child: TextButton(
                                      onPressed: () async{
                                        final status = shop.status == 'Active' ? 'Dismiss' : 'Active';
                                        await ref.read(shopViewModelProvider.notifier).updateShopStatus(shop.id.toString(),shop.userId.toString(), status);
                                        Utils.flushBarErrorMessage("Status Updated", context);
                                        await ref.read(searchShopViewModelProvider.notifier).searchShops(widget.search);

                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: shop.status == 'Active'
                                            ? Colors.red[400]
                                            : Colors.green[400],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40.0.r),
                                        ),
                                      ),
                                      child: Text(
                                        shop.status == 'Active' ? "Dismiss" : "Activate",
                                        style: TextStyle(
                                          color: Appcolors.whiteSmoke,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              Divider()
                            ],
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