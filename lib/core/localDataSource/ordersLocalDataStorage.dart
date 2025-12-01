import 'package:ecommercefrontend/models/featureModel.dart';
import 'package:ecommercefrontend/models/hiveModels/featureHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/orderHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/orderRequestHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/orderMapper.dart';
import 'package:ecommercefrontend/models/orderModel.dart';
import 'package:ecommercefrontend/models/ordersRequestModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/ProductModel.dart';
import '../../models/hiveModels/productHiveModel.dart';
import '../../models/mappers/featureProductMapper.dart';
import '../../models/mappers/orderRequestMapper.dart';
import '../../models/mappers/productMapper.dart';

final ordersLocalDataSourceProvider = Provider<OrderLocalDataSource>((ref) {

  final dataSource = OrderLocalDataSource();
  dataSource.init();
  return dataSource;
});

class OrderLocalDataSource {
  static const String sellerOrdersBox = 'all_seller_order_cache';
  static const String customerOrdersBox = 'all_customer_order_cache';

  late Box<OrderRequestHiveModel> _orderRequestBox;
  late Box<OrderHiveModel> _ordersHistoryBox;


  Future<void> init() async {
    _orderRequestBox = await Hive.openBox<OrderRequestHiveModel>(sellerOrdersBox);
    _ordersHistoryBox = await Hive.openBox<OrderHiveModel>(customerOrdersBox);
  }


  Future<void> cacheAllSellerOrdersRequests(List<OrdersRequestModel> orderRequests) async {
    // Clear old cache
    await _orderRequestBox.clear();

    // Save all products
    for (var orders in orderRequests) {
      if (orders.id != null) {
        ///convert to hive model for storage
        final hiveModel = OrderRequestMapper.toHiveModel(orders);
        await _orderRequestBox.put(orders.id, hiveModel);  // Use product ID as key
      }
    }
  }

  Future<void> cacheAllCustomerOrdersHistory(List<orderModel> orders) async {
    // Clear old cache
    await _ordersHistoryBox.clear();

    // Save all products
    for (var order in orders) {
      if (order.id != null) {
        ///convert to hive model for storage
        final hiveModel = OrderMapper.toHiveModel(order);
        await _ordersHistoryBox.put(order.id, hiveModel);  // Use product ID as key
      }
    }
  }

  List<OrdersRequestModel> getSellerOrdersRequests() {
    return _orderRequestBox.values
        .map((hive) => OrderRequestMapper.fromHiveModel(hive))
        .toList();
  }

  List<orderModel> getCustomerOrdersHistory() {
    return _ordersHistoryBox.values
        .map((hive) => OrderMapper.fromHiveModel(hive))
        .toList();
  }


  bool hasSellerOrderCachedData() {
    return _orderRequestBox.isNotEmpty;
  }

  bool hasOrderHistoryCachedData() {
    return _ordersHistoryBox.isNotEmpty;
  }
}