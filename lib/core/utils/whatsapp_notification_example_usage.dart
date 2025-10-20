import 'package:flutter/material.dart';
import 'whatsapp_notification_utils.dart';

/// Example showing how to use WhatsApp notification with reply functionality
class WhatsAppNotificationExampleUsage {
  
  /// Initialize the notification service with reply handler
  static Future<void> initializeNotifications() async {
    await WhatsAppNotificationUtils.initialize(
      onReply: (replyText, senderName, groupName) {
        // This function will be called when user replies
        print('User replied: "$replyText" to $senderName${groupName != null ? ' in $groupName' : ''}');
        
        // Here you can implement your reply logic:
        // - Send the reply to your backend
        // - Update the conversation in your database
        // - Show a confirmation to the user
        // - Navigate to the chat screen
        // - etc.
        
        _handleReply(replyText, senderName, groupName);
      },
    );
  }

  /// Set up notification response handling in your main app
  /// Call this in your main.dart or app initialization
  static void setupNotificationHandling() {
    // You can set up a listener for notification responses
    // This depends on your app's architecture
    // For example, if you're using a state management solution:
    
    // Example with GetX:
    // Get.find<NotificationController>().onNotificationResponse = (response) {
    //   WhatsAppNotificationUtils.handleNotificationResponse(response);
    // };
    
    // Example with Bloc:
    // context.read<NotificationBloc>().add(HandleNotificationResponse(response));
    
    // Example with Provider:
    // Provider.of<NotificationProvider>(context, listen: false)
    //     .handleNotificationResponse(response);
  }

  /// Handle the reply action
  static void _handleReply(String replyText, String senderName, String? groupName) {
    // Example implementation:
    
    // 1. Send reply to your backend
    _sendReplyToBackend(replyText, senderName, groupName);
    
    // 2. Show confirmation to user
    _showReplyConfirmation(replyText, senderName);
    
    // 3. Update local conversation
    _updateLocalConversation(replyText, senderName, groupName);
  }

  /// Send reply to your backend server
  static void _sendReplyToBackend(String replyText, String senderName, String? groupName) {
    // Example: Send to your API
    print('Sending to backend:');
    print('  Message: $replyText');
    print('  To: $senderName');
    print('  Group: $groupName');
    
    // You can use your existing API service here
    // await ApiService.sendMessage(replyText, senderName, groupName);
  }

  /// Show confirmation to user
  static void _showReplyConfirmation(String replyText, String senderName) {
    // Example: Show a snackbar or toast
    print('Reply sent successfully to $senderName');
    
    // If you have access to BuildContext, you can show a SnackBar:
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Reply sent to $senderName')),
    // );
  }

  /// Update local conversation
  static void _updateLocalConversation(String replyText, String senderName, String? groupName) {
    // Example: Update your local database or state
    print('Updating local conversation with $senderName');
    
    // You can update your conversation state here
    // conversationBloc.add(AddMessageEvent(replyText, senderName, groupName));
  }

  /// Show a simple message notification
  static Future<void> showSimpleMessage() async {
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Mohamed',
      message: 'Hello! How are you?',
      senderAvatar: 'https://example.com/avatar.jpg', // Optional
    );
  }

  /// Show a message notification with collapsed icon
  static Future<void> showMessageWithCollapsedIcon() async {
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Mohamed',
      message: 'Hello! How are you?',
      senderAvatar: 'https://example.com/avatar.jpg',
      useCollapsedIcon: true, // This will use the collapsed icon
    );
  }

  /// Show a message notification with expanded icon
  static Future<void> showMessageWithExpandedIcon() async {
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Mohamed',
      message: 'Hello! How are you?',
      senderAvatar: 'https://example.com/avatar.jpg',
      useCollapsedIcon: false, // This will use the expanded icon
    );
  }

  /// Show a smart notification that automatically chooses the icon
  static Future<void> showSmartMessage({bool forceCollapsed = false}) async {
    await WhatsAppNotificationUtils.showWhatsAppMessageSmart(
      senderName: 'Mohamed',
      message: 'Hello! How are you?',
      senderAvatar: 'https://example.com/avatar.jpg',
      forceCollapsedIcon: forceCollapsed,
    );
  }

  /// Show a group message notification
  static Future<void> showGroupMessage() async {
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Ahmed',
      message: 'Meeting at 3 PM today',
      isGroup: true,
      groupName: 'Work Team',
      senderAvatar: 'https://example.com/ahmed_avatar.jpg',
    );
  }

  /// Show a call notification
  static Future<void> showCallNotification() async {
    await WhatsAppNotificationUtils.showCallNotification(
      callerName: 'Mohamed',
      callerNumber: '+1234567890',
      callerAvatar: 'https://example.com/mohamed_avatar.jpg',
      isVideoCall: false,
    );
  }
}

/// Widget to test notifications with reply functionality
class WhatsAppNotificationTestWidget extends StatefulWidget {
  const WhatsAppNotificationTestWidget({super.key});

  @override
  State<WhatsAppNotificationTestWidget> createState() => _WhatsAppNotificationTestWidgetState();
}

class _WhatsAppNotificationTestWidgetState extends State<WhatsAppNotificationTestWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications with reply handler
    WhatsAppNotificationExampleUsage.initializeNotifications();
  }

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
              'Test WhatsApp-style Notifications with Reply',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Simple message button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExampleUsage.showSimpleMessage(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Simple Message (with Reply)'),
            ),
            
            const SizedBox(height: 10),
            
            // Collapsed icon message button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExampleUsage.showMessageWithCollapsedIcon(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF128C7E),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Message with Collapsed Icon'),
            ),
            
            const SizedBox(height: 10),
            
            // Expanded icon message button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExampleUsage.showMessageWithExpandedIcon(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075E54),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Message with Expanded Icon'),
            ),
            
            const SizedBox(height: 10),
            
            // Smart message button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExampleUsage.showSmartMessage(forceCollapsed: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34B7F1),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Smart Message (Collapsed)'),
            ),
            
            const SizedBox(height: 10),
            
            // Group message button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExampleUsage.showGroupMessage(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Group Message (with Reply)'),
            ),
            
            const SizedBox(height: 10),
            
            // Call notification button
            ElevatedButton(
              onPressed: () => WhatsAppNotificationExampleUsage.showCallNotification(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF128C7E), // Darker WhatsApp green
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Call Notification'),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Tap a button to show a notification\n'
              '2. Notice the different icons for collapsed vs expanded states\n'
              '3. Expand the notification to see the full content\n'
              '4. Tap "Reply" to test the reply functionality\n'
              '5. Check the console for reply logs\n\n'
              'Icon Types:\n'
              '• Collapsed Icon: Simple circular icon with "49" text\n'
              '• Expanded Icon: WhatsApp-style chat bubble icon',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
