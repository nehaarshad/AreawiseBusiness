import 'package:ecommercefrontend/View_Model/SellerViewModels/addShopViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SellerViewModels/UpdateShopViewModel.dart';
import '../../../models/categoryModel.dart';

class ShopcategoryDropdown extends ConsumerStatefulWidget {
  final String userid;

  ShopcategoryDropdown({required this.userid, Key? key}) : super(key: key);

  @override
  ConsumerState<ShopcategoryDropdown> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<ShopcategoryDropdown> {
  final TextEditingController shopcategory = TextEditingController();
  final FocusNode focus = FocusNode();
  List<Category> SelectCategories = [];
  bool showDropdown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the logic that depends on inherited widgets to didChangeDependencies
    shopcategory.addListener(RecommendedCategories);
  }

  @override
  void dispose() {
    shopcategory.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedCategories() {
    final input = shopcategory.text.trim().toLowerCase();
    final categories = ref.read(addShopProvider(widget.userid)).categories;

    if (input.isEmpty) {
      setState(() {
        SelectCategories = [];
        showDropdown = false;
      });
      return;
    }

    setState(() {
      SelectCategories =
          categories
              .where((category) => category.name!.toLowerCase().contains(input))
              .toList();
      showDropdown = true;
    });

  }

  void _onCategorySelected(Category category) {
    setState(() {
      shopcategory.text = category.name!;
      showDropdown = false;
      SelectCategories = []; // Clear the suggestions
    });
        ref.read(addShopProvider(widget.userid).notifier).toggleCustomCategory(false);
        ref.read(addShopProvider(widget.userid).notifier).setCategory(category);
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: shopcategory,
          focusNode: focus,
          decoration: InputDecoration(
            labelText: 'Category',
            hintText: 'Select Category',
            suffixIcon:
                shopcategory.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          shopcategory.clear();
                          showDropdown = false;
                          SelectCategories = [];
                        });
                        ref
                            .read(addShopProvider(widget.userid).notifier)
                            .setCategory(null);
                      },
                    )
                    : null,
          ),
          onChanged: (value) {
            ref
                .read(addShopProvider(widget.userid).notifier)
                .setCategory(null); // Reset category while typing
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
      ],
    );
  }
}

class UpdateShopcategoryDropdown extends ConsumerStatefulWidget {
  final String userid;

  UpdateShopcategoryDropdown({required this.userid, Key? key})
    : super(key: key);

  @override
  ConsumerState<UpdateShopcategoryDropdown> createState() =>
      _UpdateCategorySelectorState();
}

class _UpdateCategorySelectorState extends ConsumerState<UpdateShopcategoryDropdown> {
  final TextEditingController shopcategory = TextEditingController();
  final FocusNode focus = FocusNode();
  List<Category> SelectCategories = [];
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    // Initialization logic that doesn't rely on inherited widgets
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the logic that depends on inherited widgets to didChangeDependencies
    final state = ref.watch(updateShopProvider(widget.userid));
    if (state.value?.category != null) {
      shopcategory.text = state.value!.category!.name!;
      shopcategory.addListener(RecommendedCategories);
    }
  }

  @override
  void dispose() {
    shopcategory.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedCategories() {
    final input = shopcategory.text.trim().toLowerCase();
    final viewModel = ref.read(updateShopProvider(widget.userid).notifier);
    final categories = viewModel.categories;
    if (input.isEmpty) {
      setState(() {
        SelectCategories = [];
        showDropdown = false;
      });
      return;
    }

    setState(() {
      SelectCategories =
          categories
              .where(
                (category) =>
                    category.name != null &&
                    category.name!.toLowerCase().contains(input),
              )
              .toList();
      showDropdown = true;
    });

  }

  void _onCategorySelected(Category category) {
    setState(() {
      shopcategory.text = category.name!;
      showDropdown = false;
      SelectCategories = []; // Clear the suggestions
    });
    ref
        .read(updateShopProvider(widget.userid).notifier)
        .toggleCustomCategory(false);
    ref.read(updateShopProvider(widget.userid).notifier).setCategory(category);
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: shopcategory,
          focusNode: focus,
          decoration: InputDecoration(

            labelText: 'Category',
            hintText: 'Select Category',
            suffixIcon:
                shopcategory.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          shopcategory.clear();
                          showDropdown = false;
                          SelectCategories = [];
                        });
                        ref
                            .read(updateShopProvider(widget.userid).notifier)
                            .setCategory(null);
                      },
                    )
                    : null,
          ),
          onChanged: (value) {
            ref
                .read(updateShopProvider(widget.userid).notifier)
                .setCategory(null); // Reset category while typing
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

      ],
    );
  }
}
