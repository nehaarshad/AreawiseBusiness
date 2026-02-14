import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/View_Model/SellerViewModels/sellerServicesViewModel.dart';
import 'package:ecommercefrontend/Views/sellerscrens/widgets/sellerProductTabs.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/productViewModels.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/colors.dart';
import '../shared/widgets/loadingState.dart';
import '../shared/widgets/searchBar.dart';

class SellerServicesview extends ConsumerStatefulWidget {
  final int id;
  const SellerServicesview({required this.id});

  @override
  ConsumerState<SellerServicesview> createState() => _SellerServicesviewState();
}

class _SellerServicesviewState extends ConsumerState<SellerServicesview> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Add this to ensure fresh data
      ref.invalidate(sellerServiceViewModelProvider(widget.id.toString()));
      await ref.read(sellerServiceViewModelProvider(widget.id.toString()));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      ref.invalidate(sellerServiceViewModelProvider(widget.id.toString()));
      await ref.read(sellerServiceViewModelProvider(widget.id.toString()).notifier).getUserServices(widget.id.toString());
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerServiceViewModelProvider(widget.id.toString()));

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "My Service's",
            style: AppTextStyles.headline
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h,),
                Consumer(
                  builder: (context, ref, child) {
                    return state.when(
                      loading: () => const Column(
                        children: [
                          ShimmerListTile(),
                          ShimmerListTile(),
                          ShimmerListTile(),

                        ],
                      ),
                      data: (services) {

                        if (services.isEmpty ) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text("No services Available"),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            if (service == null) {
                              return const SizedBox.shrink();
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  routesName.serviceDetailsView,
                                  arguments:  service.provider
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
                                      child: (service.provider.ImageUrl != null )
                                          ? ClipRRect(
                                            child: CachedNetworkImage(
                                                  imageUrl:  service.provider.ImageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, error, stackTrace) {
                                                          return const Icon(Icons.error);
                                                                                    },
                                                                                  ),
                                          )
                                          :  Icon(Icons.image_not_supported, size: 40.h),
                                    ),
                                    title: Text(
                                      service.serviceName ?? 'No Service Category',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      service.provider.providerName ?? 'No Service Provider ',
                                    ),

                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              routesName.updateServiceProvider,
                                              arguments: service.provider,
                                            );
                                          },
                                          icon: Icon(Icons.edit, color: Appcolors.baseColor),
                                          tooltip: "Edit Product",
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async {
                                            if (service.provider.id != null) {
                                              await ref.read(sellerServiceViewModelProvider(widget.id.toString()).notifier)
                                                  .deleteProvider(service.provider.id.toString());
                                            }
                                          },
                                          tooltip: "Delete",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 1.h),

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
                              Text('Error loading services'),
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

