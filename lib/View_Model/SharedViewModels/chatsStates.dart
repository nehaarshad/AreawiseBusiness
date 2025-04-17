// Single chat state (for active conversation)
import '../../models/chatsModel.dart';
import '../../models/messagesModel.dart';

class ChatState {
  final Chat? chat;
  final List<Message> messages;
  final bool isLoading;
  final String? error;
  final bool isTyping;
  final int? typingUserId;

  ChatState({
    this.chat,
    required this.messages,
    this.isLoading = false,
    this.error,
    this.isTyping = false,
    this.typingUserId,
  });

  ChatState copyWith({
    Chat? chat,
    List<Message>? messages,
    bool? isLoading,
    String? error,
    bool? isTyping,
    int? typingUserId,
  }) {
    return ChatState(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isTyping: isTyping ?? this.isTyping,
      typingUserId: typingUserId ?? this.typingUserId,
    );
  }
}
