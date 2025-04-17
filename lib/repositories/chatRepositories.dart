import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/services/app_APIs.dart';
import '../core/services/socketService.dart';
import '../models/chatsModel.dart';
import '../models/messagesModel.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return ChatRepository(socketService);
});

class ChatRepository {
  final SocketService socketService;
  final baseapiservice apiservice = networkapiservice();

  ChatRepository(this.socketService);

  // Expose message stream from socket
  Stream<Message> get messageStream => socketService.messageStream;

  // Socket methods
  void joinChats(String userId) {
    socketService.joinChats(userId);
  }

  void sendMessage({
    required int chatId,
    required int senderId,
    required String message,
  })
  {
    socketService.sendMessage(
      chatId: chatId,
      senderId: senderId,
      message: message,
    );
  }

  void disconnect() {
    socketService.disconnect();
  }

  // API methods
  Future<List<Chat>> getChatsAsBuyer(String id) async {
    List<Chat> chats;
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getChatsAsBuyerEndPoints.replaceFirst(':id', id),
      );

      if (response is List) {
        return response.map((chats) => Chat.fromJson(chats as Map<String, dynamic>)).toList();
      }
      chats = [Chat.fromJson(response)];

      return chats;
    } catch (e) {
      print('Error in getChatsAsBuyer: $e');
      throw e;
    }
  }

  Future<List<Chat>> getChatsAsSeller(String id) async {
    List<Chat> chats;
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getChatsAsSellerEndPoints.replaceFirst(':id', id),
      );

      if (response is List) {
        return response
            .map((chats) => Chat.fromJson(chats as Map<String, dynamic>))
            .toList();
      }
      chats = [Chat.fromJson(response)];

      return chats;
    } catch (e) {
      print('Error in getChatsAsSeller: $e');
      throw e;
    }
  }

  Future<List<Message>> getChatMessages(String chatId) async {
    List<Message> msgs;
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getChatMessagesEndPoints.replaceFirst(':id', chatId),
      );

      if (response is List) {
        return response
            .map((msg) => Message.fromJson(msg as Map<String, dynamic>))
            .toList();
      }
      msgs = [Message.fromJson(response)];

      return msgs;
    } catch (e) {
      print('Error in getChatMessages: $e');
      throw e;
    }
  }

  Future<Chat?> createChat(String productId, Map<String, dynamic> data) async {
    final headers = {'Content-Type': 'application/json'};
    final jsonData = jsonEncode(data);
    try {
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.createChatEndPoints.replaceFirst(':id', productId),
        jsonData,
        headers,
      );

      if (response != null) {
        return Chat.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error in createChat: $e');
      throw e;
    }
  }
}
