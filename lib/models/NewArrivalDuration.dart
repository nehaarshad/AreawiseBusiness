class NewArrivalDuration {
  int? id;
  int? day;
  String? createdAt;
  String? updatedAt;

  NewArrivalDuration({this.id, this.day, this.createdAt, this.updatedAt});

  NewArrivalDuration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
