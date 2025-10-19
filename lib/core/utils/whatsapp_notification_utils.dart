import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

/// WhatsApp-style notification utility class
/// Provides methods to create notifications that mimic WhatsApp's appearance and behavior
class WhatsAppNotificationUtils {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  static const String _channelId = 'whatsapp_notifications';
  static const String _channelName = 'WhatsApp Notifications';
  static const String _channelDescription = 'Notifications similar to WhatsApp messages';

  // Notification group keys
  static const String _messageGroupKey = 'whatsapp_messages';
  static const String _summaryGroupKey = 'whatsapp_summary';

  // Counter for message notifications
  static int _messageCounter = 0;
  static int _notificationId = 1000;

  /// Initialize the notification service
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  /// Create Android notification channel
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      // priority: Priority.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Show a WhatsApp-style message notification
  ///
  /// [senderName] - Name of the person sending the message
  /// [message] - The message content
  /// [senderAvatar] - URL or path to sender's profile picture (optional)
  /// [isGroup] - Whether this is a group message (default: false)
  /// [groupName] - Group name (required if isGroup is true)
  /// [messageType] - Type of message (text, image, audio, etc.)
  static Future<void> showWhatsAppMessage({
    required String senderName,
    required String message,
    String? senderAvatar,
    bool isGroup = false,
    String? groupName,
    MessageType messageType = MessageType.text,
  }) async {
    _messageCounter++;

    // Download and save avatar if URL is provided
    String? avatarPath;
    if (senderAvatar != null && senderAvatar.isNotEmpty) {
      avatarPath = await _downloadAndSaveImage(senderAvatar);
    }

    // Create notification details
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      groupKey: isGroup ? groupName ?? _messageGroupKey : _messageGroupKey,
      setAsGroupSummary: false,
      largeIcon: avatarPath != null ? FilePathAndroidBitmap(avatarPath) : null,
      styleInformation: _createMessageStyle(
        senderName: senderName,
        message: message,
        isGroup: isGroup,
        groupName: groupName,
        messageType: messageType,
      ),
      category: AndroidNotificationCategory.message,
      visibility: NotificationVisibility.private,
       playSound: true,
       // sound: const RawResourceAndroidNotificationSound('whatsapp_notification'),
      enableVibration: true,
      // vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
      ledColor: Colors.white, // WhatsApp green
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@mipmap/ic_launcher',
      color: Colors.white,
      // channelShowBadge: _messageCounter,
      actions: [
        const AndroidNotificationAction(
          'reply',
          'Reply',
          showsUserInterface: true,
          inputs: [
            AndroidNotificationActionInput(
              label: 'Quick reply',
              allowFreeFormInput: true,
            ),
          ],
        ),
        const AndroidNotificationAction(
          'mark_read',
          'Mark as Read',
        ),
      ],
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
       // sound: 'whatsapp_notification.wav',
      badgeNumber: _messageCounter,
      categoryIdentifier: 'MESSAGE_CATEGORY',
      threadIdentifier: isGroup ? groupName ?? _messageGroupKey : _messageGroupKey,
      attachments: avatarPath != null ? [DarwinNotificationAttachment(avatarPath)] : null,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification
    await _notificationsPlugin.show(
      _notificationId++,
      isGroup ? groupName : senderName,
      message,
      notificationDetails,
    );

    // Show summary notification if multiple messages
    if (_messageCounter > 1) {
      await _showSummaryNotification();
    }
  }

