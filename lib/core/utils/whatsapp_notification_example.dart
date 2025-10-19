import 'package:flutter/material.dart';
import 'whatsapp_notification_utils.dart';

/// Example usage of WhatsAppNotificationUtils
class WhatsAppNotificationExample {
  
  /// Initialize the notification service (call this in your main.dart or app initialization)
  static Future<void> initializeNotifications() async {
    await WhatsAppNotificationUtils.initialize();
  }

  /// Example: Show a simple text message notification
  static Future<void> showSimpleMessage() async {
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Mohamed',
      message: 'Hello! How are you?',
      senderAvatar: 'https://example.com/avatar.jpg', // Optional
    );
  }

  /// Example: Show a group message notification
  static Future<void> showGroupMessage() async {
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Ahmed',
      message: 'Meeting at 3 PM today',
      isGroup: true,
      groupName: 'Work Team',
      senderAvatar: 'https://example.com/ahmed_avatar.jpg',
    );
  }

  /// Example: Show different message types
  static Future<void> showMessageTypes() async {
    // Text message
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Sarah',
      message: 'Check this out!',
      messageType: MessageType.text,
    );

    // Image message
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'John',
      message: 'Photo',
      messageType: MessageType.image,
    );

    // Audio message
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Mike',
      message: 'Voice note',
      messageType: MessageType.audio,
    );

    // Location message
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Lisa',
      message: 'My location',
      messageType: MessageType.location,
    );
  }

  /// Example: Show a call notification
  static Future<void> showCallNotification() async {
    await WhatsAppNotificationUtils.showCallNotification(
      callerName: 'Mohamed',
      callerNumber: '+1234567890',
      callerAvatar: 'https://example.com/mohamed_avatar.jpg',
      isVideoCall: false,
    );
  }

  /// Example: Show a video call notification
  static Future<void> showVideoCallNotification() async {
    await WhatsAppNotificationUtils.showCallNotification(
      callerName: 'Ahmed',
      callerNumber: '+1234567890',
      callerAvatar: 'https://example.com/ahmed_avatar.jpg',
      isVideoCall: true,
    );
  }

  /// Example: Show a status update notification
  static Future<void> showStatusNotification() async {
    await WhatsAppNotificationUtils.showStatusNotification(
      contactName: 'Mohamed',
      statusText: 'Having a great day! ☀️',
      contactAvatar: 'https://example.com/mohamed_avatar.jpg',
    );
  }

  /// Example: Clear all notifications
  static Future<void> clearAllNotifications() async {
    await WhatsAppNotificationUtils.clearAllNotifications();
  }

  /// Example: Simulate multiple messages like WhatsApp
  static Future<void> simulateMultipleMessages() async {
    // Simulate receiving multiple messages
    await Future.delayed(const Duration(milliseconds: 500));
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Mohamed',
      message: 'Hey, how are you doing?',
    );

    await Future.delayed(const Duration(milliseconds: 1000));
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Mohamed',
      message: 'Are you free for a call?',
    );

    await Future.delayed(const Duration(milliseconds: 1500));
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Ahmed',
      message: 'Can we meet tomorrow?',
      isGroup: true,
      groupName: 'Friends',
    );

    await Future.delayed(const Duration(milliseconds: 2000));
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Sarah',
      message: 'Thanks for the help!',
    );
  }
}

/// Widget to test notifications
class WhatsAppNotificationTestWidget extends StatelessWidget {
  const WhatsAppNotificationTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Notifications Test'),
        backgroundColor: const Color(0xFF25D366), // WhatsApp green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Test WhatsApp-style Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Simple message button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExample.showSimpleMessage(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Simple Message'),
            ),
            
            const SizedBox(height: 10),
            
            // Group message button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExample.showGroupMessage(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Group Message'),
            ),
            
            const SizedBox(height: 10),
            
            // Multiple message types button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExample.showMessageTypes(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Different Message Types'),
            ),
            
            const SizedBox(height: 10),
            
            // Call notification button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExample.showCallNotification(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Call Notification'),
            ),
            
            const SizedBox(height: 10),
            
            // Video call button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExample.showVideoCallNotification(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Video Call Notification'),
            ),
            
            const SizedBox(height: 10),
            
            // Status update button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExample.showStatusNotification(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Status Update'),
            ),
            
            const SizedBox(height: 10),
            
            // Simulate multiple messages button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExample.simulateMultipleMessages(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF128C7E), // Darker WhatsApp green
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Simulate Multiple Messages'),
            ),
            
            const SizedBox(height: 20),
            
            // Clear notifications button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExample.clearAllNotifications(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Clear All Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
