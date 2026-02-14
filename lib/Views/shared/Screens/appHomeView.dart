import 'package:ecommercefrontend/Views/shared/widgets/usedItems.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/DashBoardProductsView.dart';
import '../widgets/categoryTopBar.dart';
import '../widgets/getAllAds.dart';
import '../widgets/getAllFeatureProducts.dart';
import '../widgets/getNewArrivals.dart';
import '../widgets/homePageSearchBar.dart';
import '../widgets/locationBanner.dart';
import '../widgets/servicesTopBar.dart';
import '../widgets/shopsTopBar.dart';

class appHomeview extends ConsumerStatefulWidget {
  final int id;
  const appHomeview({Key? key, required this.id}) : super(key: key);


  @override
  ConsumerState<appHomeview> createState() => _appHomeviewState();
}

class _appHomeviewState extends ConsumerState<appHomeview> {

  int selectedIndex = 0;
  late List<Widget> items = [];
  final List<String> tabs = [
    'Categories',
    'Shops',
    'Services',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = [
      CategoriesButton(id: widget.id.toString()),
      ShopsButton(id: widget.id.toString(),),
      Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'Services Coming Soon',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ];
  }

  Widget topTabBar(){
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex  == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                index = index;
              });
              onTap(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Appcolors.baseColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? Appcolors.baseColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTabContent() {
    switch (selectedIndex) {
      case 0:
        return CategoriesButton(
          id: widget.id.toString(),
        );
      case 1:
        return ShopsButton(
          id: widget.id.toString(),
        );
      case 2:
        return ServicesButton(id: widget.id.toString(),);
      default:
        return const Center(child: Text('Content not available'));
    }
  }
  void onTap(int Index) {
    setState(() {
      selectedIndex = Index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentCategory;
    return SingleChildScrollView(
        child:  Column(
            children: [
              Locationbanner(),
              SizedBox(height: 10.h),
              TopSearchBar(userid: widget.id,),

              SizedBox(height: 3.h),
              const getAdsView(),
              Divider(),
              topTabBar(),
              SizedBox(height: 8.h),
              buildTabContent(),
              SizedBox(height: 8.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                    child: Text(
                      "Featured Products",
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
                          child: TextButton(
                            onPressed: ()async{
                             currentCategory= await ref.watch(selectedCategoryProvider) ;
                              final   parameters={
                                "id": widget.id,
                                "category": currentCategory,
                                "condition":null,
                                "onsale":false,
                              };
                              print(parameters);
                              Navigator.pushNamed(context, routesName.allFeatures,arguments: parameters);


                            },
                            child: Text("View all",
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
                          ),
                        ),

                ],
              ),
              AllFeaturedProducts(userid: widget.id),

              SizedBox(height: 5.h),
              // New Arrivals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                    child: Text(
                      "New Arrivals",
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
                    child: TextButton(
                      onPressed: ()async{
                        currentCategory= await ref.watch(selectedCategoryProvider) ;
                        print("current category on click ${currentCategory}");
                        final   parameters={
                          "id": widget.id,
                          "category": currentCategory,
                          "condition":null,
                          "onsale":false,
                        };
                        print(parameters);
                        Navigator.pushNamed(context, routesName.explore,arguments: parameters);


                      },
                      child: Text("View all",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
                    ),
                  ),
                ],
              ),
              NewArrivals(userid: widget.id,),
              //UsedItems
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                    child: Text(
                      "Used Items",
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
                    child: TextButton(
                      onPressed: ()async{
                        currentCategory= await ref.watch(selectedCategoryProvider) ;
                        print("current category on click ${currentCategory}");
                          final   parameters={
                            "id": widget.id,
                            "category": currentCategory,
                            "condition":"Used",
                            "onsale":false,
                          };
                          print(parameters);
                          Navigator.pushNamed(context, routesName.explore,arguments: parameters);


                      },
                      child: Text("View all",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
                    ),
                  ),
                ],
              ),
              usedItems(userid: widget.id),
              //All Products
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                        child: Text(
                          "Recommended for You",
                          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                 Padding(
                   padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 1.w),
                   child: TextButton(
                     onPressed: ()async{
                       currentCategory= await ref.watch(selectedCategoryProvider) ;

                       print("current category on click ${currentCategory}");
                       final   parameters={
                         "id": widget.id,
                         "category": currentCategory,
                         "condition":null,
                         "onsale":false,
                       };
                       print(parameters);
                       Navigator.pushNamed(context, routesName.explore,arguments: parameters);


                     },
                     child: Text("View all",
                       style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
                   ),
                 ),
               ],
             ),
              AllProducts(userid: widget.id),
            ],
          ),

      );

  }
}
