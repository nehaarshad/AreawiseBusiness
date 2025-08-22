import 'package:ecommercefrontend/View_Model/adminViewModels/subCategoriesViewModel.dart';
import 'package:ecommercefrontend/Views/shared/widgets/listOfCategories.dart';
import 'package:ecommercefrontend/Views/shared/widgets/listOfSubcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/categoryModel.dart';
import '../../admin_screens/appSubcategories.dart';

class CategoriesView extends ConsumerStatefulWidget {
  final int userid;
  const CategoriesView({super.key,required this.userid});

  @override
  ConsumerState<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends ConsumerState<CategoriesView> {

  Category? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.31,
            child: CategoriesList(
              userid: widget.userid,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
                 ref.read(subCategoryViewModelProvider(category.name!).notifier).getSubcategories(category.name!);
              },
            ),
          ),
          // Vertical divider
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: selectedCategory == null
                ? const Center(child: Text('Select a category'))
                : SubcategoriesList(userid:widget.userid,category: selectedCategory!),

          ),
        ],
      ),
    );
  }
}
