import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SharedViewModels/chatListViewModel.dart';
import '../../../models/chatsModel.dart';
import 'chatView.dart';

class ChatsListView extends ConsumerStatefulWidget {
  final String userId;
  late bool isSeller;

  ChatsListView({
    Key? key,
    required this.userId,
    this.isSeller=false
  }) : super(key: key);

  @override
  ConsumerState<ChatsListView> createState() => _ChatsListViewState();
}

class _ChatsListViewState extends ConsumerState<ChatsListView> {


  @override
  void initState() {
    super.initState();
    // Delay the provider update until after the build
    Future.microtask(() => _loadChats());
  }

  void _loadChats() {
    if (widget.isSeller) {
      ref.read(chatListProvider.notifier).fetchChatsAsSeller(widget.userId);
    } else {
      ref.read(chatListProvider.notifier).fetchChatsAsBuyer(widget.userId);
    }
  }

  void toggleButton(bool isSeller) {
    setState(() {
      widget.isSeller = isSeller;
    });
    _loadChats();
  }

  @override
  Widget build(BuildContext context) {
    final chatsList = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: Column(
        children: [
          topBarButtons(),
          SizedBox(height: 10,),
          Expanded(child:
          chatsList.when(
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
          ),)
        ],
      )
    );
  }

  Widget topBarButtons() {
    return Row(

        children: [
          InkWell(
            onTap: () => toggleButton(false),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 20),
               padding: const EdgeInsets.symmetric(vertical: 12.0),
               decoration: BoxDecoration(
               color: !widget.isSeller ? Appcolors.blueColor : Appcolors.blackColor,
               borderRadius: BorderRadius.circular(10),
                  ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.40,
              ),
              child: Center(
                  child: Text('As Buyer',style: TextStyle(
                    color: Appcolors.whiteColor,
                    fontWeight: !widget.isSeller ? FontWeight.bold : FontWeight.normal,),),
                ),


            ),
          ),
          InkWell(
            onTap: () => toggleButton(true),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 6),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: widget.isSeller ? Appcolors.blueColor : Appcolors.blackColor,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.40,
              ),
              child:Center(
                  child: Text('As Seller',style: TextStyle(
                    color: Appcolors.whiteColor,
                    fontWeight: widget.isSeller ? FontWeight.bold : FontWeight.normal,),),
                ),


            ),
          ),
          //  InkWell(
          //     onTap: () => toggleButton(true),
          //     borderRadius: BorderRadius.circular(8.0),
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(vertical: 12.0),
          //       decoration: BoxDecoration(
          //         color: widget.isSeller ? Appcolors.blueColor : Appcolors.blackColor,
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //       child: Center(
          //         child: Text(
          //           'As Seller',
          //           style: TextStyle(
          //             color: Appcolors.whiteColor,
          //             fontWeight: widget.isSeller ? FontWeight.bold : FontWeight.normal,
          //           ),
          //         ),
          //       ),
          //     ),
          // ),
        ],
      );

  }

  Widget chatTile(BuildContext context, Chat chat) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteDialog(context, chat);
      },
      child: ListTile(
        leading: chat.product?.images?.isNotEmpty == true && chat.product?.images?.first.imageUrl != null
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
        title: Text(chat.product!.name! ),
        subtitle: chat.messages != null && chat.messages!.isNotEmpty
            ? Text(
          chat.messages!.last.msg!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
            : const Text(" "),
        trailing: chat.lastMessageAt != null
            ? Text(
          _formatTime(DateTime.parse(chat.lastMessageAt!)),
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
                  chatId: chat.id!.toString(),
                  userId: widget.userId,
                  product: chat.product
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Chat chat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Chat'),
          content: const Text('Are you sure you want to delete this chat?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteChat(chat.id!.toString());
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteChat(String chatId) async {
    try {
      await ref.read(chatListProvider.notifier).deleteChats(chatId);

      Utils.toastMessage('Chat deleted successfully');

    } catch (e) {
      Utils.toastMessage('Failed to delete chat: $e');
    }
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
