import 'dart:io';
import 'package:ecommercefrontend/models/servicesModel.dart';

import '../models/categoryModel.dart';

//Multiple state management at a time in riverpod done by using CopyWith Method
class ServicedState {
  final List<Services?>? services;
  final File? image;
  final bool isLoading;

  ServicedState({
    this.services = null,
    this.image = null,
    this.isLoading = false,
  });

  ServicedState copyWith({
    List<Services?>? services,
    File? image,
    bool? isLoading,
  }) {
    return ServicedState(
      services: services ?? this.services,
      image: image ?? this.image,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
