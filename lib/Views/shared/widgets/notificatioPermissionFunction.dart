import 'package:flutter/material.dart';
import '../../../core/services/notificationService.dart';

class NotificationPermission {
// Helper method to request notification permissions
  Future<void> requestNotificationPermissions(BuildContext context) async {
    try {
      final notificationService = NotificationService();
      bool granted = await notificationService.requestPermissions(); //false

      if (!granted) {
        _showPermissionDialog(context);
      } else {
        print("Notification permissions granted successfully");
      }
    } catch (e) {
      print("Error requesting notification permissions: $e");
    }
  }

  Future<void> _showPermissionDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Stay Updated'),
          content: const Text(
              'Allow notifications to receive upcoming and outgoing orders, shop status updates, reminders and other necessary updates done by admin on your products, shops etc.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Not Now'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Allow'),
            ),
          ],
        );
      },
    ).then((shouldRequest) async {
      if (shouldRequest == true) {
        await NotificationService().requestPermissions();
      }
    });
  }

}