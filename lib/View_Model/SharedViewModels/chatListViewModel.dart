import 'package:ecommercefrontend/repositories/chatRepositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chatsModel.dart';

final chatListProvider = StateNotifierProvider<ChatListViewModel, AsyncValue<List<Chat?>>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatListViewModel(repository, ref);
});

class ChatListViewModel extends StateNotifier<AsyncValue<List<Chat?>>> {
  final ChatRepository repository;
  final Ref ref;

  ChatListViewModel(this.repository, this.ref) : super(const AsyncValue.loading()) {
    _setupSocketListeners();
  }

  bool chatFound = false;

  void _setupSocketListeners() {
    repository.messageStream.listen((message) {
      if (state.hasValue) {
        final currentChats = List<Chat?>.from(state.value!);

        // Check if the chat exists
        bool chatUpdated = false;
        final updatedChats = currentChats.map((chat) {
          if (chat?.id == message.chatId) {
            chatFound = true;
            chatUpdated = true;
            final updatedMessages = [...?chat?.messages, message];
            return chat?.copyWith(
              messages: updatedMessages,
              lastMessageAt: message.createdAt.toString(),
            );
          }
          return chat;
        }).toList();

        // Only update state if a chat was actually modified
        if (chatUpdated) {
          // Sort chats by last message time
          updatedChats.sort((a, b) {
            if (a == null && b == null) return 0;
            if (a == null) return 1;
            if (b == null) return -1;

            final aDate = a.lastMessageAt != null ?
            DateTime.parse(a.lastMessageAt!) : DateTime(1970);
            final bDate = b.lastMessageAt != null ?
            DateTime.parse(b.lastMessageAt!) : DateTime(1970);

            return bDate.compareTo(aDate); // Newest first
          });

          state = AsyncValue.data(updatedChats);
        }
      }
    });
  }

  Future<void> fetchChatsAsSeller(String id) async {
    state = const AsyncValue.loading();
    try {
      final chats = await repository.getChatsAsSeller(id);
      state = AsyncValue.data(chats);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> fetchChatsAsBuyer(String id) async {
    state = const AsyncValue.loading();
    try {
      final chats = await repository.getChatsAsBuyer(id);
      state = AsyncValue.data(chats);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteChats(String id) async {
    try {
      //  remove the chat from the list
      if (state.hasValue) {
        final currentChats = List<Chat?>.from(state.value!);
        final updatedChats = currentChats.where((chat) => chat?.id.toString() != id).toList();
        state = AsyncValue.data(updatedChats);
      }

      await repository.deleteChat(id);

    } catch (e) {
      // If there's an error, revert to the previous state
      state = AsyncValue.error(e, StackTrace.current);
      throw e;
    }
  }

  Future<Chat?> createChat(String buyerId, String productId) async {
    try {
      final data = {
        'buyerId': buyerId,
      };

      final newChat = await repository.createChat(productId, data);
      print('API response: ${newChat?.toJson()}');

      if (newChat != null) {
        if (state.hasValue) {
          final currentChats = List<Chat?>.from(state.value!);

          // Check if chat already exists
          final existingChatIndex = currentChats.indexWhere((chat) =>
          chat?.buyerId.toString() == buyerId &&
              chat?.productId.toString() == productId);

          if (existingChatIndex >= 0) {
            // Chat already exists, return the existing chat
            return currentChats[existingChatIndex];
          } else {
            // Add the new chat to the list
            final updatedChats = [newChat, ...currentChats];

            // Sort by last message time
            updatedChats.sort((a, b) {
              if (a == null && b == null) return 0;
              if (a == null) return 1;
              if (b == null) return -1;

              final aDate = a.lastMessageAt != null ?
              DateTime.parse(a.lastMessageAt!) : DateTime(1970);
              final bDate = b.lastMessageAt != null ?
              DateTime.parse(b.lastMessageAt!) : DateTime(1970);

              return bDate.compareTo(aDate); // Newest first
            });

            state = AsyncValue.data(updatedChats);
            return newChat;
          }
        } else {
          // No existing chats, set state with just the new chat
          state = AsyncValue.data([newChat]);
          return newChat;
        }
      }
    } catch (e) {
      print('Error creating chat: $e');
      rethrow;
    }
    return null;
  }
}
