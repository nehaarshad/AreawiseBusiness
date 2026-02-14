
import 'dart:io';
import 'package:ecommercefrontend/models/serviceProviderDetails.dart';

class ServiceProviders {
  int? id;
  String? providerName;
  String? createdAt;
  String? updatedAt;
  String? ImageUrl;
  File? image;
  String? email;
  int? providerID;
  dynamic contactnumber;
  String? experience;
  String? OpenHours;
  String? location;
  int? serviceId;
  List<ProviderServiceDetails>? serviceDetails;

  ServiceProviders({this.id,this.location, this.providerName,this.ImageUrl, this.createdAt,this.image, this.updatedAt,this.email,this.providerID,this.contactnumber,this.experience,this.serviceId,this.OpenHours,this.serviceDetails });

  ServiceProviders copywith({
    String? providerName,
    String? ImageUrl,
    File? image,
    String? email,
    String? location,
    int? providerID,
    dynamic? contactnumber,
    String? experience,
    String? OpenHours,
    int? serviceId,
    List<ProviderServiceDetails>? serviceDetails,
  })
  {
    return ServiceProviders(
        providerName: providerName ?? this.providerName,
        ImageUrl:ImageUrl ?? this.ImageUrl,
        image: image ?? this.image,
        email: email ?? this.email,
      location: location ??  this.location,
      providerID: providerID ?? this.providerID,
      contactnumber: contactnumber ?? this.contactnumber,
      experience: experience ?? this.experience,
      OpenHours: OpenHours ?? this.OpenHours,
      serviceId: serviceId ?? this.serviceId,
      serviceDetails: serviceDetails ?? this.serviceDetails,
    );
  }
  ServiceProviders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerName = json['providerName'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    providerID = json['providerID'];
    contactnumber = json['contactnumber'];
    experience = json['experience'];
    OpenHours = json['OpenHours'];
    location =json['location'];
    ImageUrl = json['ImageUrl'];
    if (json['ServiceDetails'] != null) {
      serviceDetails = <ProviderServiceDetails>[];
      json['ServiceDetails'].forEach((v) {
        serviceDetails!.add(new ProviderServiceDetails.fromJson(v));
      });
    }
  }

}
