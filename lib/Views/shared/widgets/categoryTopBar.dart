import 'package:ecommercefrontend/View_Model/SharedViewModels/getOnSaleProducts.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/NewArrivalsViewModel.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/getAllCategories.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';


class CategoriesButton extends ConsumerWidget {
  final String id;
  CategoriesButton({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    void onCategoryChange(String category) async {
      try {
        // Update the selectedCategory in the provider
        ref.read(selectedCategoryProvider.notifier).state = category;

        // Fetch products based on selected category with error handling
        await Future.wait([
          ref.read(featureProductViewModelProvider(id).notifier)
              .getAllFeaturedProducts(category),
          ref.read(sharedProductViewModelProvider.notifier)
              .getAllProduct(category),
          ref.read(onSaleViewModelProvider.notifier)
              .getonSaleProduct(category),
          ref.read(newArrivalViewModelProvider.notifier)
              .getNewArrivalProduct(category),
        ]);
      } catch (e) {
        print('Error fetching products: $e');
      }
    }

    final categoriesAsync = ref.watch(GetallcategoriesProvider);
print(categoriesAsync.value?.length);
    return SizedBox(
      height: 80,
      child: categoriesAsync.when(
        data: (categories) {
          print(categories);
          if (categories.isEmpty) {
            return const SizedBox.shrink();
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              print(category.name);
              final categoryName = category.name ?? "All";
              var ImageUrl="data:image/webp;base64,UklGRjwFAABXRUJQVlA4IDAFAADQIwCdASq+AL4APp1Io0olpKOhrBVY+LATiWduz44FXN5K/QeYezjgAOWC0B0Idj8pDgLpIJnnjT/Ov877BXRv/cz2OP1HNJSe3XmDnqDqeM320OR2MvqY+QGNtVEuKTaKYw0V9/3I4Xj+kV0SRuqCPZ3XJexpJvzn6WYsqEH0inuCVqPz9BwDMItkhzjxkvylhU3O4wEYmtxpzKu1BDYEDy39D02XxQAVmwK0ZIOjNu4319pM9JpGm/jBDOcRM+0NxDUXUvsj6iI6Ml606XaNNMGRZmAk3XJ8igTEg/rzG7SPaNQZnYllAv8Z1C7SvJ21TTyRPqalQTe2Ld5IcS9CsRCjzlkvclLXSBTZvhA/0Ftnc3EN+yNTGjjZFGr+qHbG99MTi2gAAP74pBnvnmi3d7+u5oBJ+0K64ffUGLMrKc1G9xIxDp+HIZvc6vAS2uW6B7s+7WlzGsovcx7Cviau3PaZds9eiouTa9pXbqFCnQKeTGpgZ0GyhVqlgOLS7wBdVctNBHU8OuH8wLceftadOeIdXQ1aY1yyFISnbNIHOQUR+Pnb8E2PF/lY1nLema9/Iu9bIzLW2janzsJ/4fz7DYs+V7WXfpvL5ZPECp4QoUbVIZYmq3l3dn7QOQNYQe6+rdT/gqCrMaNRM/L2TMtw99MJtyvng4AhuvF89PJk8oArbpSaUDeX7yW8KeJZxPK1zMi7HALBiDlNlwW1AipvM5wkpHG8yZWNcJWOHnQKGaIvzJzcwxt5I1M808rvRlmYUvwziODkPYHkcfeoUX9cNW74S634zVn/nbnn9vJ+9V5AtL/bk1Gcqx9gxNECN3TEZ38ihfpZvRWWsj3BJOcJDRJ59RqpqmjkaPu8TLqbmsqERMFNHrr78GDW1Qvx2rCTrvU18sLRXOO7pjCn3vzCoNmDyVQ1wssejpyNcZxipR5QSZ1nfUgupxqtvMxLlbAURVuAD0OyLQmzgYCDN0flWhf1+sp5bFzdSLtehVBN8Dwy4bzubUys7fCIpH7UzHek0uLq8txqF8nlgz6IHowFuLAr4BWkbKo1c1mBvmhcE5xhJot/udskhAdh4rDM0FvWgyRfCjKR9+bENbToLjUtO6vjC6Yj4jrzrtFQuIDMv7Kq8qADnbibWWUTBD8bNVZubBbM+QhFW/cQ+kZamS8zzyWAMN0kCqrL58WTVyhfGuGrbNKPPiq+HO2eoPpMLl7fcQwOJhWgUQR5IU3fYfcB8snmsGWESIhTbU8hrY7HEPSd8vzM/D5h6PhjWgM5KwioX7KN3qvGaKWg6VsWx5wdSFQ4x86dDrZA/5E+hs8QWwT/fx2c5C1PPkzs5hFCHQWmcUrGXxBnIM+gq3RNGbnJjPu6o9r9OzWxXYFPO/oGJkaJCiLtypwkTQ1c7sKVM6aHm/9OJlVTvBnGReDkvUQtJsFSzYBIxLC7+rDAgh+GL7U/5gQFAgCpedu1oPFDItTLttkqbujhnG/qPRTwBeR0BCKK7aS1GWzVYs4cI9IWD8SrpSwtyVOVIcm3iNYWHhS0zzfu+vSKUwWFbxKoLq0o6BMpq4aEi46jHz4Y91lAHlGEwbqF1HIyyTK+bJWWkjMmztOBQIB/faXDqKSkZjRaTEK1Z87ubE/HiTEfazRNCwv99AfK26azQUGEtIR9vWO8fgGPgsU3cgmPWLCf6wrAv7v2tGSrwLuS5wtn8xDjhTVh+g6p1macQpMvpDwKzkBaDWhh4nqUAL3cO0OTCzGcko281WmlscwDlAAgKWAAAA==";
              if(category.image != null && category.image!.imageUrl!.isNotEmpty) {
                 ImageUrl = category.image!.imageUrl!;
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                child:  GestureDetector(
                  onTap: (){ onCategoryChange(categoryName);},
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: NetworkImage(ImageUrl)

                    ),
                    SizedBox(height: 5.h,),
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 10.h,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                                ),
                ) ,
                // child: ChoiceChip(
                //   label: Text(categoryName),
                //   selected: selectedCategory == categoryName,
                //   onSelected: (selected) {
                //     if (selected) {
                //       onCategoryChange(categoryName);
                //     }
                //   },
                // ),
              );
            },
          );
        },
        loading: () => const Center(child: LinearProgressIndicator(color: Appcolors.baseColor,)),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}