  /// Show a summary notification for multiple messages
  static Future<void> _showSummaryNotification() async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _messageGroupKey,
      setAsGroupSummary: true,
      styleInformation: BigTextStyleInformation(
        '$_messageCounter new messages',
        summaryText: 'WhatsApp',
      ),
      category: AndroidNotificationCategory.message,
      playSound: false, // Don't play sound for summary
      enableVibration: false, // Don't vibrate for summary
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: true,
      presentSound: false,
      badgeNumber: _messageCounter,
      threadIdentifier: _messageGroupKey,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      999, // Fixed ID for summary notification
      'WhatsApp',
      '$_messageCounter new messages',
      notificationDetails,
    );
  }

  /// Create message style for Android notifications
  static StyleInformation _createMessageStyle({
    required String senderName,
    required String message,
    required bool isGroup,
    String? groupName,
    required MessageType messageType,
  }) {
    String displayName = isGroup ? '$groupName: $senderName' : senderName;

    switch (messageType) {
      case MessageType.text:
        return BigTextStyleInformation(
          message,
          summaryText: displayName,
          contentTitle: displayName,
          htmlFormatContent: true,
        );
      case MessageType.image:
        return BigTextStyleInformation(
          '📷 Photo',
          summaryText: displayName,
          contentTitle: displayName,
        );
      case MessageType.audio:
        return BigTextStyleInformation(
          '🎵 Audio message',
          summaryText: displayName,
          contentTitle: displayName,
        );
      case MessageType.video:
        return BigTextStyleInformation(
          '🎥 Video',
          summaryText: displayName,
          contentTitle: displayName,
        );
      case MessageType.document:
        return BigTextStyleInformation(
          '📄 Document',
          summaryText: displayName,
          contentTitle: displayName,
        );
      case MessageType.location:
        return BigTextStyleInformation(
          '📍 Location',
          summaryText: displayName,
          contentTitle: displayName,
        );
      case MessageType.contact:
        return BigTextStyleInformation(
          '👤 Contact',
          summaryText: displayName,
          contentTitle: displayName,
        );
    }
  }

  /// Download and save image from URL
  static Future<String?> _downloadAndSaveImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null;
  }

  /// Clear all WhatsApp notifications
  static Future<void> clearAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    _messageCounter = 0;
    _notificationId = 1000;
  }

  /// Clear specific notification by ID
  static Future<void> clearNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Show a WhatsApp-style call notification
  static Future<void> showCallNotification({
    required String callerName,
    required String callerNumber,
    String? callerAvatar,
    bool isVideoCall = false,
  }) async {
    String? avatarPath;
    if (callerAvatar != null && callerAvatar.isNotEmpty) {
      avatarPath = await _downloadAndSaveImage(callerAvatar);
    }

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.call,
      largeIcon: avatarPath != null ? FilePathAndroidBitmap(avatarPath) : null,
      styleInformation: BigTextStyleInformation(
        isVideoCall ? 'Incoming video call' : 'Incoming voice call',
        summaryText: callerName,
        contentTitle: callerName,
      ),
       playSound: true,
       // sound: const RawResourceAndroidNotificationSound('whatsapp_call'),
       enableVibration: true,
      ledColor: Colors.white,
      ledOnMs: 1000,
      ledOffMs: 500,
      actions: [
        const AndroidNotificationAction(
          'answer',
          'Answer',
          icon: DrawableResourceAndroidBitmap('ic_phone_answer'),
        ),
        const AndroidNotificationAction(
          'decline',
          'Decline',
          icon: DrawableResourceAndroidBitmap('ic_phone_decline'),
        ),
      ],
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'CALL_CATEGORY',
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      _notificationId++,
      callerName,
      isVideoCall ? 'Incoming video call' : 'Incoming voice call',
      notificationDetails,
    );
  }

  /// Show notification with custom sound (if sound file exists in raw resources)
  static Future<void> showWhatsAppMessageWithCustomSound({
    required String senderName,
    required String message,
    String? senderAvatar,
    bool isGroup = false,
    String? groupName,
    MessageType messageType = MessageType.text,
    String? customSound,
  }) async {
    _messageCounter++;

    // Download and save avatar if URL is provided
    String? avatarPath;
    if (senderAvatar != null && senderAvatar.isNotEmpty) {
      avatarPath = await _downloadAndSaveImage(senderAvatar);
    }

    // Create notification details
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      groupKey: isGroup ? groupName ?? _messageGroupKey : _messageGroupKey,
      setAsGroupSummary: false,
      largeIcon: avatarPath != null ? FilePathAndroidBitmap(avatarPath) : null,
      styleInformation: _createMessageStyle(
        senderName: senderName,
        message: message,
        isGroup: isGroup,
        groupName: groupName,
        messageType: messageType,
      ),
      category: AndroidNotificationCategory.message,
      visibility: NotificationVisibility.private,
      playSound: true,
      sound: customSound != null
          ? RawResourceAndroidNotificationSound(customSound)
          : null,
      enableVibration: true,
      ledColor: Colors.white,
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@mipmap/ic_launcher',
      color: Colors.white,
      actions: [
        const AndroidNotificationAction(
          'reply',
          'Reply',
          showsUserInterface: true,
          inputs: [
            AndroidNotificationActionInput(
              label: 'Quick reply',
              allowFreeFormInput: true,
            ),
          ],
        ),
        const AndroidNotificationAction(
          'mark_read',
          'Mark as Read',
        ),
      ],
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: customSound != null ? '$customSound.wav' : null,
      badgeNumber: _messageCounter,
      categoryIdentifier: 'MESSAGE_CATEGORY',
      threadIdentifier: isGroup ? groupName ?? _messageGroupKey : _messageGroupKey,
      attachments: avatarPath != null ? [DarwinNotificationAttachment(avatarPath)] : null,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification
    await _notificationsPlugin.show(
      _notificationId++,
      isGroup ? groupName : senderName,
      message,
      notificationDetails,
    );

    // Show summary notification if multiple messages
    if (_messageCounter > 1) {
      await _showSummaryNotification();
    }
  }

  /// Show a WhatsApp-style status update notification
  static Future<void> showStatusNotification({
    required String contactName,
    required String statusText,
    String? contactAvatar,
  }) async {
    String? avatarPath;
    if (contactAvatar != null && contactAvatar.isNotEmpty) {
      avatarPath = await _downloadAndSaveImage(contactAvatar);
    }

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      largeIcon: avatarPath != null ? FilePathAndroidBitmap(avatarPath) : null,
      styleInformation: BigTextStyleInformation(
        statusText,
        summaryText: '$contactName updated their status',
        contentTitle: '$contactName updated their status',
      ),
      playSound: false,
      enableVibration: false,
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      _notificationId++,
      '$contactName updated their status',
      statusText,
      notificationDetails,
    );
  }
}

/// Enum for different message types
enum MessageType {
  text,
  image,
  audio,
  video,
  document,
  location,
  contact,
}

/// WhatsApp notification data model
class WhatsAppNotificationData {
  final String senderName;
  final String message;
  final String? senderAvatar;
  final bool isGroup;
  final String? groupName;
  final MessageType messageType;
  final DateTime timestamp;

  WhatsAppNotificationData({
    required this.senderName,
    required this.message,
    this.senderAvatar,
    this.isGroup = false,
    this.groupName,
    this.messageType = MessageType.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'message': message,
      'senderAvatar': senderAvatar,
      'isGroup': isGroup,
      'groupName': groupName,
      'messageType': messageType.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory WhatsAppNotificationData.fromMap(Map<String, dynamic> map) {
    return WhatsAppNotificationData(
      senderName: map['senderName'] ?? '',
      message: map['message'] ?? '',
      senderAvatar: map['senderAvatar'],
      isGroup: map['isGroup'] ?? false,
      groupName: map['groupName'],
      messageType: MessageType.values.firstWhere(
        (e) => e.name == map['messageType'],
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }
}
