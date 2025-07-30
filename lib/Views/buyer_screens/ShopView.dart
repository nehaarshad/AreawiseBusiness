import 'package:ecommercefrontend/Views/shared/widgets/searchShop.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/adminViewModels/ShopViewModel.dart';
import '../../core/utils/routes/routes_names.dart';

class ShopsView extends ConsumerStatefulWidget {
  int id;//userId
   ShopsView({super.key,required this.id});

  @override
  ConsumerState<ShopsView> createState() => _ShopsViewState();
}

class _ShopsViewState extends ConsumerState<ShopsView> {
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        // Center(child: Text(" Shops",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),)),
        searchShop(id:widget.id,myShop: false),
        SizedBox(height: 8.h,),
        Expanded(
          child: Consumer(
              builder: (context, ref, child) {
                final shopState = ref.watch(shopViewModelProvider);
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
                  error: (err, stack) => Center(child: Text('Error: $err')),
                );
              },
            ),
        ),
      ],
    );

  }
}
