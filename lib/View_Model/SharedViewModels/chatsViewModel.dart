import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/messagesModel.dart';
import '../../repositories/chatRepositories.dart';

final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesViewModel, AsyncValue<List<Message>>, String>(
        (ref, chatId) {
      final repository = ref.watch(chatRepositoryProvider);
      return ChatMessagesViewModel(chatId, repository);
    }
);

class ChatMessagesViewModel extends StateNotifier<AsyncValue<List<Message>>> {
  final String chatId;
  final ChatRepository repository;
  bool _isLoaded = false;

  ChatMessagesViewModel(this.chatId, this.repository) : super(const AsyncValue.loading()) {
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    repository.messageStream.listen((message) {
      if (message.chatId.toString() == chatId && state.hasValue) {
        final currentMessages = List<Message>.from(state.value!);

        // Check if message already exists to avoid duplicates
        if (!currentMessages.any((m) => m.id == message.id)) {
          final updatedMessages = [...currentMessages, message];
          state = AsyncValue.data(updatedMessages);
        }
      }
    });
  }

  Future<void> loadMessages() async {
    // Only load messages once to prevent duplicate loading
    if (_isLoaded) return;

    try {
      final messages = await repository.getChatMessages(chatId);
      state = AsyncValue.data(messages);
      _isLoaded = true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void sendMessage(String senderId, String text) {
    // Optimistic update with temp message
    final tempMessage = Message(
      chatId: int.tryParse(chatId),
      senderId: int.tryParse(senderId),
      msg: text,
      createdAt: DateTime.now().toString(),
      status: false,
    );

    if (state.hasValue) {
      state = AsyncValue.data(state.value!);
    }

    // Parse the IDs safely with null checks
    final chatIdInt = int.tryParse(chatId);
    final senderIdInt = int.tryParse(senderId);

    if (chatIdInt != null && senderIdInt != null) {
      // Send via repository
      repository.sendMessage(
        chatId: chatIdInt,
        senderId: senderIdInt,
        message: text,
      );
    } else {
      // Handle error - invalid IDs
      state = AsyncValue.error(
          'Invalid chat or sender ID',
          StackTrace.current
      );
    }
  }
}