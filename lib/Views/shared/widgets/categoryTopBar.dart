import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/NewArrivalsViewModel.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';


class CategoriesButton extends ConsumerWidget {
  String id;
  CategoriesButton({super.key,required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the shared provider to get and set the selected category
    final selectedCategory = ref.watch(selectedCategoryProvider);

    void onCategoryChange(String category) async {
      // Update the selectedCategory in the provider
      ref.read(selectedCategoryProvider.notifier).state = category;

      // Fetch products based on selected category
     await ref.read(featureProductViewModelProvider(id).notifier).getAllFeaturedProducts(category);
     await ref.read(sharedProductViewModelProvider.notifier).getAllProduct(category);
     await ref.read(newArrivalViewModelProvider.notifier).getNewArrivalProduct(category);
    }

    final categoriesAsync = ref.watch(GetallcategoriesProvider);
    List<String> allCategories = [];

    return SizedBox(
      height: 50,
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            allCategories = ["All"];
          } else {
            allCategories = ["All", ...categories.map((e) => e.name!)];
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final categoryName = allCategories[index];
              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                child: ChoiceChip(
                  label: Text(categoryName),
                  selected: selectedCategory == categoryName,
                  onSelected: (selected) {
                    if (selected) {
                      onCategoryChange(categoryName);
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
