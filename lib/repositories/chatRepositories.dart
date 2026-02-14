import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/services/app_APIs.dart';
import '../core/services/socketService.dart';
import '../models/chatsModel.dart';
import '../models/messagesModel.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return ChatRepository(socketService,ref);
});

class ChatRepository {
  final SocketService socketService;
  Ref ref;
  final baseapiservice apiservice = networkapiservice();

  ChatRepository(this.socketService,this.ref);
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

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
    required int receiverId
  })
  {
    socketService.sendMessage(
      chatId: chatId,
      senderId: senderId,
      message: message,
        receiverId: receiverId
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
        AppApis.getChatsAsBuyerEndPoints.replaceFirst(':id', id),headers()
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

  Future<dynamic> deleteChat(String id) async {
    try {

      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteChatEndPoints.replaceFirst(':id', id),headers());
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Chat>> getChatsAsSeller(String id) async {
    List<Chat> chats;
    try {

      dynamic response = await apiservice.GetApiResponce(
        AppApis.getChatsAsSellerEndPoints.replaceFirst(':id', id),headers()
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
      socketService.joinSpecificChat(int.tryParse(chatId)!);
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getChatMessagesEndPoints.replaceFirst(':id', chatId),headers()
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

    final jsonData = jsonEncode(data);
    try {
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.createChatEndPoints.replaceFirst(':id', productId),
        jsonData,
        headers(),
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
