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
    if (_isLoaded) return;

    try {
      final messages = await repository.getChatMessages(chatId);
      print(messages);
      state = AsyncValue.data(messages);
      _isLoaded = true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void sendMessage(String senderId,String receiverId, String text) {

    if (state.hasValue) {
      state = AsyncValue.data(state.value!);
    }

    // Parse the IDs safely with null checks
    final chatIdInt = int.tryParse(chatId);
    final senderIdInt = int.tryParse(senderId);
    final receiverIdInt = int.tryParse(receiverId);

    if (chatIdInt != null && senderIdInt != null && receiverId !=null) {
      // Send via repository
      repository.sendMessage(
        chatId: chatIdInt,
        senderId: senderIdInt,
        message: text,
        receiverId:receiverIdInt!,
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