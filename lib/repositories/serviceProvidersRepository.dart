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
import '../models/serviceProviderModel.dart';

final serviceProvidersDetailsProvider = Provider<ServicesProvidersRepositories>((ref) {
  return ServicesProvidersRepositories(ref: ref);
});

class ServicesProvidersRepositories {
  Ref ref;
  ServicesProvidersRepositories({required this.ref});

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

  Future<ServiceProviders?> updateServiceProvider(String id,Map<String,dynamic> data,File? image) async {
    final isConnected = await networkChecker.isConnected();
    ServiceProviders? services ;
    if (isConnected) {

      try {
        dynamic response = await apiservice.SingleFileUpdateApiWithMultiport(
          AppApis.updateServiceProviderEndPoints.replaceFirst(':id', id),data,image, headers(),
        );

        services = ServiceProviders.fromJson(response);

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

  Future<ServiceProviders> addServiceProvider(String id,Map<String,dynamic> data, File? image,)async{
    try {

      dynamic response = await apiservice.SingleFileUploadApiWithMultiport(AppApis.addServiceProviderEndPoints.replaceFirst(':id', id), data,image, headers(),);
      return ServiceProviders.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future <void> deleteService(String id)async{
    try {

      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteServiceProviderbyidEndPoints.replaceFirst(':id', id), headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }


}
