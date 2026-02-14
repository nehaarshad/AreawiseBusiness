import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/chatListViewModel.dart';
import '../../../core/utils/textStyles.dart';
import '../../../models/chatsModel.dart';
import '../widgets/loadingState.dart';
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

    Future.microtask(() => loadChats());
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
       loadChats();
      }
    });
  }

  void loadChats() {
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
    loadChats();
  }

  @override
  Widget build(BuildContext context) {
    final chatsList = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Chats',style: AppTextStyles.headline,)),
      body: Column(
        children: [
          topBarButtons(),
          SizedBox(height: 10,),
          Expanded(child:
          chatsList.when(
            loading: () => const Column(
              children: [
                ShimmerListTile(),
                ShimmerListTile(),
                ShimmerListTile(),
              ],
            ),
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
              margin:  EdgeInsets.symmetric(vertical: 12.0.h,horizontal: 20.w),
               padding:  EdgeInsets.symmetric(vertical: 12.0.h),
               decoration: BoxDecoration(
               color: !widget.isSeller ? Appcolors.baseColor : Colors.grey[300],
               borderRadius: BorderRadius.circular(25.r),
                  ),
              constraints: BoxConstraints(
                maxWidth: 140.w,
              ),
              child: Center(
                  child: Text('As Buyer',style: TextStyle(
                    color:  !widget.isSeller ? Appcolors.whiteSmoke : Appcolors.blackColor,
                    fontWeight: !widget.isSeller ? FontWeight.bold : FontWeight.normal,),),
                ),


            ),
          ),
          InkWell(
            onTap: () => toggleButton(true),
            child: Container(
              margin:  EdgeInsets.symmetric(vertical: 12.0.h,horizontal: 6.w),
              padding:  EdgeInsets.symmetric(vertical: 12.0.h),
              decoration: BoxDecoration(
                color: widget.isSeller ? Appcolors.baseColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(25.r),
              ),
              constraints: BoxConstraints(
                maxWidth: 140.w,
              ),
              child:Center(
                  child: Text('As Seller',style: TextStyle(
                    color:   widget.isSeller ? Appcolors.whiteSmoke : Appcolors.blackColor,
                    fontWeight: widget.isSeller ? FontWeight.bold : FontWeight.normal,),),
                ),


            ),
          ),
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
          borderRadius: BorderRadius.circular(30.r),
          child: CachedNetworkImage(
           imageUrl:  chat.product!.images!.first.imageUrl!,
            width: 45.w,
            height: 38.h,
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) =>
                Container(
                  width: 45.w,
                  height: 38.h,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
          ),
        )
            : Container(
          width: 45.w,
          height: 38.h,
          color: Colors.grey[300],
          child: const Icon(Icons.shopping_bag),
        ),
        title: Text(chat.product!.name! ,style: TextStyle(
          fontSize: 18.sp,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,),
        subtitle: chat.messages != null && chat.messages!.isNotEmpty
            ? Text(
          chat.messages!.last.msg!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.sp,
          ),
        )
            : const Text(" "),
        trailing: chat.lastMessageAt != null
            ? Text(
          _formatTime(DateTime.parse(chat.lastMessageAt!)),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10.sp,
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
                  receiverId: chat.product!.seller.toString(),
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
