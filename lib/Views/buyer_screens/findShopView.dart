import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../View_Model/SharedViewModels/searchedShopViewMode.dart';
import '../../View_Model/adminViewModels/ShopViewModel.dart';

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
          backgroundColor: Appcolors.whiteColor,
          leading: IconButton(
            onPressed: () async {
              await ref.read(shopViewModelProvider.notifier).getShops();
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
                  return Center(child: Text("No shops available."));
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
                                'id':widget.userid
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
                                        ? Image.network(
                                      shop.images!.first.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                        : Center(
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "${shop?.shopname}",
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.h),
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