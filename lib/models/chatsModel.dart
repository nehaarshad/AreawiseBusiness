import 'ProductModel.dart';
import 'messagesModel.dart';

class Chat {
  final String id;
  final String buyerId;
  final String sellerId;
  final String productId;
  final DateTime lastMessageAt;
  final List<Message?> messages;
  final Message? lastMessage;
  final ProductModel? product;

  Chat({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.productId,
    required this.lastMessageAt,
    required this.messages,
    this.lastMessage,
    required this.product,
  });

  Chat copyWith({
    String? id,
     String? buyerId,
     String? sellerId,
     String? productId,
     DateTime? lastMessageAt,
     List<Message?>? messages,
     Message? lastMessage,
     ProductModel? product,
  }) {
    return Chat(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      productId: productId ?? this.productId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messages: messages ?? this.messages,
      lastMessage: lastMessage ?? this.lastMessage,
      product: product ?? this.product,
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id']!.toString(),
      buyerId: json['buyerId']!.toString(),
      sellerId: json['sellerId']!.toString(),
      productId: json['productId']!.toString(),
      lastMessageAt: DateTime.parse(json['lastMessageAt']),
      messages: json['Messages'] != null
          ? (json['Messages'] as List)
          .map((message) => Message.fromJson(message))
          .toList()
          : [], // Provide an empty list as default
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'productId': productId,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'messages': messages.map((message) => message?.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
    };
  }
}
