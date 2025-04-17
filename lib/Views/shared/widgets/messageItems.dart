import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../models/messagesModel.dart';


class MessageView extends StatelessWidget {
  final bool sendByMe;
  final Message? message;

  const MessageView({
    Key? key,
    required this.sendByMe,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: sendByMe ? Appcolors.blueColor : Appcolors.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message!.text,
              style: TextStyle(
                color: sendByMe ? Appcolors.whiteColor : Appcolors.blueColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatMessageTime(message!.createdAt),
              style: TextStyle(
                color: (sendByMe ? Appcolors.whiteColor : Appcolors.blueColor).withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMessageTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}