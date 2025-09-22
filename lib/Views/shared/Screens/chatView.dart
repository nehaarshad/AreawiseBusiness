import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/chatsViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/loadingState.dart';
import '../widgets/messageItems.dart';


class ChatView extends ConsumerStatefulWidget {
  final String chatId;
  final String userId;
  final ProductModel? product;

  const ChatView({
    Key? key,
    required this.chatId,
    required this.userId,
    this.product,
  }) : super(key: key);

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  late TextEditingController _messageController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await ref.read(chatMessagesProvider(widget.chatId).notifier).loadMessages();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatMsgs = ref.watch(chatMessagesProvider(widget.chatId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Appcolors.baseColor,
        title: InkWell(
          onTap:  () {
            Navigator.pushNamed(
              context,
              routesName.productdetail,
              arguments: {
                'id': int.tryParse(widget.userId),
                'product': widget.product,
                  'productId':widget.product!.id
              },
            );
          },
            child: Row(
              children: [
                widget.product?.images?.first.imageUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child:CachedNetworkImage(
                   imageUrl:  widget.product!.images!.first.imageUrl!,
                    width: 40.w,
                    height: 35.h,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) =>
                        Container(
                          width: 50.w,
                          height: 50.h,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                  ),
                )
                    : Container(
                  width: 50.w,
                  height: 50.h,
                  color: Colors.grey[300],
                  child: const Icon(Icons.shopping_bag),
                ),
                SizedBox(width: 15.w,),
                SizedBox(
                  width: 200.w,
                  child: Text(
                    widget.product?.name ?? "Unknown",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Appcolors.whiteSmoke
                    ),
                    // maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),],
            )
        ),

      ),

      body: Column(
        children: [
          Expanded(
            child: chatMsgs.when(
              data: (messages) {
                // Scroll to bottom when messages load or update
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                if (messages.isEmpty) {
                  return const Center(child:Icon(Icons.chat));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId.toString() == widget.userId;

                    return MessageView(
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
              loading: () => const Column(
                children: [
                    ShimmerListTile(),
                  ShimmerListTile(),
                ],
              ),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          Container(
              margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding:  EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ),
                   SizedBox(width: 8.w),
                  InkWell(
                    onTap: () {
                      if (_messageController.text.trim().isNotEmpty) {
                        ref
                            .read(chatMessagesProvider(widget.chatId).notifier)
                            .sendMessage(widget.userId, _messageController.text.trim());
                        _messageController.clear();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: Appcolors.baseColor,
                        borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Icon(Icons.send, color: Appcolors.whiteSmoke,),
                    ),
                  )

                ],
              ),

          ),
        ],
      ),
    );
  }
}