import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/messagesModel.dart';
import 'app_APIs.dart';


final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  service.initialize();

  ref.onDispose(() {
    service.disconnect();
  });

  return service;
});

class SocketService {
  late IO.Socket socket;
  final messageController = StreamController<Message>.broadcast();

  Stream<Message> get messageStream => messageController.stream;

  Future<void> initialize() async {
    socket = IO.io(AppApis.socketURL,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build()
    );

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });

    socket.onConnectError((error) {
      print('Connection error: $error');
    });

    // Listen for new messages
    socket.on('receiveMessage', (data) {
      final message = Message.fromJson(data);
      messageController.add(message);
    });

    // Connect to socket
    socket.connect();
  }

  void joinChats(String userId) {
    print('Joining chats for user: $userId (${userId.runtimeType})');
    socket.emit('userChats', userId);
  }

  void sendMessage({
    required int chatId,
    required int senderId,
    required String message,
  }) {
    print('Sending message to chat: $chatId (${chatId.runtimeType}), Sender: $senderId');
    socket.emit('sendMessage', {
      'chatId': chatId,
      'senderId': senderId,
      'msg': message,
    });
  }

  void disconnect() {
    // Ensure cleanup and safe shutdown
    messageController.close();
    socket.disconnect();
  }
}