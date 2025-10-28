import 'package:flutter/material.dart';

import 'whatsapp_notification_utils.dart';

/// Test widget to demonstrate different notification icons
class NotificationIconTest extends StatefulWidget {
  const NotificationIconTest({super.key});

  @override
  State<NotificationIconTest> createState() => _NotificationIconTestState();
}

class _NotificationIconTestState extends State<NotificationIconTest> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await WhatsAppNotificationUtils.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Icon Test'),
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test Different Notification Icons',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Collapsed icon test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Collapsed Icon Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will show a notification with a collapsed icon (simple circular icon with "49" text)',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _showCollapsedNotification(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF128C7E),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Show Collapsed Icon Notification'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Expanded icon test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expanded Icon Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will show a notification with an expanded icon (WhatsApp-style chat bubble)',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _showExpandedNotification(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF075E54),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Show Expanded Icon Notification'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Smart notification test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Smart Notification Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will show a smart notification that can automatically choose the appropriate icon',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showSmartNotification(forceCollapsed: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF34B7F1),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Smart (Collapsed)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showSmartNotification(forceCollapsed: false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Smart (Expanded)'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Tap any button to show a notification\n'
              '2. Check your device\'s notification panel\n'
              '3. Notice the different icons in collapsed vs expanded states\n'
              '4. The collapsed icon shows a simple circular design\n'
              '5. The expanded icon shows a WhatsApp-style chat bubble',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCollapsedNotification() async {
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Test User',
      message: 'This is a test message with collapsed icon',
      useCollapsedIcon: true,
    );
  }

  Future<void> _showExpandedNotification() async {
    await WhatsAppNotificationUtils.showWhatsAppMessage(
      senderName: 'Test User',
      message: 'This is a test message with expanded icon',
      useCollapsedIcon: false,
    );
  }

  Future<void> _showSmartNotification({required bool forceCollapsed}) async {
    await WhatsAppNotificationUtils.showWhatsAppMessageSmart(
      senderName: 'Test User',
      message: 'This is a smart notification test',
      forceCollapsedIcon: forceCollapsed,
    );
  }
}


