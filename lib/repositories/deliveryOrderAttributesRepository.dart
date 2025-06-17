import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../core/services/app_APIs.dart';
import '../models/UserAddressModel.dart';
import '../models/deliveryOrderAttributes.dart';

final attributesProvider = Provider<AttributeRepositories>((ref) {
  return AttributeRepositories();
});

class AttributeRepositories {
  AttributeRepositories();

  baseapiservice apiservice = networkapiservice();

  Future<dynamic> updateAttributes(dynamic data) async {
    try {
      final body=jsonEncode(data);
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.UpdateApiWithJson(
        AppApis.updateOrderAttributesEndPoints,
        body,
        headers,
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<DeliveryOrderAttributes> getAttributes() async {
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getOrderAttributesEndPoints,
      );
      return DeliveryOrderAttributes.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}