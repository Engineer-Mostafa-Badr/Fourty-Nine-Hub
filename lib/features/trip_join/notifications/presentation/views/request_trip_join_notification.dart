import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RequestTripJoinNotificationView extends StatefulWidget {
  const RequestTripJoinNotificationView({super.key, required this.payload});
  final Map<String, dynamic> payload;
  @override
  State<RequestTripJoinNotificationView> createState() => _RequestTripJoinNotificationViewState();
}

class _RequestTripJoinNotificationViewState extends State<RequestTripJoinNotificationView> {
  @override
  Widget build(BuildContext context) {
    pr('notication page build method is called');
    pr(widget.payload);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Transform(
              transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
              child: Text(
                'Trip Join Notification',
                style: Styles.headerText(),
              ),
            ),
          ),
          body: Center(
            child: Text(widget.payload['firstName'] ?? 'payload not recieved'),
          )),
    );
  }
}
