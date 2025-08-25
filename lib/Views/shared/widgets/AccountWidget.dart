import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> accountWidgets = [
  {
    'title': 'My Shops',
    'icon': Icons.store,
    'route': routesName.sShop,
  },
  {
    'title': 'My Products',
    'icon': Icons.shopping_bag,
    'route': routesName.sProducts,
  },
  {
    'title': 'My Payment Account',
    'icon': Icons.account_balance_wallet,
    'route':routesName.sellerAccounts,
  },
  {
    'title': 'Order Requests',
    'icon': Icons.receipt_long,
    'route':routesName.OrderRequests,
  },
  {
    'title': 'On Sale Products',
    'icon': Icons.local_offer,
    'route':  routesName.onSale,
  },
  {
    'title': 'Featured Products',
    'icon': Icons.star,
    'route': routesName.featuredProducts,
  },
];
