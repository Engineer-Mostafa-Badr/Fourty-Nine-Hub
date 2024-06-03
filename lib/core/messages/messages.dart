import 'package:flutter/material.dart';

import '../../common/widgets/stateless/buttons/default_button.dart';
import '../../common/widgets/stateless/buttons/elevated_button.dart';

void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      margin: const EdgeInsets.only(
        bottom: 25,
        right: 20,
        left: 20,
      ),
    ),
  );
}

void showSuccessMessage(BuildContext context, String message) {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        margin: const EdgeInsets.only(
          bottom: 25,
          right: 20,
          left: 20,
        ),
      ),
    ),
  );
}

void showSuccessDialog(BuildContext context, String text) => showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 20,
          bottom: 40,
        ),
      ),
    );

void showConfirmDialog(
  BuildContext context,
  String text,
  VoidCallback? onConfirm, {
  String? confirmText,
  String? cancelText,
  VoidCallback? onCancel,
  TextStyle? cancelTextStyle,
  TextStyle? confirmTextStyle,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.only(
        right: 20,
        left: 20,
        top: 20,
        bottom: 40,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: DefaultButton(
                label: cancelText ?? 'Cancel',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  onCancel?.call();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedAppButton(
                label: confirmText ?? 'Delete',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  onConfirm?.call();
                },
              ),
            ),
          ],
        )
      ],
    ),
  );
}
