import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/sellerShopViewModel.dart';
import '../../View_Model/auth/sessionmanagementViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/loadingState.dart';

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
        actions: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.0.w),
            child: InkWell(
              onTap:()async{
                Navigator.pushNamed(
                  context,
                  routesName.sAddShop,
                  arguments: widget.id,
                );
              },
              child: Container(
                height: 25.h,
                width: 130.w,
                decoration: BoxDecoration(
                  color: Appcolors.whiteSmoke,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(  // Use Border.all instead of boxShadow for borders
                    color: Appcolors.baseColor,
                    width: 1.0,  // Don't forget to specify border width
                  ),
                ),
                child: Center(
                  child: Text(
                    "Add new shop",
                    style: TextStyle(
                      color: Appcolors.baseColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
]
      ),

      body: shopState.when(
          loading: () => const Column(
            children: [
              ShimmerListTile(),
              ShimmerListTile(),
              ShimmerListTile(),
              ShimmerListTile(),
            ],
          ),
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
                    leading: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: (shop?.images != null &&
                          shop!.images!.isNotEmpty &&
                          shop.images!.first.imageUrl != null)
                          ? CachedNetworkImage(
                        imageUrl:  shop.images!.first.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      )
                          :  Icon(Icons.image_not_supported, size: 40.h),
                    ),
                    title: Text(shop?.shopname ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop?.category?.name ?? 'No Category',
                          style:  TextStyle(fontSize: 12.sp),
                        ),
                        Text(
                          shop!.status!,
                          style:  TextStyle(fontSize: 14.sp,color: shop.status=='Active' ? Appcolors.baseColor : Colors.red,fontWeight: FontWeight.w500),
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
    );
  }
}
