class Address {
  int? id;
  String? sector;
  String? city;
  String? address;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
        this.sector,
        this.city,
        this.address,
        this.userId,
        this.createdAt,
        this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sector = json['sector'];
    city = json['city'];
    address = json['address'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sector'] = this.sector;
    data['city'] = this.city;
    data['address'] = this.address;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}