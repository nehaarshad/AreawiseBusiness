import 'dart:io';
import 'package:ecommercefrontend/models/serviceProviderModel.dart';

class Services {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  File? image;
  String? status;
  List<ServiceProviders>? providers;

  Services({this.id,this.providers , this.name,this.image, this.createdAt,this.status, this.updatedAt,this.imageUrl});

  Services copywith({
  String? name,
    File? image,
  String? imageUrl,
  String? status,
    List<ServiceProviders>? providers
  })
  {
    return Services(
      providers: providers ?? this.providers,
     name: name ?? this.name,image:image??this.image,status: status??this.status,imageUrl: imageUrl??this.imageUrl
    );
  }
  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    imageUrl = json['imageUrl'];
    if (json['ServiceProviders'] != null) {
      providers = <ServiceProviders>[];
      json['ServiceProviders'].forEach((v) {
        providers!.add(new ServiceProviders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['imageUrl'] = this.imageUrl;

    return data;
  }
}

class ServiceWithProvider {
  final String? serviceName;
  final ServiceProviders provider;

  ServiceWithProvider({this.serviceName, required this.provider});
}
