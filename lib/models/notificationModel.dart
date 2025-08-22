
class NotificationModel {
  int? id;
  String? message;
  int? userId;
  bool? read;
  String? createdAt;
  String? updatedAt;

  NotificationModel({
    this.id,
    this.message,
    this.userId,
    this.read,
    this.createdAt,
    this.updatedAt
  });

  NotificationModel copyWith({
    int? id,
    int? userId,
    String? message,
    bool? read,
    String? createdAt,
    String? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    userId = json['userId'];
    read = json['read'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['userId'] = this.userId;
    data['read'] = this.read;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
