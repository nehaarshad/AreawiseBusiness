import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/services/app_APIs.dart';
import '../models/UserAddressModel.dart';
import '../models/deliveryOrderAttributes.dart';

final attributesProvider = Provider<AttributeRepositories>((ref) {
  return AttributeRepositories(ref);
});

class AttributeRepositories {

  Ref ref;

  AttributeRepositories(this.ref);

  baseapiservice apiservice = networkapiservice();
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<dynamic> updateAttributes(dynamic data) async {
    try {
      final body=jsonEncode(data);

      dynamic response = await apiservice.UpdateApiWithJson(
        AppApis.updateOrderAttributesEndPoints,
        body,
        headers(),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<DeliveryOrderAttributes> getAttributes() async {
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getOrderAttributesEndPoints,headers()
      );
      return DeliveryOrderAttributes.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}