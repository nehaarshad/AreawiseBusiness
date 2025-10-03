import '../models/chatsModel.dart';

class ChatListState {
  final List<Chat> chats;
  final bool isLoading;
  final String? error;

  ChatListState({
    required this.chats,
    this.isLoading = false,
    this.error,
  });

  ChatListState copyWith({
    List<Chat>? chats,
    bool? isLoading,
    String? error,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}