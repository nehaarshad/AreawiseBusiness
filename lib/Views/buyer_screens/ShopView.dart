import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/Views/shared/widgets/searchShop.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../View_Model/adminViewModels/ShopViewModel.dart';
import '../../core/utils/CapitalizesFirst.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/loadingState.dart';
import '../shared/widgets/selectAreafloatingButton.dart';

class ShopsView extends ConsumerStatefulWidget {
 final int id;//userId
  const ShopsView({super.key,required this.id});

  @override
  ConsumerState<ShopsView> createState() => _ShopsViewState();
}

class _ShopsViewState extends ConsumerState<ShopsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: selectLocationFloatingButton(),
      body: Column(
      
        children: [
          SizedBox(height: 8.h,),
          searchShop(id:widget.id,myShop: false,width: 350,),
          SizedBox(height: 16.h,),
          Expanded(
            child: Consumer(
                builder: (context, ref, child) {
                  final shopState = ref.watch(shopViewModelProvider);
                  final location = ref.watch(selectLocationViewModelProvider);

                  return shopState.when(
                    loading: () => const Column(
                      children: [
                        ShimmerListTile(),
                        ShimmerListTile(),
                        ShimmerListTile(),
                        ShimmerListTile(),
                        ShimmerListTile(),
                      ],
                    ),
                    data: (shops) {
                      if (shops.isEmpty) {
                        return Center(child: Text("No shops available."));
                      }


                      if (location != null) {
                        shops = shops.where((shop) {
                          final normalizedArea = (shop?.sector ?? "")
                              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                              .toLowerCase();

                          final normalizedLocation = location
                              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                              .toLowerCase();

                          return normalizedArea.contains(normalizedLocation);
                        }).toList();
                      }


                      if (shops.isEmpty) {
                        return const Center(child: Text("Oops! No shop found in this location."));
                      }
                      shops = shops.where((shop)=>shop?.status=="Active").toList();

                      return Column(
                        children: [
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                        itemCount: shops.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 4, // Horizontal spacing between grid items
                            mainAxisSpacing: 5, // Adjust based on the desired item dimensions
                          ),
                          itemBuilder: (context, index) {
                            final shop = shops[index];
                            if(shop==null){
                              return SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: (){
                                final parameters={
                                  'shop':shop,
                                  'id':widget.id.toString()
                                };
                                Navigator.pushNamed(
                                  context,
                                  routesName.shopdetail,
                                  arguments: parameters,
                                );
                              },
                              child: Container(
                                width: 150.w,
                                margin: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child:shop?.images != null &&
                                          shop!.images!.isNotEmpty
                                          ? CachedNetworkImage(
                                    imageUrl:     shop.images!.first.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorWidget: (context, error, stackTrace) =>  Icon(
                                          Icons.image_not_supported,
                                          size: 50.h,
                                          color: Colors.grey,
                                        ),
                                      )
                                          : Center(
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 5.0),
                                      child: SizedBox(
                                        child: Text(
                                          capitalizeFirst(shop.shopname!),
                                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        width: 150.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 5.0),
                                      child: SizedBox(
                                        child: Text(
                                          shop.sector!,
                                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.sp,color: Appcolors.baseColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        width: 150.w,
                                      ),
                                    ),
                                 ],
                                ),
                              ),
                            );
      
                          },
                        ),
                      )
                        ],
                      );
                    },
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  );
                },
              ),
          ),
        ],
      ),
    );

  }
}
