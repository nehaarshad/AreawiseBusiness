import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/View_Model/SharedViewModels/getOnSaleProducts.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/NewArrivalsViewModel.dart';
import '../../../View_Model/SellerViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../View_Model/adminViewModels/ShopViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import 'loadingState.dart';

class ShopsButton extends ConsumerStatefulWidget {
  final String id;
  ShopsButton({super.key, required this.id});
  @override
  _ShopsButtonState createState() => _ShopsButtonState();
}

class _ShopsButtonState extends ConsumerState<ShopsButton> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;

  void onShopSelection(String category) async {
    try {

      if(category=="On sale"){
        final   parameters={
          "id": int.tryParse(widget.id),
          "category": "All",
          "condition":null,
          "onsale":true,
        };
        print(parameters);
        Navigator.pushNamed(context, routesName.explore,arguments: parameters);

      }
      // Update the selectedCategory in the provider
      ref.read(selectedCategoryProvider.notifier).state = category;

      // Fetch products based on selected category with error handling
      await Future.wait([
        ref.read(featureProductViewModelProvider(widget.id).notifier)
            .getAllFeaturedProducts(category),
        ref.read(sharedProductViewModelProvider.notifier)
            .getAllProduct(category),
        ref.read(onSaleViewModelProvider.notifier)
            .getonSaleProduct(category),
        ref.read(newArrivalViewModelProvider.notifier)
            .getNewArrivalProduct(category),
      ]);
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateIndicator);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateIndicator() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final page = (currentScroll / (maxScroll / 2)).round();

      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopViewModelProvider);
    final location = ref.watch(selectLocationViewModelProvider);


    return shopState.when(
        data: (shops){
      if(location != null){
        shops = shops.where((shop)=>shop?.sector?.toLowerCase()==location.toLowerCase()).toList();
      }
      if (shops.isEmpty) {
        return const Center(child: Text("Oops! No shop found in this location."));
      }
      print(shops.map((s)=>s!.shopname).toList());
      shops = shops.where((shop)=>shop?.status == "Active").toList();

      return Column(
        children: [
          // Categories List
          SizedBox(
            height: 120.h,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 3.w,
                childAspectRatio: 0.80, // Adjusted for better fit
              ),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: shops.length,

              padding: EdgeInsets.symmetric(horizontal: 8.w, ),
              itemBuilder: (context, index) {
                final shop = shops[index];
                var imageUrl;
                if (shop?.images != null &&
                    shop!.images!.isNotEmpty) {
                  imageUrl =  shop.images!.first.imageUrl!;
                }
                return GestureDetector(
                  onTap: () {
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Critical: prevents expansion
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image Container
                      Container(
                        width: 60.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[100],
                              child: Icon(
                                Icons.category,
                                color: Colors.grey[400],
                                size: 18,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[100],
                              child: Icon(
                                Icons.category,
                                color: Colors.grey[400],
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Text with constrained height
                      Flexible(
                        child: Text(
                          shop!.shopname!,
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 8.h),
          _buildScrollIndicator(shops),
        ],
      );
    },
      error: (err, stack) => Center(child: Text('Error: $err')),
      loading: () => const ShimmerListTile(),
    );
  }
  Widget _buildScrollIndicator(List<ShopModel?> shops) {
    final itemsPerScreen = 5;
    final totalPages = (shops.length / itemsPerScreen).ceil();

    if (totalPages <= 1) return SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Container(
          width: 8.w,
          height: 8.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Appcolors.baseColor
                : Colors.grey[300],
          ),
        );
      }),
    );
  }
}