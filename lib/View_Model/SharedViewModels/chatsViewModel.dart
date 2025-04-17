import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/messagesModel.dart';
import '../../repositories/chatRepositories.dart';

final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesViewModel, AsyncValue<List<Message?>>, String>(
        (ref, chatId) {
      final repository = ref.watch(chatRepositoryProvider);
      return ChatMessagesViewModel(chatId, repository);
    }
);

class ChatMessagesViewModel extends StateNotifier<AsyncValue<List<Message>>> {
  final String chatId;
  final ChatRepository repository;

  ChatMessagesViewModel(this.chatId, this.repository) : super(const AsyncValue.loading()) {
    _setupSocketListeners();
    loadMessages();
  }

  void _setupSocketListeners() {
    repository.messageStream.listen((message) {
      if (message.chatId == chatId && state.hasValue) {
        final currentMessages = state.value!;

        // Check if message already exists to avoid duplicates
        if (!currentMessages.any((m) => m.id == message.id)) {
          final updatedMessages = [...currentMessages, message];
          state = AsyncValue.data(updatedMessages);
        }
      }
    });
  }

  Future<void> loadMessages() async {
    try {
      final messages = await repository.getChatMessages(chatId);
      state = AsyncValue.data(messages);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void sendMessage(String senderId, String text) {
    // Optimistic update with temp message
    final tempMessage = Message(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: senderId,
      text: text,
      createdAt: DateTime.now(),
      isRead: false,
    );

    if (state.hasValue) {
      state = AsyncValue.data([...state.value!, tempMessage]);
    }

    final chatIdInt = int.tryParse(chatId);
    final senderIdInt = int.tryParse(senderId);
    // Send via repository
    repository.sendMessage(
      chatId: chatIdInt!,
      senderId: senderIdInt!,
      message: text,
    );
  }
}