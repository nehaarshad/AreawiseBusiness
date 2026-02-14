import 'dart:async';
import 'package:ecommercefrontend/models/notificationModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/messagesModel.dart';
import 'app_APIs.dart';
import 'notificationService.dart';


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
  final notificationController = StreamController<NotificationModel>.broadcast();
  final NotificationService _notificationService = NotificationService();

  Stream<Message> get messageStream => messageController.stream;
  Stream<NotificationModel> get notificationStream => notificationController.stream;

  bool _isInitialized = false;
  String? _currentUserId;

  Future<void> initialize({String? userId}) async {
    _currentUserId = userId;

    // Initialize notification service
    await _notificationService.initialize();

    // Setup socket
    socket = IO.io(
      AppApis.socketURL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _setupSocketListeners();
    socket.connect();
    _isInitialized = true;
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      print('🔌 Socket connected');
      if (_currentUserId != null) {
        registerUser(_currentUserId!);
      }
    });

    socket.onDisconnect((_) {
      print('🔌 Socket disconnected');
    });

    socket.onError((error) {
      print('❌ Socket error: $error');
    });

    socket.onConnectError((error) {
      print('❌ Connection error: $error');
    });

    // Listen for new messages
    socket.on('receiveMessage', _handleReceiveMessage);

    // Listen for new notifications
    socket.on('receiveNotification', _handleReceiveNotification);
  }

  void _handleReceiveMessage(dynamic data) {
    try {
      final message = Message.fromJson(data);
      messageController.add(message);

    } catch (e) {
      print('❌ Error handling message: $e');
    }
  }

  void _handleReceiveNotification(dynamic data) {
    try {
      final notification = NotificationModel.fromJson(data);
      notificationController.add(notification);

      // Show local notification with sound
      _notificationService.showNotification(notification);
    } catch (e) {
      print('❌ Error handling notification: $e');
    }
  }

  void registerUser(String userId) {
    _currentUserId = userId;
    print('👤 Registering user: $userId');
    socket.emit('registerUser', userId);
  }

  void joinSpecificChat(int chatId) {
    print('💬 Joining specific chat: $chatId');
    socket.emit('joinChat', chatId);
  }

  void joinChats(String userId) {
    print('💬 Joining chats for user: $userId');
    socket.emit('userChats', userId);
  }

  void sendMessage({
    required int chatId,
    required int senderId,
    required String message,
    required int receiverId
  }) {
    print('📤 Sending message to chat: $chatId');
    socket.emit('sendMessage', {
      'chatId': chatId,
      'senderId': senderId,
      'msg': message,
      'receiverId':receiverId
    });
  }

  void markMessagesAsRead({
    required int chatId,
    required int userId,
  }) {
    socket.emit('markAsRead', {
      'chatId': chatId,
      'userId': userId,
    });
  }

  void markNotificationAsRead({
    required int notificationId,
    required int userId,
  }) {
    print("mark as readd");
    socket.emit('markNotificationAsRead', {
      'id': notificationId,
      'userId': userId,
    });
  }

  void disconnect() {
    messageController.close();
    notificationController.close();
    _notificationService.dispose();
    socket.disconnect();
    _isInitialized = false;
  }
}
