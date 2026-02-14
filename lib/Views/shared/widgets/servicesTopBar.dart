import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/View_Model/SharedViewModels/getOnSaleProducts.dart';
import 'package:ecommercefrontend/View_Model/adminViewModels/servicesViewModel.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/servicesModel.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/NewArrivalsViewModel.dart';
import '../../../View_Model/SellerViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../View_Model/adminViewModels/ShopViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import 'loadingState.dart';

class ServicesButton extends ConsumerStatefulWidget {
  final String id;
  ServicesButton({super.key, required this.id});
  @override
  _ServicesButtonState createState() => _ServicesButtonState();
}

class _ServicesButtonState extends ConsumerState<ServicesButton> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateIndicator);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateIndicator() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final page = (currentScroll / (maxScroll / 2)).round();

      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final State = ref.watch(serviceViewModelProvider);

    List<Services?> services=[];
    if (State.isLoading) {
      return const ShimmerListTile();
    }

    if (State.services == null ||  State.services!.isEmpty) {
      return const Center(
        child: Text("No services available."),
      );
    }

    print(State.services?.map((s)=>s?.status!));
    services = State.services!
        .where((service) => service?.status == "Active")
        .toList();
    if (services.isEmpty) {
      return const Center(
        child: Text("No active services available."),
      );
    }


      return Column(
        children: [

          SizedBox(
            height: 120.h,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 3.w,
                childAspectRatio: 0.80,
              ),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemBuilder: (context, index) {
                final service = services[index];
                String? imageUrl;
                if (service?.imageUrl != null && service!.imageUrl!.isNotEmpty) {
                  imageUrl = service.imageUrl!;
                }

                return GestureDetector(
                  onTap: () {
                    final parameters = {
                      'Services': service,
                      'isAdmin': false,
                    };
                    Navigator.pushNamed(
                      context,
                      routesName.serviceProviders,
                      arguments: parameters,
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image Container
                      Container(
                        width: 60.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(
                                  color: Colors.grey[100],
                                  child: Icon(
                                    Icons.category,
                                    color: Colors.grey[400],
                                    size: 18,
                                  ),
                                ),
                            errorWidget: (context, url, error) =>
                                Container(
                                  color: Colors.grey[100],
                                  child: Icon(
                                    Icons.category,
                                    color: Colors.grey[400],
                                    size: 18,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Flexible(
                        child: Text(
                          service?.name ?? '',
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          _buildScrollIndicator(services),
        ],
      );


  }
 Widget _buildScrollIndicator(List<Services?> shops) {
    final itemsPerScreen = 5;
    final totalPages = (shops.length / itemsPerScreen).ceil();

    if (totalPages <= 1) return SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Container(
          width: 8.w,
          height: 8.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Appcolors.baseColor
                : Colors.grey[300],
          ),
        );
      }),
    );
  }
}