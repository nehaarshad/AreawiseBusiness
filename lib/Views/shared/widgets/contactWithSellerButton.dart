import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../View_Model/SharedViewModels/chatListViewModel.dart';
import '../Screens/chatView.dart';

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
    return ElevatedButton.icon(
      onPressed: () {
        // Move the chat creation logic to an async function
        _createChatAndNavigate(context, ref);
      },
      icon: const Icon(Icons.chat),
      label: const Text('Contact Seller'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Separate async function to handle chat creation
  Future<void> _createChatAndNavigate(BuildContext context, WidgetRef ref) async {
    try {
      print('Attempting to create chat with:');
      print('UserID: $userId (${userId.runtimeType})');
      print('ProductID: $productId (${productId.runtimeType})');

      // Create a chat
      await ref.read(chatListProvider.notifier).createChat(userId, productId);

      // After creation, fetch the latest state
      final chatsState = ref.read(chatListProvider);

      if (chatsState.hasValue) {
        final chats = chatsState.value!;
        final chat = chats.firstWhere(
              (c) => c?.productId == productId && c?.buyerId == userId,
          orElse: () => null,
        );

        if (chat != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatView(
                  chatId: chat.id.toString(),
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