import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/app_APIs.dart';
import '../models/adsModel.dart';

final reminderProvider = Provider<reminderRepositories>((ref) {
  return reminderRepositories(ref: ref);
});

class reminderRepositories {
  Ref ref;
  reminderRepositories({required this.ref});
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  baseapiservice apiservice = networkapiservice();

  Future<Map<String, dynamic>> setReminder(Map<String, dynamic> data, String id) async {
    try {
      final body=jsonEncode(data);
      dynamic response = await apiservice.PostApiWithJson(AppApis.setOrderReminderEndPoints.replaceFirst(':id', id), body, headers(),);
      print("set reminder response $response");

      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteReminder(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteOrderReminderEndPoints.replaceFirst(':id', id), headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
