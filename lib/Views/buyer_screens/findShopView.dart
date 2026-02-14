import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../View_Model/SharedViewModels/searchedShopViewMode.dart';
import '../../View_Model/adminViewModels/ShopViewModel.dart';
import '../shared/widgets/loadingState.dart';

class findShopView extends ConsumerStatefulWidget {
  final String search;
  final int userid;
  findShopView({super.key,required this.search,required this.userid});

  @override
  ConsumerState<findShopView> createState() => _findShopViewState();
}


//Buyer searchShop View..cant update or deleteShop
class _findShopViewState extends ConsumerState<findShopView> {
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
          final location = ref.watch(selectLocationViewModelProvider);

          return shopState.when(
              loading: () => const Column(
                children: [
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
                          return GestureDetector(
                            onTap: (){
                              final parameters={
                                'shop':shop,
                                'id':widget.userid.toString()
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
                                 imageUrl:      shop.images!.first.imageUrl!,
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
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SizedBox(
                                      child: Text(
                                        "${shop?.shopname}",
                                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.h),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      width: 90.w,
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
              error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}'))
          );
        })

    );
  }
}