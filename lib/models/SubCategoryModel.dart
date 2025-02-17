class Subcategory {
  int? id;
  String? name;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  Subcategory({
    this.id,
    this.name,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['categoryId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['categoryId'] = this.categoryId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
