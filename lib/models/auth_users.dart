class UserModel {
  int? id;
  String? username;
  String? email;
  int? contactnumber;
  String? role;
  String? token;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.contactnumber,
    this.role,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    contactnumber = json['contactnumber'];
    role = json['role'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['contactnumber'] = this.contactnumber;
    data['role'] = this.role;
    data['token'] = this.token;
    return data;
  }
}
