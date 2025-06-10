import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../View_Model/adminViewModels/categoriesViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../models/categoryModel.dart';
import '../shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/widgets/colors.dart';

class AllCategories extends ConsumerStatefulWidget {
  const AllCategories({super.key});

  @override
  ConsumerState<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends ConsumerState<AllCategories> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryViewModelProvider);

    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      appBar: AppBar(
        title: const Text(
          ' Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Appcolors.whiteColor,
        actions: [ TextButton(onPressed: (){
          AddCategoryDialog();
        }, child: Text(" + Add  "))],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Appcolors.blueColor),
          ),
        ),
        data: (categories) => Categories(categories),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text('Error loading products: ${error.toString()}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(categoryViewModelProvider.notifier).getCategories();
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget Categories(List<Category?> categories) {
    if (categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No Categories Yet!"),
        ),
      );
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
            onTap: () {},
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      routesName.subcategories,
                      arguments:category,
                    );
                  },
                  title: Text("${category!.name}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (){
                         DeleteDialogBox(category);
                        },
                        icon: Icon(Icons.delete, size: 25,color: Colors.red,),),
                      Icon(Icons.arrow_forward_ios_sharp, size: 18,color: Colors.grey,),
                    ],
                  ),
                ),
              ],
            ),
          );

      },
    ); }

  void AddCategoryDialog() {
    _categoryController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Add New Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: TextField(
          controller: _categoryController,
          decoration: InputDecoration(
            hintText: 'Enter category name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
            ),
            prefixIcon: const Icon(Icons.category),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_categoryController.text.trim().isNotEmpty) {
              await   ref.read(categoryViewModelProvider.notifier)
                    .addCategory(_categoryController.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void DeleteDialogBox(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${category.name}"? ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () async {
             await ref.read(categoryViewModelProvider.notifier)
                  .deleteCategory(category.id.toString());
             Navigator.pop(context);
           },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

}