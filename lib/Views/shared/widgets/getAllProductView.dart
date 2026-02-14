import 'package:ecommercefrontend/Views/shared/widgets/productCard.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import 'loadingState.dart';

class ProductsView extends ConsumerStatefulWidget {
  int userid;
  ProductsView({required this.userid});

  @override
  ConsumerState<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {

  @override
  void initState() {
    super.initState();
    // Fetch all products when the widget is first created
    ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(sharedProductViewModelProvider);
    final location = ref.watch(selectLocationViewModelProvider);

    return productState.when(
      loading: () => const ShimmerListTile(),
            data: (products) {
        if (products.isEmpty) {
          return SizedBox(height:100.h,child: const Center(child: Text("No Products available.")));
        }
        if (location != null) {
          products = products.where((areaProducts) {
            final normalizedArea = (areaProducts?.shop?.sector ?? "")
                .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                .toLowerCase();

            final normalizedLocation = location
                .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                .toLowerCase();

            return normalizedArea.contains(normalizedLocation);
          }).toList();
        }

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  if(product==null){
                    return SizedBox.shrink();
                  }
                  return Productcard(product: product,userid: widget.userid);
                },
              ),
            ),
          ],
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
