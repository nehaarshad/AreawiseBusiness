
class ProviderServiceDetails {
  int? id;
  String? serviceDetails;
  String? createdAt;
  String? updatedAt;
  int? cost;
  int? providerId;

  ProviderServiceDetails({this.id, this.serviceDetails,this.cost, this.createdAt, this.updatedAt,this.providerId,});

  ProviderServiceDetails copywith({
    String? serviceDetails,
    int? cost,
    String? imageUrl,
    String? status,})
  {
    return ProviderServiceDetails(
        serviceDetails: serviceDetails ?? this.serviceDetails,
        cost:cost??this.cost,
    );
  }

  ProviderServiceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceDetails = json['serviceDetails'];
    cost = json['cost'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    providerId = json['providerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['providerId'] = this.providerId;
    data['createdAt'] = this.createdAt;
    data['cost'] = this.cost;
    data['updatedAt'] = this.updatedAt;
    data['serviceDetails'] = this.serviceDetails;

    return data;
  }
}
