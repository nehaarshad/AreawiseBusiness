import 'package:ecommercefrontend/View_Model/adminViewModels/categoriesViewModel.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SharedViewModels/categoryProductsViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/wishListButton.dart';

class Exploreproductsview extends ConsumerStatefulWidget {
  final int userId;
  final String category;
  const Exploreproductsview({super.key, required this.userId, required this.category});

  @override
  ConsumerState<Exploreproductsview> createState() => _ExploreproductsviewState();
}

class _ExploreproductsviewState extends ConsumerState<Exploreproductsview> {

  bool _showFilterDropdown = false;
  String _selectedCategory = '';
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _fetchCategories();
  }

  void _fetchCategories() {
    final categoryState = ref.read(categoryViewModelProvider);

    if (categoryState.category != null && categoryState.category!.isNotEmpty) {
      setState(() {
        _categories = categoryState.category!.whereType<Category>().toList();
      });
    } else {
      ref.read(categoryViewModelProvider.notifier).getCategories().then((_) {
        final updatedState = ref.read(categoryViewModelProvider);
        if (updatedState.category != null && updatedState.category!.isNotEmpty) {
          setState(() {
            _categories = updatedState.category!.whereType<Category>().toList();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Products - $_selectedCategory',style: AppTextStyles.headline,),
        actions: [
          // Filter icon button
          TextButton(
            child: const Text("Filter",style: TextStyle(color: Appcolors.baseColorLight30,fontWeight: FontWeight.w700,fontSize: 14),),
            onPressed: () {
              setState(() {
                _showFilterDropdown = !_showFilterDropdown;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              // Watch the product state based on selected category
              final productState = ref.watch(CategoryProductViewModelProvider(_selectedCategory));

              return productState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text("No Products available."));
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.w,
                      mainAxisSpacing: 15.h,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      if (product == null) return const SizedBox.shrink();

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            routesName.productdetail,
                            arguments: {
                              'id': widget.userId,
                              'productId': product.id,
                              'product': product
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: product.images?.isNotEmpty ?? false
                                          ? Image.network(
                                        product.images!.first.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (_, __, ___) =>
                                            Container(
                                              color: Colors.grey[200],
                                              child: const Icon(Icons.image_not_supported),
                                            ),
                                      )
                                          : Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        height: 30.h,
                                        width: 35.w,
                                        decoration: BoxDecoration(
                                          color: Appcolors.baseColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.r),
                                          ),
                                        ),
                                        child: WishlistButton(
                                          color: Appcolors.whiteSmoke,
                                          userId: widget.userId.toString(),
                                          productId: product.id!,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.h, left: 4.w, right: 4.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      product.name ?? "Unknown",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "Rs.${product.price ?? 0}",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14.sp,
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
                error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
              );
            },
          ),

          // Filter dropdown overlay
          if (_showFilterDropdown)
            Positioned(
              top: kToolbarHeight, // Below the app bar
              right: 16.w,
              child: Container(
                width: 200.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Text(
                        'Filter by Category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    Divider(height: 1.h),
                    if (_categories.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      ..._buildCategoryList(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryList() {
    final allCategories = _categories;

    return [
      Container(

        constraints: BoxConstraints(maxHeight: 230.h), // Limit maximum height
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 6.0,
          radius: Radius.circular(3),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final category = allCategories[index];
              return ListTile(
                title: Text(category.name ?? "Unnamed Category"),
                trailing: _selectedCategory == category.name
                    ? const Icon(Icons.check, color: Appcolors.baseColorLight30)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCategory = category.name ?? 'All';
                    _showFilterDropdown = false;
                  });
                },
              );
            },
          ),
        ),
      ),
    ];
  }
}