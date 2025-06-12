import 'package:ecommercefrontend/View_Model/SellerViewModels/addProductViewModel.dart';
import 'package:ecommercefrontend/View_Model/SellerViewModels/updateProductViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/SubCategoryModel.dart';
import '../../../models/categoryModel.dart';
//for category Selection
class ProductCategoryDropdown extends ConsumerStatefulWidget {
  final String shopid;

  ProductCategoryDropdown({required this.shopid, Key? key}) : super(key: key);

  @override
  ConsumerState<ProductCategoryDropdown> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<ProductCategoryDropdown> {
  final TextEditingController ProductCategory = TextEditingController();
  final FocusNode focus = FocusNode();
  List<Category> SelectCategories = [];
  bool addnewCategory = false;
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the logic that depends on inherited widgets to didChangeDependencies
    ProductCategory.addListener(RecommendedCategories);
  }

  @override
  void dispose() {
    ProductCategory.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedCategories() {
    final input = ProductCategory.text.trim().toLowerCase();
    final categories = ref.read(addProductProvider(widget.shopid)).categories;

    if (input.isEmpty) {
      setState(() {
        SelectCategories = [];
        addnewCategory = false;
        showDropdown = false;
      });
      return;
    }

    setState(() {
      SelectCategories = categories.where((category) => category.name!.toLowerCase().contains(input)).toList();
      addnewCategory = SelectCategories.isEmpty;
      showDropdown = true;
    });
    if (addnewCategory) {
      ref.read(addProductProvider(widget.shopid).notifier).toggleCustomCategory(true);
    } else {
      ref.read(addProductProvider(widget.shopid).notifier).toggleCustomCategory(false);
    }
  }

  void _onCategorySelected(Category category) {
    setState(() {
      ProductCategory.text = category.name!;
      showDropdown = false;  // Hide dropdown after selection
      addnewCategory = false;
      SelectCategories = [];  // Clear the suggestions
    });
    ref.read(addProductProvider(widget.shopid).notifier).toggleCustomCategory(false);
    ref.read(addProductProvider(widget.shopid).notifier).setCategory(category);
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ProductCategory,
          focusNode: focus,
          decoration: InputDecoration(
            labelText: 'Category',
            suffixIcon: ProductCategory.text.isNotEmpty ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  ProductCategory.clear();
                  showDropdown = false;
                  SelectCategories = [];
                });
                ref.read(addProductProvider(widget.shopid).notifier).setCategory(null);
              },
            ) : null,
          ),
          onChanged: (value) {
            ref.read(addProductProvider(widget.shopid).notifier).setCategory(null);
            RecommendedCategories();
          },
          onTap: () {
            setState(() {
              // Only show dropdown if there are categories to show
              showDropdown = SelectCategories.isNotEmpty;
            });
          },
        ),

        if (showDropdown && SelectCategories.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.r,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: SelectCategories.length,
              itemBuilder: (context, index) {
                final category = SelectCategories[index];
                return ListTile(
                  title: Text(category.name!),
                  onTap: () => _onCategorySelected(category),
                );
              },
            ),
          ),
        if (addnewCategory && ProductCategory.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'No Category exist!',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}

//for subcategory selection
class ProductSubcategoryDropdown extends ConsumerStatefulWidget {
  final String shopId;
  const ProductSubcategoryDropdown({required this.shopId, Key? key}) : super(key: key);

  @override
  ConsumerState<ProductSubcategoryDropdown> createState() => _SubcategoryDropdownState();
}

