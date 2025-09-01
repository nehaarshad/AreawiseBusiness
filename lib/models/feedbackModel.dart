class feedbackModel {
  int? id;
  String? email;
  String? comment;

  feedbackModel({
    this.id,
    this.email,
    this.comment,
  });

  feedbackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['comment'] = this.comment;
    return data;
  }
}
