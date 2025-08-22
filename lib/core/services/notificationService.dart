import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _requestPermissions();
      await _initializeNotifications();
      await _setupAudio();
      _isInitialized = true;
      print('NotificationService initialized successfully');
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();

      // Request additional permissions
      await Permission.notification.request();
      await Permission.audio.request();
    } else if (Platform.isIOS) {
      final iosPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

      await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _initializeNotifications() async {
    // Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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

  Future<void> _setupAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      print('Error setting up audio: $e');
    }
  }

  // Handle notification tap
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    if (response.payload != null) {
      _notificationActionStreamController.add(response.payload!);
    }
  }

  // Handle iOS foreground notification
  static void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print(' iOS foreground notification: $title - $body');
  }

  // Show notification with sound
  Future<void> showNotification(NotificationModel notification) async {
    if (!_isInitialized) {
      print(' NotificationService not initialized');
      return;
    }

    try {
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
      // Play from assets
      await _audioPlayer.play(AssetSource('sound/notification-1-269296.mp3'));
      // Device Vibration
      await HapticFeedback.vibrate();
    } catch (e) {
      print(' Error playing notification sound: $e');
      // Fallback to system sound
      try {
        await SystemSound.play(SystemSoundType.alert);
      } catch (fallbackError) {
        print('Error playing fallback sound: $fallbackError');
      }
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

  void dispose() {
    _notificationStreamController.close();
    _notificationActionStreamController.close();
    _audioPlayer.dispose();
  }
}