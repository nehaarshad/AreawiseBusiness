import 'package:ecommercefrontend/Views/shared/widgets/searchShop.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/allShopsViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../admin_screens/Widgets/searchUser.dart';

class ShopsView extends ConsumerStatefulWidget {
  int id;
   ShopsView({super.key,required this.id});

  @override
  ConsumerState<ShopsView> createState() => _ShopsViewState();
}

class _ShopsViewState extends ConsumerState<ShopsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text(" Shops",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),)),
        searchShop(id:widget.id),
        Expanded(
          child: Consumer(
              builder: (context, ref, child) {
                final shopState = ref.watch(allShopViewModelProvider);
                return shopState.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: Appcolors.blueColor)),
                  data: (shops) {
                    if (shops.isEmpty) {
                      return Center(child: Text("No shops available."));
                    }
                    return GridView.builder(
                      itemCount: shops.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        crossAxisSpacing: 2, // Horizontal spacing between grid items
                        mainAxisSpacing:
                            3, // Adjust based on the desired item dimensions
                      ),
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                routesName.shopdetail,
                                arguments: shop,
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Shop image
                               Container(
                                    width: double.infinity,
                                    height: 100.h,
                                    decoration: BoxDecoration(color: Colors.white),
                                    child:
                                        shop?.images != null &&
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
                                  padding:  EdgeInsets.symmetric(
                                    horizontal: 12.0.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${shop?.shopname}",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                       SizedBox(height: 4.h),
                                      Text(
                                        "${shop?.category?.name}",
                                        style:  TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
