import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../models/notificationModel.dart';

class NotificationService {

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final StreamController<NotificationModel> _notificationStreamController = StreamController<NotificationModel>.broadcast();
  final StreamController<String> _notificationActionStreamController = StreamController<String>.broadcast();

  Stream<NotificationModel> get notificationStream => _notificationStreamController.stream;
  Stream<String> get notificationActionStream => _notificationActionStreamController.stream;

  bool _isInitialized = false;
  bool _permissionsRequested = false;

  Future<void> initialize() async {
    try {
      await _initializeNotifications();
      _isInitialized = true;
      print('NotificationService initialized successfully');
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  // Make this method public so it can be called from login/signup
  Future<bool> requestPermissions() async {
    try {
      if (_permissionsRequested) {
        return await _checkPermissionStatus();
      }

      bool granted = false;

      if (Platform.isAndroid) {
        final androidPlugin = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

        granted = await androidPlugin?.requestNotificationsPermission() ?? false;

      } else if (Platform.isIOS) {
        final iosPlugin = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

        granted = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ?? false;
      }

      _permissionsRequested = true;
      print('Notification permissions granted: $granted');
      return granted;
    } catch (e) {
      print('Error requesting notification permissions: $e');
      return false;
    }
  }

  // Check if permissions are already granted
  Future<bool> _checkPermissionStatus() async {
    if (Platform.isAndroid) {
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      return await androidPlugin?.areNotificationsEnabled() ?? false;
    } else if (Platform.isIOS) {
      // For iOS, we can't easily check permission status without requesting
      // So we'll assume they need to be requested again
      return false;
    }
    return false;
  }

  Future<void> _initializeNotifications() async {
    // Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: false, // Don't auto-request permissions
      requestBadgePermission: false, // Don't auto-request permissions
      requestSoundPermission: false, // Don't auto-request permissions
      //   onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  // Handle notification tap
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    if (response.payload != null) {
      _notificationActionStreamController.add(response.payload!);
    }
  }

  // Show notification with sound
  Future<void> showNotification(NotificationModel notification) async {
    if (!_isInitialized) {
      print(' NotificationService not initialized');
      return;
    }

    try {
      // Check if permissions are granted before showing notification
      bool permissionsGranted = await _checkPermissionStatus();
      if (!permissionsGranted) {
        print('Notification permissions not granted, cannot show notification');
        return;
      }

      // Play notification sound
      await _playNotificationSound();

      // Create notification details
      final notificationDetails = await _createNotificationDetails(notification);

      // Show the notification
      await _flutterLocalNotificationsPlugin.show(
        notification.id!,
        'New Notification',
        notification.message,
        notificationDetails,
        payload: notification.toJson().toString(),
      );

      // Add to stream for UI updates
      _notificationStreamController.add(notification);

      print(' Notification shown: ${notification.message}');
    } catch (e) {
      print(' Error showing notification: $e');
    }
  }

  Future<NotificationDetails> _createNotificationDetails(
      NotificationModel notification) async {
    // Create Android notification details
    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      category: AndroidNotificationCategory.message,
      visibility: NotificationVisibility.public,
      ticker: notification.message,
      styleInformation: BigTextStyleInformation(
        notification.message!,
        contentTitle: "BizAroundU",
        summaryText: "Notification",
      ),
    );

    // Create iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification_sound.wav',
      interruptionLevel: InterruptionLevel.active,
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  Future<void> _playNotificationSound() async {
    try {
      await SystemSound.play(SystemSoundType.alert);
    } catch (fallbackError) {
      print('Error playing fallback sound: $fallbackError');
    }
  }

  // Cancel notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Add method to reset permission state
  void resetPermissionState() {
    _permissionsRequested = false;
    print('Notification permission state reset');
  }

  void dispose() {
    _notificationStreamController.close();
    _notificationActionStreamController.close();
    _audioPlayer.dispose();
  }
}