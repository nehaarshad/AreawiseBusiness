import 'package:ecommercefrontend/models/hiveModels/providerDetailsHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/servicesHiveModel.dart';
import 'package:ecommercefrontend/models/serviceProviderModel.dart';
import 'package:ecommercefrontend/models/servicesModel.dart';
import '../hiveModels/serviceProvidersHiveModel.dart';
import '../serviceProviderDetails.dart';

class ServiceMapper{

  static ServicesHiveModel toHiveModel(Services service){
    return ServicesHiveModel(
        id: service.id,
        name: service.name,
        image:service.imageUrl,
        status: service.status,
        providers: service.providers !=null ? service.providers?.map((sub)=>ServiceProviderHiveModel(
            id: sub.id,
            providerName: sub.providerName,
          providerID: sub.providerID,
          contactnumber: sub.contactnumber,
          serviceId: sub.serviceId,
          email: sub.email,
          details: sub.serviceDetails !=null ? sub.serviceDetails?.map((d)=>ProviderDetailsHiveModel(
            id: d.id,
            serviceDetails: d.serviceDetails,
            providerId: d.providerId,
            cost: d.cost
          )).toList() : null,
          experience: sub.experience,
          ImageUrl: sub.ImageUrl,
          location: sub.location,
          OpenHours: sub.OpenHours


        )).toList() : null
    );

  }

  static Services fromHiveModel(ServicesHiveModel service){

    return Services(
        id: service.id,
        name: service.name,
        status: service.status,
        imageUrl: service.image,
        providers: service.providers !=null ? service.providers?.map((sub)=>ServiceProviders(
            id: sub.id,
            providerName: sub.providerName,
            contactnumber: sub.contactnumber,
             experience: sub.experience,
          email: sub.email,
          serviceId: sub.serviceId,
          ImageUrl: sub.ImageUrl,
          OpenHours: sub.OpenHours,
          location: sub.location,
          serviceDetails: sub.details !=null ?sub.details?.map((d)=>ProviderServiceDetails(
            id: d.id,
            serviceDetails: d.serviceDetails,
            cost: d.cost,
            providerId: d.providerId
          )).toList() : null
        )).toList() : null
    );

  }


}