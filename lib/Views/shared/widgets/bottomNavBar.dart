import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  AppBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey.shade400,
      selectedItemColor: Appcolors.baseColor,
      selectedFontSize: 12.h,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      ],
    );

  }
}
