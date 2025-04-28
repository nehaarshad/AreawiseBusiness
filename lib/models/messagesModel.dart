
class Message {
  int? id;
  int? chatId;
  int? senderId;
  String? msg;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Message(
      {this.id,
        this.chatId,
        this.senderId,
        this.msg,
        this.status,
        this.createdAt,
        this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chatId'];
    senderId = json['senderId'];
    msg = json['msg'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chatId'] = this.chatId;
    data['senderId'] = this.senderId;
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}