class _SubcategoryDropdownState extends ConsumerState<ProductSubcategoryDropdown> {
  final TextEditingController subcategoryController = TextEditingController();
  final FocusNode subcategoryFocus = FocusNode();
  List<Subcategory> recommendedSubcategories = [];
  bool showSubcategoryDropdown = false;
  bool addnewSubCategory = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the logic that depends on inherited widgets to didChangeDependencies
    subcategoryController.addListener(findSubcategories);
  }

  @override
  void dispose() {
    subcategoryController.dispose();
    subcategoryFocus.dispose();
    super.dispose();
  }

  void findSubcategories() {
    final input = subcategoryController.text.trim().toLowerCase();
    final subcategories = ref.read(addProductProvider(widget.shopId)).subcategories;

    if (input.isEmpty) {
      setState(() {
        recommendedSubcategories = [];
        showSubcategoryDropdown = false;
        addnewSubCategory=false;
      });
      return;
    }

    setState(() {
      recommendedSubcategories = subcategories.where((subcategory) => subcategory.name!.toLowerCase().contains(input))
          .toList();
      showSubcategoryDropdown = recommendedSubcategories.isNotEmpty;
      addnewSubCategory=recommendedSubcategories.isEmpty;
    });
    if (addnewSubCategory) {
      ref.read(addProductProvider(widget.shopId).notifier).toggleCustomSubcategory(true);
      } else {
      ref.read(addProductProvider(widget.shopId).notifier).toggleCustomSubcategory(false);

    }
  }

  void SubcategorySelection(Subcategory subcategory) {
    setState(() {
      subcategoryController.text = subcategory.name!;
      showSubcategoryDropdown = false;
      addnewSubCategory=false;
      recommendedSubcategories = [];
    });
    ref.read(addProductProvider(widget.shopId).notifier).toggleCustomSubcategory(false);
    ref.read(addProductProvider(widget.shopId).notifier).setSubcategory(subcategory);
    subcategoryFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(addProductProvider(widget.shopId));

    // If no category is selected, show disabled field
    if (state.selectedCategory == null) {
      return TextField(
        enabled: false,
        decoration: InputDecoration(
          labelText: 'Subcategory',
          hintText: 'Select a category first',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: subcategoryController,
          focusNode: subcategoryFocus,
          decoration: InputDecoration(
            labelText: 'Subcategory',
            hintText: 'Search Subcategory',
            suffixIcon: subcategoryController.text.isNotEmpty ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  subcategoryController.clear();
                  showSubcategoryDropdown = false;
                  recommendedSubcategories = [];
                });
                ref.read(addProductProvider(widget.shopId).notifier).setSubcategory(null);
              },
            )
                : null,
          ),
          onChanged: (value) {
            ref.read(addProductProvider(widget.shopId).notifier).setSubcategory(null);
            findSubcategories();
          },
          onTap: () {
            setState(() {
              // Only show dropdown if there are categories to show
              showSubcategoryDropdown = recommendedSubcategories.isNotEmpty;
            });
          },
        ),

        if (showSubcategoryDropdown && recommendedSubcategories.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: recommendedSubcategories.length,
              itemBuilder: (context, index) {
                final subcategory = recommendedSubcategories[index];
                return ListTile(
                  title: Text(subcategory.name!),
                  onTap: () => SubcategorySelection(subcategory),
                );
              },
            ),
          ),
        if (addnewSubCategory && subcategoryController.text.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'No SubCategory exist',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }
}

///FOR UPDATEVIEWS

class updateProductCategoryDropdown extends ConsumerStatefulWidget {
  final String shopid;

  updateProductCategoryDropdown({required this.shopid, Key? key}) : super(key: key);

  @override
  ConsumerState<updateProductCategoryDropdown> createState() => _updateCategorySelectorState();
}

class _updateCategorySelectorState extends ConsumerState<updateProductCategoryDropdown> {
  final TextEditingController ProductCategory = TextEditingController();
  final FocusNode focus = FocusNode();
  List<Category> SelectCategories = [];
  bool addnewCategory = false;
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the logic that depends on inherited widgets to didChangeDependencies
    final state = ref.watch(updateProductProvider(widget.shopid));
    if (state.value?.category != null) {
      ProductCategory.text = state.value!.category!.name!;
      ProductCategory.addListener(RecommendedCategories);
    }
  }
  @override
  void dispose() {
    ProductCategory.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedCategories() {
    final input = ProductCategory.text.trim().toLowerCase();
    final productvalue = ref.read(updateProductProvider(widget.shopid).notifier);
    final categories = productvalue.categories;
    if (input.isEmpty) {
      setState(() {
        SelectCategories = [];
        addnewCategory = false;
        showDropdown = false;
      });
      return;
    }

    setState(() {
      SelectCategories = categories.where((category) => category.name != null && category.name!.toLowerCase().contains(input)).toList();
      addnewCategory = SelectCategories.isEmpty;
      showDropdown = true;
    });
    if (addnewCategory) {
      ref.read(updateProductProvider(widget.shopid).notifier).toggleCustomCategory(true);
    }
    else {
      ref.read(updateProductProvider(widget.shopid).notifier).toggleCustomCategory(false);
    }
  }

  void _onCategorySelected(Category category) {
    setState(() {
      ProductCategory.text = category.name!;
      showDropdown = false;  // Hide dropdown after selection
      addnewCategory = false;
      SelectCategories = [];  // Clear the suggestions
    });
    ref.read(updateProductProvider(widget.shopid).notifier).toggleCustomCategory(false);
    ref.read(updateProductProvider(widget.shopid).notifier).setCategory(category);
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ProductCategory,
          focusNode: focus,
          decoration: InputDecoration(
            labelText: 'Category',
            suffixIcon: ProductCategory.text.isNotEmpty ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  ProductCategory.clear();
                  showDropdown = false;
                  SelectCategories = [];
                });
                ref.read(updateProductProvider(widget.shopid).notifier).setCategory(null);
              },
            ) : null,
          ),
          onChanged: (value) {
            ref.read(updateProductProvider(widget.shopid).notifier).setCategory(null);
            RecommendedCategories();
          },
          onTap: () {
            setState(() {
              showDropdown = SelectCategories.isNotEmpty;
            });
          },
        ),

        if (showDropdown && SelectCategories.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.r,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: SelectCategories.length,
              itemBuilder: (context, index) {
                final category = SelectCategories[index];
                return ListTile(
                  title: Text(category.name!),
                  onTap: () => _onCategorySelected(category),
                );
              },
            ),
          ),

        if (addnewCategory && ProductCategory.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'No Category exist',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}

