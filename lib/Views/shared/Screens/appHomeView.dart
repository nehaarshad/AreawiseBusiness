import 'package:ecommercefrontend/Views/shared/widgets/searchBar.dart';
import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../widgets/DashBoardProductsView.dart';
import '../widgets/categoryTopBar.dart';
import '../widgets/getAllAds.dart';
import '../widgets/getAllFeatureProducts.dart';
import '../widgets/logout_button.dart';

class appHomeview extends ConsumerStatefulWidget {
  final int id;
  appHomeview({required this.id});

  @override
  ConsumerState<appHomeview> createState() => _appHomeviewState();
}

class _appHomeviewState extends ConsumerState<appHomeview> {

  @override
  void initState() {
    super.initState();
    // Initial load with 'All' category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedCategory = ref.read(selectedCategoryProvider);
      ref.read(featureProductViewModelProvider(widget.id.toString()).notifier).getAllFeaturedProducts(selectedCategory);
      ref.read(sharedProductViewModelProvider.notifier).getAllProduct(selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const searchBar(),
           CategoriesButton(id: widget.id.toString(),),
          const SizedBox(height: 10),
          const getAdsView(),
          const SizedBox(height: 10),
          // Featured Products
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text(
                  "Featured Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  const Text("See All", style: TextStyle(color: Colors.grey)),
                  const Icon(Icons.arrow_forward_ios_sharp, size: 10),
                ],
              ),
            ],
          ),
          AllFeaturedProducts(userid: widget.id),
          const SizedBox(height: 20),
          // New Arrivals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text(
                  "New Arrival",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  const Text("See All", style: TextStyle(color: Colors.grey)),
                  const Icon(Icons.arrow_forward_ios_sharp, size: 10),
                ],
              ),
            ],
          ),
          AllProducts(userid: widget.id),
        ],
      ),
    );
  }
}
