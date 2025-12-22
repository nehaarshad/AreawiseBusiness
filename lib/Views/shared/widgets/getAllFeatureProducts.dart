import 'package:ecommercefrontend/Views/shared/widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SellerViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../core/utils/colors.dart';
import 'loadingState.dart';


class AllFeaturedProducts extends ConsumerStatefulWidget {
  int userid;
  AllFeaturedProducts({required this.userid});

  @override
  ConsumerState<AllFeaturedProducts> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<AllFeaturedProducts> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted ) {

        ref.read(featureProductViewModelProvider(widget.userid.toString()).notifier).getAllFeaturedProducts('All');
      }
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(featureProductViewModelProvider(widget.userid.toString()).notifier).getAllFeaturedProducts('All');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(featureProductViewModelProvider(widget.userid.toString()));
    final location = ref.watch(selectLocationViewModelProvider);

    return productState.when(
      loading: () => const ShimmerListTile(),
              data: (products) {
        if (products.isEmpty) {
          return SizedBox(height:100.h,child: const Center(child: Text("No Featured Products available.")));
        }
        if(location != null){
          products = products.where((areaProducts)=>areaProducts?.product?.shop?.sector?.toLowerCase()==location.toLowerCase()).toList();
        }

        if (products.isEmpty) {
          return const Center(child: Text("Oops! No products found in this location."));
        }
        return SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final featuredProduct = products[index];
              final product = featuredProduct?.product;
              print("featured Product ${product?.id}");
              if (product == null || product.id == null) {
                return const SizedBox();
              }
              return Productcard(product: product!,userid: widget.userid);
            },
          ),
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}


