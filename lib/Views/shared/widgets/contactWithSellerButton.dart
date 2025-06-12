import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SharedViewModels/chatListViewModel.dart';
import '../../../models/chatsModel.dart';
import '../Screens/chatView.dart';
import '../../../core/utils/colors.dart';

class contactWithSellerButton extends ConsumerWidget {
  final String userId;
  final String productId;
  final ProductModel? product;

  const contactWithSellerButton({
    Key? key,
    required this.userId,
    required this.productId,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  IconButton(
      tooltip: 'Chat with Seller',
      icon:  Icon(Icons.chat_outlined, color: Appcolors.blackColor,size: 18.h,),
      onPressed: () => _createChatAndNavigate(context, ref),
    );

  }

  // Separate async function to handle chat creation
  Future<void> _createChatAndNavigate(BuildContext context, WidgetRef ref) async {
    try {
      print('Attempting to create chat with:');
      print('UserID: $userId (${userId.runtimeType})');
      print('ProductID: $productId (${productId.runtimeType})');

      // Create a chat first
      final createdChat = await ref.read(chatListProvider.notifier).createChat(userId, productId);

      // If chat was created successfully, navigate to it
      if (createdChat != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatView(
                chatId: createdChat.id.toString(),
                userId: userId,
                product: product
            ),
          ),
        );
        return;
      }

      // If creation returns null, try to find existing chat
      final chatsState = ref.read(chatListProvider);
      if (chatsState.hasValue && chatsState.value != null) {
        final chats = chatsState.value!;

        // Find the chat with matching product and buyer IDs
        Chat? foundChat;
        for (final chat in chats) {
          if (chat != null &&
              chat.productId.toString() == productId &&
              chat.buyerId.toString() == userId) {
            foundChat = chat;
            break;
          }
        }

        if (foundChat != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatView(
                  chatId: foundChat!.id.toString(),
                  userId: userId,
                  product: product
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chat not found. Please try again.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to create chat. Please try again.')),
        );
      }
    } catch (e) {
      print('Error in chat creation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}