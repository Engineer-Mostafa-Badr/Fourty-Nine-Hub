import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../res/style/app_colors.dart';
import '../utils/flutter_markdown.dart';
import '../utils/provider_wrapper.dart';
import 'text_input_widget_usecases.dart';

// CallMessageButtons Widgetbook Implementation
@widgetbook.UseCase(
  name: 'Basic Call Message Buttons',
  type: MockCallMessageButtons,
)
Widget basicCallMessageButtonsWidget(BuildContext context) {
  // استخدام الـ knobs للتحكم في الخصائص
  final otherUserId = context.knobs.string(
    label: 'Other User ID',
    initialValue: 'user123',
  );

  final clientId = context.knobs.stringOrNull(
    label: 'Client ID',
    initialValue: 'client456',
  );

  final subcategoryId = context.knobs.string(
    label: 'Subcategory ID',
    initialValue: 'subcat789',
  );

  final phone = context.knobs.string(
    label: 'Phone Number',
    initialValue: '+1234567890',
  );

  final id = context.knobs.string(
    label: 'ID',
    initialValue: 'msg001',
  );

  final senderName = context.knobs.stringOrNull(
    label: 'Sender Name',
    initialValue: 'John Doe',
  );

  final senderImage = context.knobs.stringOrNull(
    label: 'Sender Image URL',
    initialValue: 'https://example.com/avatar.jpg',
  );

  final hasReport = context.knobs.boolean(
    label: 'Has Report Button',
    initialValue: true,
  );

  final flex = context.knobs.intOrNull.slider(
    label: 'Call Button Flex',
    initialValue: 3,
    min: 1,
    max: 10,
  );

  final chatFlex = context.knobs.intOrNull.slider(
    label: 'Chat Button Flex',
    initialValue: 3,
    min: 1,
    max: 10,
  );

  return WidgetbookProviderWrapper(
    child: WidgetbookScreenUtilFormWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CallMessageButtons Demo'),
          backgroundColor: AppColors.PRIMARY_COLOR,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // عرض معلومات المستخدم
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('Name: ${senderName ?? "Unknown"}'),
                      Text('Phone: $phone'),
                      Text('User ID: $otherUserId'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // أزرار الاتصال والرسائل
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: MockCallMessageButtons(
                  otherUserId: otherUserId,
                  clientId: clientId,
                  subcategoryId: subcategoryId,
                  phone: phone,
                  id: id,
                  senderName: senderName,
                  senderImage: senderImage,
                  hasReport: hasReport,
                  flex: flex,
                  chatFlex: chatFlex,
                ),
              ),
              const SizedBox(height: 20),
              // معلومات إضافية
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Widget Configuration',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Call Button Flex: ${flex ?? "Default (3)"}'),
                      Text('Chat Button Flex: ${chatFlex ?? "Default (3)"}'),
                      Text('Has Report: ${hasReport ? "Yes" : "No"}'),
                      Text('Subcategory ID: $subcategoryId'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// CallMessageButtons مع أحجام مختلفة
@widgetbook.UseCase(
  name: 'Call Message Buttons Sizes',
  type: MockCallMessageButtons,
)
Widget callMessageButtonsSizesWidget(BuildContext context) {
  return WidgetbookProviderWrapper(
    child: WidgetbookScreenUtilFormWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CallMessageButtons - Different Sizes'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // أزرار صغيرة
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Small Buttons (Flex: 1, 1)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      MockCallMessageButtons(
                        otherUserId: 'user1',
                        subcategoryId: 'subcat1',
                        phone: '+1111111111',
                        id: 'msg1',
                        senderName: 'Small User',
                        flex: 1,
                        chatFlex: 1,
                        hasReport: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // أزرار متوسطة
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medium Buttons (Default: 3, 3)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      MockCallMessageButtons(
                        otherUserId: 'user2',
                        subcategoryId: 'subcat2',
                        phone: '+2222222222',
                        id: 'msg2',
                        senderName: 'Medium User',
                        hasReport: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // أزرار كبيرة
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Large Buttons (Flex: 5, 5)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      MockCallMessageButtons(
                        otherUserId: 'user3',
                        subcategoryId: 'subcat3',
                        phone: '+3333333333',
                        id: 'msg3',
                        senderName: 'Large User',
                        flex: 5,
                        chatFlex: 5,
                        hasReport: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// CallMessageButtons في حالات مختلفة
@widgetbook.UseCase(
  name: 'Call Message Buttons States',
  type: MockCallMessageButtons,
)
Widget callMessageButtonsStatesWidget(BuildContext context) {
  final buttonState = context.knobs.list(
    label: 'Button State',
    options: ['Enabled', 'Disabled', 'Loading'],
    initialOption: 'Enabled',
  );

  final hasReportButton = context.knobs.boolean(
    label: 'Show Report Button',
    initialValue: true,
  );

  return WidgetbookProviderWrapper(
    child: WidgetbookScreenUtilFormWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text('CallMessageButtons - $buttonState State'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // حالة عادية
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Normal User',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      MockCallMessageButtons(
                        otherUserId: 'user1',
                        subcategoryId: 'subcat1',
                        phone: '+1234567890',
                        id: 'msg1',
                        senderName: 'Ahmed Ali',
                        hasReport: hasReportButton,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // حالة مع flex مخصص
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Custom Flex (Call:2, Chat:4)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      MockCallMessageButtons(
                        otherUserId: 'user2',
                        subcategoryId: 'subcat2',
                        phone: '+9876543210',
                        id: 'msg2',
                        senderName: 'Sarah Mohamed',
                        flex: 2,
                        chatFlex: 4,
                        hasReport: hasReportButton,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // حالة بدون تقرير
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Report Button',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      MockCallMessageButtons(
                        otherUserId: 'user3',
                        subcategoryId: 'subcat3',
                        phone: '+5555555555',
                        id: 'msg3',
                        senderName: 'Omar Hassan',
                        hasReport: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// CallMessageButtonsWidget Documentation
@widgetbook.UseCase(
  name: 'CallMessageButtonsWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer callMessageButtonsWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath:
        'assets/markdown/docs/call_message_buttons_markdown_doc.md',
  );
}

// Mock implementation of ButtonAvailability for Widgetbook
class MockButtonAvailability {
  Future<bool> isShowButton({
    String? clientId,
    required String otherUserId,
    required String subcategoryId,
  }) async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 500));

    // Return true for demonstration purposes
    // In a real scenario, this would check subscription status, permissions, etc.
    return true;
  }
}

// Mock version of CallMessageButtons for Widgetbook
class MockCallMessageButtons extends StatefulWidget {
  final String otherUserId;

  final String? clientId;
  final String subcategoryId;
  final String phone;
  final String id;
  final String? senderName;
  final String? senderImage;
  final bool? hasReport;
  final int? flex;
  final int? chatFlex;
  const MockCallMessageButtons({
    super.key,
    required this.otherUserId,
    required this.subcategoryId,
    required this.phone,
    this.senderName,
    this.senderImage,
    required this.id,
    this.hasReport = false,
    this.flex,
    this.chatFlex,
    this.clientId,
  });

  @override
  State<MockCallMessageButtons> createState() => _MockCallMessageButtonsState();
}

class _MockCallMessageButtonsState extends State<MockCallMessageButtons> {
  final MockButtonAvailability _buttonAvailability = MockButtonAvailability();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _buttonAvailability.isShowButton(
        clientId: widget.clientId,
        otherUserId: widget.otherUserId,
        subcategoryId: widget.subcategoryId,
      ),
      builder: (context, snap) {
        final isButtonEnabled = snap.data ?? false;
        final isLoggedIn = context.read<MockUserCubit>().isLoggedIn;

        return Row(
          children: [
            Expanded(
              flex: widget.flex ?? 3,
              child: IconButton(
                color: (isButtonEnabled && isLoggedIn)
                    ? Colors.blue // AppColors.PRIMARY_COLOR equivalent
                    : Colors.grey, // AppColors.DARK_GRAY_COLOR equivalent
                icon: Icon(
                  Icons.phone,
                  size: 35,
                  color: isButtonEnabled
                      ? Colors.green // AppColors.SECONDARY_COLOR equivalent
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey,
                ),
                onPressed: !isLoggedIn
                    ? () {
                        _showMockLoginDialog(context);
                      }
                    : isButtonEnabled
                        ? () {
                            _showCallOptions(context);
                          }
                        : () {
                            _showSubscriptionDialog(context);
                          },
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: widget.chatFlex ?? 3,
              child: IconButton(
                color: (isButtonEnabled && isLoggedIn)
                    ? Colors.blue // AppColors.PRIMARY_COLOR equivalent
                    : Colors.grey, // AppColors.DARK_GRAY_COLOR equivalent
                icon: Icon(
                  Icons.message,
                  size: 30,
                  color: isButtonEnabled
                      ? Colors.green // AppColors.SECONDARY_COLOR equivalent
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey,
                ),
                onPressed: !isLoggedIn
                    ? () {
                        _showMockLoginDialog(context);
                      }
                    : isButtonEnabled
                        ? () async {
                            await _createMockChat(context);
                          }
                        : () {
                            _showSubscriptionDialog(context);
                          },
              ),
            ),
            if (widget.hasReport == true) ...[
              const SizedBox(width: 5),
              IconButton(
                color: Colors.green, // AppColors.SECONDARY_COLOR equivalent
                icon: const Icon(Icons.report),
                onPressed: !isLoggedIn
                    ? () {
                        _showMockLoginDialog(context);
                      }
                    : () {
                        _showReportDialog(context);
                      },
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _createMockChat(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Creating mock chat...')),
    );

    // Simulate chat creation
    await Future.delayed(const Duration(seconds: 1));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mock chat created successfully!')),
    );
  }

  void _showCallOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      builder: (context) => Container(
        height: 150,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Mock Service Call to ${widget.phone}')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
                child: const Text('Service Call',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mock Premium Call Started')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
                child: const Text('Premium Call',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMockLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please log in to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Mock Login - Feature would navigate to login')),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Report ${widget.senderName ?? 'this user'}?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Reason for reporting...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mock Report Submitted')),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subscription Required'),
        content: const Text('This feature requires a subscription to access.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Mock Subscribe - Would navigate to subscription')),
              );
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}
