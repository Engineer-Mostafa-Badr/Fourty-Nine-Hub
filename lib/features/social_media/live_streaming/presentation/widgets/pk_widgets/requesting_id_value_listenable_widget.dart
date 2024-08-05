import 'package:flutter/material.dart';

class PKRequestingIDValueListenableWidget extends StatefulWidget {
  final ValueNotifier<String> requestIDNotifier;

  const PKRequestingIDValueListenableWidget({
    super.key,
    required this.requestIDNotifier,
  });

  @override
  State<PKRequestingIDValueListenableWidget> createState() =>
      _PKRequestingIDValueListenableWidgetState();
}

class _PKRequestingIDValueListenableWidgetState
    extends State<PKRequestingIDValueListenableWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.requestIDNotifier,
      builder: (context, requestID, _) {
        if (requestID.isEmpty) {
          return Container();
        }
        return Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Text(
            'Request ID:$requestID',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
