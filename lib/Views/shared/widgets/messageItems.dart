import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import '../../../models/messagesModel.dart';

class MessageView extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageView({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65, // Max 75% of screen width
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                topLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                bottomLeft: const Radius.circular(12),
                bottomRight: const Radius.circular(12),
              ),
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.msg ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

      ),
    );
  }
  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour < 12 ? 'AM' : 'PM';
      final hour12;
      if (hour == 0) {
        hour12 = 12;  // midnight (0:00) → 12 AM
      } else if (hour > 12) {
        hour12 = hour - 12;  // PM hours
      } else {
        hour12 = hour;  // AM hours (1-12)
      }

      return '$hour12:$minute $period';
    } catch (_) {
      return '';
    }
  }
}