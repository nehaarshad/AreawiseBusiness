import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/View_Model/SharedViewModels/getOnSaleProducts.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/NewArrivalsViewModel.dart';
import '../../../View_Model/SellerViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/routes/routes_names.dart';
import 'loadingState.dart';


class CategoriesButton extends ConsumerWidget {
  final String id;
  CategoriesButton({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    void onCategoryChange(String category) async {
      try {

        if(category=="On sale"){
          final   parameters={
            "id": int.tryParse(id),
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
          ref.read(featureProductViewModelProvider(id).notifier)
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

    final categoriesAsync = ref.watch(GetallcategoriesProvider);
print(categoriesAsync.value?.length);
    return SizedBox(
      height: 80,
      child: categoriesAsync.when(
            data: (categories) {
              print(categories);
              if (categories.isEmpty) {
                return const SizedBox.shrink();
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  print(category.name);
                  final categoryName = category.name=="All" ? "On sale" :category.name;
                  var ImageUrl="https://tse3.mm.bing.net/th/id/OIP.e7m1BW3UcR94oDJxzMuLZQHaF6?pid=ImgDet&w=191&h=152&c=7&o=7&rm=3";
                  if(category.name != "All" && category.image != null && category.image!.imageUrl!.isNotEmpty) {
                    ImageUrl = category.image!.imageUrl!;
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                    child:  GestureDetector(
                      onTap: (){ onCategoryChange(categoryName ?? "All");},
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: ImageUrl,
                            width: 50, // Set both width and height to same value
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.category, color: Colors.grey),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.category, color: Colors.grey),
                            ),
                          ),
                        ),

                        SizedBox(height: 5.h,),
                        Text(
                          categoryName!,
                          style: TextStyle(
                            fontSize: 10.h,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                                    ),
                    ) ,
                  );
                },
              );
            },
            loading: () => const ShimmerListTile(),
            error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),

          ),

    );
  }
}