import 'dart:io';

import 'package:ecommercefrontend/models/servicesModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/serviceProviderModel.dart';

//Multiple state management at a time in riverpod done by using CopyWith Method
class ServiceProviderState {
  final AsyncValue<ServiceProviders?> serviceProvider;
  final File? image;
  final List<Services> services;
  final Services? selectedService;
  final bool isCustomService;
  final bool isLoading;
  final String? selectedArea;
  final String? customServiceName;
  final bool isCustomArea;

  ServiceProviderState({
    this.serviceProvider = const AsyncValue.data(null),
    this.image = null,
    this.services = const [],
    this.selectedService,
    this.isCustomService = false,
    this.isLoading = false,
    this.customServiceName,
    this.isCustomArea=false,
    this.selectedArea,
  });

  ServiceProviderState copyWith({
    AsyncValue<ServiceProviders?>? serviceProvider,
    File? image,
    List<Services>? services,
    Services? selectedService,
    bool? isCustomService,
    String? customServiceName,
    bool? isLoading,
    bool? isCustomArea,
    String? selectedArea
  }) {
    return ServiceProviderState(
        serviceProvider: serviceProvider ?? this.serviceProvider,
        image: image ?? this.image,
        services: services ?? this.services,
        selectedService: selectedService ?? this.selectedService,
        isCustomService: isCustomService ?? this.isCustomService,
        isLoading: isLoading ?? this.isLoading,
        customServiceName: customServiceName ?? this.customServiceName,
        isCustomArea: isCustomArea ?? this.isCustomArea,
        selectedArea: selectedArea ?? this.selectedArea
    );
  }
}
