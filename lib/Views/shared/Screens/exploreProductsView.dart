import 'package:ecommercefrontend/View_Model/adminViewModels/categoriesViewModel.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SharedViewModels/categoryProductsViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/searchBar.dart';
import '../widgets/wishListButton.dart';

class Exploreproductsview extends ConsumerStatefulWidget {
  final int userId;
  final String category;
  final String? condition;
  const Exploreproductsview({super.key, required this.userId, required this.category,required this.condition});

  @override
  ConsumerState<Exploreproductsview> createState() => _ExploreproductsviewState();
}

class _ExploreproductsviewState extends ConsumerState<Exploreproductsview> {
  bool _showFilterDropdown = false;
  String _selectedCategory = '';
  String? _selectedCondition;
  List<Category> _categories = [];
  List<String> conditions = ["New", "Used"];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _selectedCondition = widget.condition;
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
        title: Row(
              children: [
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCondition = null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: _selectedCondition == null
                          ? Appcolors.baseColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Appcolors.baseColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      "All",
                      style: TextStyle(
                        color: _selectedCondition == null
                            ? Colors.white
                            : Appcolors.baseColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Condition buttons
                ...conditions.map((condition) => Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCondition = condition;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: _selectedCondition == condition
                            ? Appcolors.baseColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Appcolors.baseColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        condition,
                        style: TextStyle(
                          color: _selectedCondition == condition
                              ? Colors.white
                              : Appcolors.baseColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              ],
            ),
        actions: [
          Row(
            children: [
              TextButton(
                child: Row(
                  children: [
                    Text(
                      "Sort",
                      style: TextStyle(
                        color: Appcolors.baseColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                    Icon(
                      Icons.filter_alt_rounded,
                      size: 18.h,
                      color: Appcolors.baseColor,
                    )
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _showFilterDropdown = !_showFilterDropdown;
                  });
                },
              ),
            ],
          )
        ],

      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10.h,),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final productState = ref.watch(CategoryProductViewModelProvider(_selectedCategory));

                    return productState.when(
                      loading: () => const Center(
                        child: LinearProgressIndicator(color: Appcolors.baseColor),
                      ),
                      data: (products) {
                        if (products.isEmpty) {
                          return const Center(child: Text("No Products available."));
                        }

                        final filteredProducts = _selectedCondition != null
                            ? products.where((product) => product?.condition == _selectedCondition).toList()
                            : products;

                        if (filteredProducts.isEmpty) {
                          return const Center(child: Text("No Products Found!"));
                        }

                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.w,
                            mainAxisSpacing: 15.h,
                            childAspectRatio: 0.70,
                          ),
                          itemCount: filteredProducts.length,
                          physics: const ScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
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
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                width: 168.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Container with fixed aspect ratio
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: Stack(
                                        children: [
                                          if (product.images != null && product.images!.isNotEmpty)
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8.r),
                                              child: Image.network(
                                                product.images!.first.imageUrl!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  color: Colors.grey[200],
                                                  child: const Icon(Icons.image_not_supported),
                                                ),
                                              ),
                                            )
                                          else
                                            Container(
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(Icons.image_not_supported),
                                              ),
                                            ),
                                          // Wishlist Button
                                          Positioned(
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                  color: Appcolors.baseColor,
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(0),
                                                    bottomLeft: Radius.circular(20),
                                                  ),
                                                ),
                                                child: WishlistButton(
                                                  color: Appcolors.whiteSmoke,
                                                  userId: widget.userId.toString(),
                                                  productId: product.id!,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (product.onSale!)
                                      Row(
                                        children: [
                                          Icon(Icons.discount_outlined, color: Appcolors.baseColor, size: 14.h),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "onSale",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                              color: Appcolors.baseColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    // Product Info
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.h, left: 4.w),
                                      child: Text(
                                        product.name ?? "Unknown",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Price section
                                    product.onSale!
                                        ? Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Rs.",
                                            style: TextStyle(
                                              color: Appcolors.baseColorLight30,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "${product.price ?? 0}",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              decoration: TextDecoration.lineThrough,
                                              decorationColor: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          Text(
                                            "${product.saleOffer?.price ?? 0}",
                                            style: TextStyle(
                                              color: Appcolors.baseColorLight30,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Rs.",
                                            style: TextStyle(
                                              color: Appcolors.baseColorLight30,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "${product.price ?? 0}",
                                            style: TextStyle(
                                              color: Appcolors.baseColorLight30,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                                      child: Row(
                                        children: [
                                          Icon(Icons.delivery_dining_sharp, color: Colors.grey, size: 15.h),
                                          SizedBox(width: 3.w),
                                          Text(
                                            "${product.shop!.deliveryPrice ?? 0}",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
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
              ),
            ],
          ),

          // Filter dropdown overlay - positioned on top of the Column
          if (_showFilterDropdown)
            Positioned(
              top: 10.h, // Add some top margin
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
                        child: const Center(
                          child: LinearProgressIndicator(color: Appcolors.baseColor,),
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
    return [
      Container(
        constraints: BoxConstraints(maxHeight: 250.h),
        child: ListView.builder(
          primary: false, // Prevent ScrollController conflicts
          shrinkWrap: true,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
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
    ];
  }
}