class updateProductSubcategoryDropdown extends ConsumerStatefulWidget {
  final String shopId;
  const updateProductSubcategoryDropdown({required this.shopId, Key? key}) : super(key: key);

  @override
  ConsumerState<updateProductSubcategoryDropdown> createState() => _updateSubcategoryDropdownState();
}

class _updateSubcategoryDropdownState extends ConsumerState<updateProductSubcategoryDropdown> {
  final TextEditingController subcategoryController = TextEditingController();
  final FocusNode subcategoryFocus = FocusNode();
  List<Subcategory> recommendedSubcategories = [];
  bool showSubcategoryDropdown = false;
  bool addnewSubCategory = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = ref.watch(updateProductProvider(widget.shopId));
    if (state.value?.subcategory != null) {
      subcategoryController.text = state.value!.subcategory!.name!;
      subcategoryController.addListener(findSubcategories);
    }
  }

  @override
  void dispose() {
    subcategoryController.dispose();
    subcategoryFocus.dispose();
    super.dispose();
  }

  void findSubcategories() {
    final input = subcategoryController.text.trim().toLowerCase();
    final productsubcategories = ref.read(updateProductProvider(widget.shopId).notifier);
    final subcategories = productsubcategories.Subcategories;

    if (input.isEmpty) {
      setState(() {
        recommendedSubcategories = [];
        showSubcategoryDropdown = false;
        addnewSubCategory = false;
      });
      return;
    }

    setState(() {
      recommendedSubcategories = subcategories
          .where((subcategory) => subcategory.name != null && subcategory.name!.toLowerCase().contains(input))
          .toList();
      showSubcategoryDropdown = true;
      addnewSubCategory = recommendedSubcategories.isEmpty;
    });

    if (addnewSubCategory) {
      ref.read(updateProductProvider(widget.shopId).notifier).toggleCustomSubcategory(true);
      ref.read(updateProductProvider(widget.shopId).notifier).setCustomSubcategoryName(subcategoryController.text);
    } else {
      ref.read(updateProductProvider(widget.shopId).notifier).toggleCustomSubcategory(false);
    }
  }

  void SubcategorySelection(Subcategory subcategory) {
    setState(() {
      subcategoryController.text = subcategory.name!;
      showSubcategoryDropdown = false;
      addnewSubCategory = false;
      recommendedSubcategories = [];
    });
    ref.read(updateProductProvider(widget.shopId).notifier).toggleCustomSubcategory(false);
    ref.read(updateProductProvider(widget.shopId).notifier).setSubcategory(subcategory);
    subcategoryFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: subcategoryController,
          focusNode: subcategoryFocus,
          decoration: InputDecoration(
            labelText: 'Subcategory',
            hintText: 'Select Subcategory',
            suffixIcon: subcategoryController.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  subcategoryController.clear();
                  showSubcategoryDropdown = false;
                  recommendedSubcategories = [];
                });
                ref.read(updateProductProvider(widget.shopId).notifier).setSubcategory(null);
              },
            )
                : null,
          ),
          onChanged: (value) {
            ref.read(updateProductProvider(widget.shopId).notifier).setSubcategory(null);
            findSubcategories();
          },
          onTap: () {
            setState(() {
              showSubcategoryDropdown = recommendedSubcategories.isNotEmpty;
            });
          },
        ),

        if (showSubcategoryDropdown && recommendedSubcategories.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.r,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: recommendedSubcategories.length,
              itemBuilder: (context, index) {
                final subcategory = recommendedSubcategories[index];
                return ListTile(
                  title: Text(subcategory.name!),
                  onTap: () => SubcategorySelection(subcategory),
                );
              },
            ),
          ),

        // Fixed the error here - separate the clear action from the widget display
        if (addnewSubCategory && subcategoryController.text.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'No SubCategory exist',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }
}