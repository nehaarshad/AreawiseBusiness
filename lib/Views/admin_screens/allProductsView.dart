import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/View_Model/adminViewModels/allProductsViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../View_Model/SharedViewModels/productViewModels.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/colors.dart';
import '../shared/widgets/loadingState.dart';
import '../shared/widgets/searchBar.dart';
import '../shared/widgets/selectAreafloatingButton.dart';

class AllProductsview extends ConsumerStatefulWidget {
  final int id;
  const AllProductsview({required this.id});

  @override
  ConsumerState<AllProductsview> createState() => _AllProductsviewState();
}

class _AllProductsviewState extends ConsumerState<AllProductsview> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Add this to ensure fresh data
      ref.invalidate(ProductManagementViewModelProvider);
      await ref.read(ProductManagementViewModelProvider.notifier).getAllProduct('All');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      ref.invalidate(ProductManagementViewModelProvider);
      await ref.read(ProductManagementViewModelProvider.notifier).getAllProduct('All');
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(ProductManagementViewModelProvider);
    final location = ref.watch(selectLocationViewModelProvider);

    return Scaffold(
      floatingActionButton: selectLocationFloatingButton(),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h,),
                searchBar(id: widget.id,isAdmin: true,),
                SizedBox(height: 10.h,),
                Consumer(
                  builder: (context, ref, child) {
                    return productState.when(
                      loading: () => const Column(
                        children: [
                          ShimmerListTile(),
                          ShimmerListTile(),
                          ShimmerListTile(),
                          ShimmerListTile(),
                          ShimmerListTile(),
                          ShimmerListTile(),
                        ],
                      ),
                      data: (products) {
                        if (products.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text("No Products Available"),
                            ),
                          );
                        }
                        if(location != null){
                          products = products.where((areaProducts)=>areaProducts?.shop?.sector?.toLowerCase()==location.toLowerCase()).toList();
                        }

                        if (products.isEmpty) {
                          return const Center(child: Text("Oops! No products found in this location."));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            if (product == null) {
                              return const SizedBox.shrink();
                            }
                            return  InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    routesName.productdetail,
                                    arguments: {
                                      'id': widget.id,
                                      'productId':product.id,
                                      'product': product
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10),
                                      leading: Container(
                                        width: 60.w,
                                        height: 60.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: (product.images != null &&
                                            product.images!.isNotEmpty &&
                                            product.images!.first.imageUrl != null)
                                            ? CachedNetworkImage(
                                        imageUrl:   product.images!.first.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, error, stackTrace) {
                                            return const Icon(Icons.error);
                                          },
                                        )
                                            :  Icon(Icons.image_not_supported, size: 40.h),
                                      ),
                                      title: Text(
                                        product.name ?? 'No Name',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        product.category?.name ?? 'No Category',
                                        style:  TextStyle(fontSize: 12.sp),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    routesName.sEditProduct,
                                                    arguments: product,
                                                  );
                                                },
                                                icon: Icon(Icons.edit, color: Appcolors.baseColor),
                                                tooltip: "Edit Product",
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Colors.red),
                                                onPressed: () async {
                                                  if (product.id != null) {
                                                    await ref.read(ProductManagementViewModelProvider.notifier)
                                                        .deleteProduct(product.id.toString(), widget.id.toString());
                                                    await ref.read(sharedProductViewModelProvider.notifier)
                                                        .deleteProduct(product.id.toString(), widget.id.toString());
                                                    await ref.read(ProductManagementViewModelProvider.notifier).getAllProduct('All');
                                                    await ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
                                                  }
                                                },
                                                tooltip: "Delete Product",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
            
                                  ],
                                ),
                              );

                          },
                        );
                      },
                      error: (error, stackTrace) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: 48.h),
                              SizedBox(height: 16.h),
                              Text('Error loading products: ${error.toString()}'),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(sharedProductViewModelProvider.notifier).getUserProduct(widget.id.toString());
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
      ),
    );
  }
}