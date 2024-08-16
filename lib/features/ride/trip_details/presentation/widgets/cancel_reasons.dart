import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../data/models/cancel_reason_model.dart';

class CancelReasons extends StatelessWidget {
  final List<CancelReasonModel> cancelReasons;
  final Function(CancelReasonModel) onCancel;
  const CancelReasons(
      {super.key, required this.cancelReasons, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: cancelReasons.length,
        itemBuilder: (context, index) {
          final reason = cancelReasons[index];
          return ListTile(
            title: Label(text: reason.name),
          );
        });
  }
}
