import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../View_Model/adminViewModels/categoriesViewModel.dart';
import '../../View_Model/adminViewModels/subCategoriesViewModel.dart';

class SubcategoriesView extends ConsumerStatefulWidget {
  Category category;
  SubcategoriesView({super.key,required this.category});

  @override
  ConsumerState<SubcategoriesView> createState() => _SubcategoriesViewState();
}

class _SubcategoriesViewState extends ConsumerState<SubcategoriesView> {
  final TextEditingController subCategoryController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final subcategories = ref.watch(subCategoryViewModelProvider(widget.category.name!));

    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      appBar: AppBar(
        title: const Text(
          ' Subcategories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Appcolors.whiteColor,
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()=>{
          AddSubcategoryDialog()
      },
      child: Center(child: Icon(Icons.add))
      ),
      body: subcategories.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Appcolors.blueColor),
          ),
        ),
        data: (categories) => Subcategories(categories),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text('Error loading SubCategories'),
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


  Widget Subcategories(List<Subcategory?> sub) {
    if (sub.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No subCategories Yet "),
        ),
      );
    }

    return ListView.builder(
      itemCount: sub.length,
      itemBuilder: (context, index) {
        final subcategory = sub[index];
        return ListTile(
                  title: Text("${subcategory!.name}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (){
                          DeleteDialogBox(subcategory);
                        },
                        icon: Icon(Icons.delete, size: 25,color: Colors.red,),),
                    ],
                  ),
                );
      },
    ); }

  void AddSubcategoryDialog() {
    subCategoryController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Add New Subcategory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: TextField(
          controller: subCategoryController,
          decoration: InputDecoration(
            hintText: 'Enter category name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
            ),
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
              if (subCategoryController.text.trim().isNotEmpty) {
                await   ref.read(subCategoryViewModelProvider(widget.category.name!).notifier)
                    .addSubcategory(subCategoryController.text.trim(),widget.category.id!);
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

  void DeleteDialogBox(Subcategory subcategory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Subcategory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${subcategory.name}"?',
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
              await ref.read(subCategoryViewModelProvider(widget.category.name!).notifier)
                  .deleteSubcategory(subcategory.id.toString());
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
