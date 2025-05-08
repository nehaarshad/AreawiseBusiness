import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';


class CategoriesButton extends ConsumerWidget {
  const CategoriesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the shared provider to get and set the selected category
    final selectedCategory = ref.watch(selectedCategoryProvider);

    void onCategoryChange(String category) {
      // Update the selectedCategory in the provider
      ref.read(selectedCategoryProvider.notifier).state = category;

      // Fetch products based on selected category
      ref.read(featureProductViewModelProvider.notifier).getAllFeaturedProducts(category);
      ref.read(sharedProductViewModelProvider.notifier).getAllProduct(category);
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
