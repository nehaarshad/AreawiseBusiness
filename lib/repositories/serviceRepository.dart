import 'dart:convert';
import 'dart:io';

import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/servicesModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/localDataSource/categoryLocalSource.dart';
import '../core/localDataSource/servicesLocalDataSource.dart';
import '../core/network/appexception.dart';
import '../core/network/networkChecker.dart';
import '../core/services/app_APIs.dart';
import '../models/SubCategoryModel.dart';

final serviceProvider = Provider<ServicesRepositories>((ref) {
  return ServicesRepositories(ref: ref);
});

class ServicesRepositories {
  Ref ref;
  ServicesRepositories({required this.ref});

  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  baseapiservice apiservice = networkapiservice();

  serviceLocalDataSource get localDataSource => ref.read(serviceLocalDataSourceProvider);

  NetworkChecker get networkChecker => ref.read(networkCheckerProvider);

  Future<List<Services>> fetchAndCacheAllServices() async {

    if (localDataSource.hasCachedData()) {
      return localDataSource.getAllServices();
    }
    return [];

  }

  Future<List<Services>> getServices() async {
    final isConnected = await networkChecker.isConnected();
     List<Services> services = [];
    if (isConnected) {

      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.getallservicesEndPoints, headers(),
        );

       services = (response as List)
            .map((service) => Services.fromJson(service as Map<String, dynamic>))
            .toList();

       print(services);
        await localDataSource.cacheAllServices(services);
        return services;
      } catch (e) {
        print(e);
        return localDataSource.getAllServices();

      }
    }
    else{
      return localDataSource.getAllServices();
    }

  }

  Future<Services?> findService(String id) async {
    final isConnected = await networkChecker.isConnected();
    Services? services ;
    if (isConnected) {

      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.getServiceByIdEndPoints.replaceFirst(':id', id), headers(),
        );

        services = Services.fromJson(response);

        print(services);

        return services;
      } catch (e) {
        print(e);

        return localDataSource.findService(int.tryParse(id)!);

      }
    }
    else{
      return localDataSource.findService(int.tryParse(id)!);
    }

  }

  Future<Services?> updateService(String id,Map<String,dynamic> data,File? image) async {
    final isConnected = await networkChecker.isConnected();
    Services? services ;
    if (isConnected) {

      try {
        dynamic response = await apiservice.SingleFileUpdateApiWithMultiport(
          AppApis.updateServiceEndPoints.replaceFirst(':id', id),data,image, headers(),
        );

        services = Services.fromJson(response);

        print(services);
        //  await localDataSource.cacheAllCategories(services);
        return services;
      } catch (e) {
        print(e);
        return services;
        //return localDataSource.getAllCategories();

      }
    }
    else{
      return services;
    }

  }

  Future<Services?> updateServiceStatus(String id,Map<String,dynamic> data) async {
    final isConnected = await networkChecker.isConnected();
    Services? services ;
    if (isConnected) {

      try {
        dynamic response = await apiservice.UpdateApiWithJson(
          AppApis.updateServiceEndPoints.replaceFirst(':id', id),data, headers(),
        );

        services = Services.fromJson(response);

        print(services);
        //  await localDataSource.cacheAllCategories(services);
        return services;
      } catch (e) {
        print(e);
        return services;
        //return localDataSource.getAllCategories();

      }
    }
    else{
      return services;
    }

  }


  Future<Services> addService(Map<String,String> data, File? image,)async{
    try {

      dynamic response = await apiservice.SingleFileUploadApiWithMultiport(AppApis.addServiceEndPoints, data,image, headers(),);
      return Services.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future <void> deleteService(String id)async{
    try {

      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteServicebyidEndPoints.replaceFirst(':id', id), headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }


}
