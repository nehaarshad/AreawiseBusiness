import 'package:ecommercefrontend/Views/shared/widgets/productCard.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/NewArrivalsViewModel.dart';
import 'loadingState.dart';

class NewArrivals extends ConsumerStatefulWidget {
  int userid;
  NewArrivals({required this.userid});

  @override
  ConsumerState<NewArrivals> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<NewArrivals> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted ) {

        ref.read(newArrivalViewModelProvider.notifier).getNewArrivalProduct('All');
      }
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(newArrivalViewModelProvider.notifier).getNewArrivalProduct('All');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(newArrivalViewModelProvider);
    return productState.when(
      loading: () => const Column(
        children: [
          ShimmerListTile(),
        ],
      ),
      data: (products) {
        if (products.isEmpty) {
          return SizedBox(height:100.h,child: const Center(child: Text("No New Products available.")));
        }
        return SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Productcard(product: product!,userid: widget.userid,);
            },
          ),
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
