import 'package:ecommercefrontend/View_Model/SellerViewModels/featureStates.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';

class UserProductsDropdown extends ConsumerStatefulWidget {
  final String userid;

  UserProductsDropdown({required this.userid, Key? key}) : super(key: key);

  @override
  ConsumerState<UserProductsDropdown> createState() => _UserProductsState();
}

class _UserProductsState extends ConsumerState<UserProductsDropdown> {
  final TextEditingController products = TextEditingController();
  final FocusNode focus = FocusNode();
  List<ProductModel> productList = [];
  bool productFound = false;
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    // Add listener in initState
    products.addListener(RecommendedCategories);
  }

  @override
  void dispose() {
    products.removeListener(RecommendedCategories); // Remove listener
    products.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedCategories() {
    final input = products.text.trim().toLowerCase();

    // Get products from state instead of reading provider
    final currentState = ref.read(createfeatureProductViewModelProvider(widget.userid.toString()));
    final userProducts = currentState.products;

    if (input.isEmpty) {
      if (mounted) {
        setState(() {
          productList = [];
          productFound = false;
          showDropdown = false;
        });
      }
      return;
    }

    final filteredProducts = userProducts
        .where((product) => product.name!.toLowerCase().contains(input))
        .toList();

    if (mounted) {
      setState(() {
        productList = filteredProducts;
        productFound = filteredProducts.isEmpty;
        showDropdown = true;
      });
    }

    // Update provider state
    if (productFound) {
      ref.read(createfeatureProductViewModelProvider(widget.userid).notifier).toggleCustomProduct(true);
    } else {
      ref.read(createfeatureProductViewModelProvider(widget.userid).notifier).toggleCustomProduct(false);
    }
  }

  void onProductSelection(ProductModel product) {
    if (mounted) {
      setState(() {
        products.text = product.name!;
        showDropdown = false;
        productFound = false;
        productList = [];
      });
    }

    ref.read(createfeatureProductViewModelProvider(widget.userid).notifier).toggleCustomProduct(false);
    ref.read(createfeatureProductViewModelProvider(widget.userid).notifier).setProduct(product);
    focus.unfocus();
  }

  void _clearSelection() {
    if (mounted) {
      setState(() {
        products.clear();
        showDropdown = false;
        productList = [];
        productFound = false;
      });
    }
    ref.read(createfeatureProductViewModelProvider(widget.userid).notifier).setProduct(null);
    ref.read(createfeatureProductViewModelProvider(widget.userid).notifier).toggleCustomProduct(false);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to provider changes but don't cause rebuilds
    ref.listen<createFeatureProductState>(
      createfeatureProductViewModelProvider(widget.userid.toString()),
          (previous, next) {
        // Only react to specific state changes if needed
        if (previous?.products != next.products) {
          // Products list changed, update recommendations if needed
          if (products.text.isNotEmpty) {
            RecommendedCategories();
          }
        }
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        TextField(
          controller: products,
          focusNode: focus,
          decoration: InputDecoration(
            labelText: 'Products',
            hintText: 'Select Product',
            suffixIcon: products.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearSelection,
            )
                : null,
          ),
          onChanged: (value) {
            // Reset selected product while typing
            ref.read(createfeatureProductViewModelProvider(widget.userid).notifier).setProduct(null);
            // Don't call RecommendedCategories here since it's handled by listener
          },
          onTap: () {
            if (mounted) {
              setState(() {
                // Only show dropdown if there are products to show
                showDropdown = productList.isNotEmpty;
              });
            }
          },
        ),
        SizedBox(height: 8.h),

        if (showDropdown && productList.isNotEmpty)
          SingleChildScrollView(
            child: Container(
              height: 150.h,
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
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 6.0,
                radius: Radius.circular(3),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return ListTile(
                      title: Text(product.name!),
                      onTap: () => onProductSelection(product),
                    );
                  },
                ),
              ),
            ),
          ),

        if (productFound && products.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'No Product Found!',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}