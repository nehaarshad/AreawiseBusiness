import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SharedViewModels/chatListViewModel.dart';
import '../../../models/chatsModel.dart';
import 'chatView.dart';

class ChatsListView extends ConsumerStatefulWidget {
  final String userId;
  final bool isSeller;

  ChatsListView({
    Key? key,
    required this.userId,
    this.isSeller = false,
  }) : super(key: key);

  @override
  ConsumerState<ChatsListView> createState() => _ChatsListViewState();
}

class _ChatsListViewState extends ConsumerState<ChatsListView> {
  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    if (widget.isSeller) {
      ref.read(chatListProvider.notifier).fetchChatsAsSeller(widget.userId);
    } else {
      ref.read(chatListProvider.notifier).fetchChatsAsBuyer(widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatsList = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: chatsList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (chats) => chats.isEmpty
            ? const Center(child: Text('No chats yet'))
            : ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return chatTile(context, chat!);
          },
        ),
      ),
    );
  }

  Widget chatTile(BuildContext context, Chat chat) {
   // final isBuyer = chat.buyerId == widget.userId;

    return ListTile(
      leading: chat.product?.images?.first.imageUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          chat.product!.images!.first.imageUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
        ),
      )
          : Container(
        width: 50,
        height: 50,
        color: Colors.grey[300],
        child: const Icon(Icons.shopping_bag),
      ),
      title: Text(chat.product?.name ?? 'error'),
      subtitle: chat.lastMessage != null ? Text(
        chat.lastMessage!.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ) : const Text('No messages yet'),
      trailing: chat.lastMessage != null ? Text(
        _formatTime(chat.lastMessage!.createdAt),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatView(
              chatId: chat.id,
              userId: widget.userId,
              product:chat.product
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
