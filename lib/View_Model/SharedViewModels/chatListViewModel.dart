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
      //Listens for new incoming messages from a WebSocket or similar real-time source.
      if (state.hasValue) {
        final currentChats = state.value!;

        final updatedChats = currentChats.map((chat) {
          if (chat?.id == message.chatId) {
            chatFound = true;
            final updatedMessages = [...?chat?.messages, message]; //Appends the new message to chat.messages.
            return chat?.copyWith(
              messages: updatedMessages,
              lastMessageAt: message.createdAt,// Updates lastMessageAt and lastMessage with the incoming message's data.
              lastMessage: message,
            );
          }
          return chat;
        }).toList();

        updatedChats.sort((a, b) {
          if (a == null && b == null) return 0;  // no sorting if both chats with null msgs
          if (a == null) return 1;              // chat with null msgs sort to bottom
          if (b == null) return -1;             // chat with msgs sort to top
          return b.lastMessageAt.compareTo(a.lastMessageAt); // Newest first
        });

        state = AsyncValue.data(updatedChats);
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

  Future<Chat?> createChat(String buyerId, String productId) async {
    try {
      final data = {
        'buyerId': buyerId,
      };

      final newChat = await repository.createChat(productId, data);
      print('API response: ${newChat?.toJson()}');

      if (newChat != null) {
        if (state.hasValue) {
          final currentChats = state.value!;

          // Check if chat already exists
          final chatExists = currentChats.any((chat) =>
          chat?.buyerId == newChat.buyerId &&
              chat?.sellerId == newChat.sellerId &&
              chat?.productId == newChat.productId
          );

          if (!chatExists) {
            // Use state.update() instead of directly setting state
            Future.microtask(() {  //schedule state changes outside the build method
              state = AsyncValue.data([newChat, ...currentChats]);
            });
          }
        } else {
          Future.microtask(() {
            state = AsyncValue.data([newChat]);
          });
        }
        return newChat;
      }
    } catch (e) {
      print('Error creating chat: $e');
      rethrow;
    }
    return null;
  }
}


