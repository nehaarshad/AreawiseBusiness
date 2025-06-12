import 'package:ecommercefrontend/View_Model/SharedViewModels/searchBarViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/SubCategoryModel.dart';

class searchBar extends ConsumerStatefulWidget {
  final int id;
  const searchBar({super.key, required this.id});

  @override
  ConsumerState<searchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<searchBar> {
  final TextEditingController searchText = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  List<Subcategory> recommendedSubcategories = [];
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    searchText.addListener(_onSearchChanged);
    searchFocus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    searchText.removeListener(_onSearchChanged);
    searchFocus.removeListener(_onFocusChanged);
    searchText.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!searchFocus.hasFocus) {
      setState(() {
        showSuggestions = false;
      });
    } else if (searchText.text.isNotEmpty) {
      setState(() {
        showSuggestions = true;
      });
    }
  }

  void _onSearchChanged() async {
    if (searchText.text.isEmpty) {
      setState(() {
        showSuggestions = false;
        recommendedSubcategories = [];
      });
      return;
    }

    setState(() {
      showSuggestions = true;
    });

    final allSubcategories = await ref.read(searchProductProvider.notifier).getSubcategories();
    print('Fetched ${allSubcategories.length} subcategories');
    final input = searchText.text.trim().toLowerCase();

    setState(() {
      recommendedSubcategories = allSubcategories
          .where((subcategory) => subcategory.name!.toLowerCase().contains(input))
          .toList();
    });
  }

  void _navigateToSearch(String searchQuery) {
    if (searchQuery.trim().isNotEmpty) {
      final parameters = {
        'id': widget.id,
        'search': searchQuery.trim(),
      };
      Navigator.pushNamed(context, routesName.search, arguments: parameters);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Padding(
           padding:  EdgeInsets.symmetric(horizontal: 10.0.h),
           child: TextField(
              controller: searchText,
              focusNode: searchFocus,
              decoration: InputDecoration(
                hintText: "Search Products",
                suffixIcon: IconButton(
                  onPressed: () {
                    if (searchText.text.trim().isNotEmpty) {
                      _navigateToSearch(searchText.text);
                    }
                  },
                  icon: const Icon(Icons.search,color: Appcolors.blueColor,),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(70.0.r),
                ),
              ),
            ),
         ),

        if (showSuggestions && searchFocus.hasFocus)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                child: recommendedSubcategories.isEmpty
                    ? null
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: recommendedSubcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = recommendedSubcategories[index];
                    return ListTile(
                      title: Text(subcategory.name ?? ''),
                      onTap: () {
                        searchText.text = subcategory.name ?? '';
                        searchText.selection = TextSelection.fromPosition(
                          TextPosition(offset: searchText.text.length),
                        );
                        setState(() {
                          showSuggestions = false;
                        });
                        _navigateToSearch(subcategory.name!);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}