//users(all,seller,buyer),products(all,categories),shops(all,categories),feedbacks,profile

import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class adminBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  adminBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
      unselectedItemColor: Colors.black54,
        selectedItemColor: Appcolors.baseColor,
        selectedFontSize: 12.h,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shops'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Featured'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
    ]);

  }
}

