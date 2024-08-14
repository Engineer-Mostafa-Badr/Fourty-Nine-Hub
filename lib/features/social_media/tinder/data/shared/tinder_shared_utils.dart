// import 'package:flutter/material.dart';
//
// class TinderSharedUtils {
//   /// Handles the response from a gift-related operation and displays appropriate UI feedback.
//   static void handleGiftResponse({required BuildContext context, required String response}) {
//     switch (response) {
//       case """{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You does not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}""":
//         showInsufficientFundsPopup(context, 'You do not have enough money in your wallet.');
//         break;
//       case """{"status":true,"message":"sent Gift Successfully"}""":
//         showGiftSentPopup(context, '10');
//         break;
//       default:
//         showInsufficientFundsPopup(context, 'Unexpected response format.');
//         break;
//     }
//   }
//
//   /// Displays a popup dialog indicating insufficient funds.
//   static void showInsufficientFundsPopup(BuildContext context, String? message) {
//     Navigator.pop(context);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           title: const Row(
//             children: [
//               Icon(Icons.money_off, color: Colors.red, size: 30),
//               SizedBox(width: 10),
//               Text('Insufficient Funds'),
//             ],
//           ),
//           content: Text(
//             message ?? 'You do not have enough money in your wallet.',
//             style: const TextStyle(fontSize: 16),
//           ),
//           actionsAlignment: MainAxisAlignment.spaceBetween,
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               child: const Text('OK'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Add logic to navigate to the charge wallet screen or perform the charge action
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.indigo,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               child: const Text('Charge Wallet'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   /// Displays a popup dialog indicating that a gift was successfully sent.
//   static void showGiftSentPopup(BuildContext context, String? amount) {
//     Navigator.pop(context);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           title: const Row(
//             children: [
//               Icon(Icons.card_giftcard, color: Colors.green, size: 30),
//               SizedBox(width: 10),
//               Text(
//                 'Gift Sent',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 10),
//               Text(
//                 amount != null
//                     ? 'The gift has been sent successfully!\nAmount deducted: ¥$amount'
//                     : 'The gift has been sent successfully!',
//                 style: const TextStyle(fontSize: 16, color: Colors.black87),
//                 textAlign: TextAlign.left,
//               ),
//               const SizedBox(height: 20),
//               const Icon(Icons.check_circle, color: Colors.green, size: 50),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.indigo,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               child: const Text('OK', style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//enhanced

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';

class TinderSharedUtils {
  static String _token = '';
  static List<String>? favListIds;

  static void initializeToken(String token) {
    if (_token.isNotEmpty) {
      log("$token: Token is already initialized.");
      return;
    }
    _token = token;
    log("$token: Token has been initialized.");
  }

  static String get token => _token;

  static bool get isTokenInitialized => _token.isNotEmpty;

  static String capitalizeEachWord(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  static void handleGiftResponse({
    required BuildContext context,
    required String response,
    required GiftData gift,
  }) {
    const insufficientFundsMessage = 'You do not have enough money in your wallet.';
    const successMessage = 'has been sent successfully!';

    switch (response) {
      case '{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You does not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}':
        _showDialog(
          context: context,
          icon: Icons.money_off,
          title: 'Insufficient Funds',
          message: insufficientFundsMessage,
          isError: true,
        );
        break;
      case '{"status":true,"message":"sent Gift Successfully"}':
        _showDialog(
          context: context,
          icon: Icons.card_giftcard,
          title: 'Gift Sent',
          message: '$successMessage\nAmount deducted: ¥${gift.value}',
          isError: false,
          gift: gift,
        );
        break;
      default:
        _showDialog(
          context: context,
          icon: Icons.error,
          title: 'Error',
          message: 'Unexpected response format.',
          isError: true,
        );
        break;
    }
  }

  static void _showDialog({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required bool isError,
    GiftData? gift,
  }) {
    final primaryColor = isError ? Colors.red : Colors.green;
    final buttonColor = isError ? Colors.red : Colors.indigo;

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: title == 'Gift Sent' ? SizedBox.shrink() : _buildDialogTitle(icon, title, primaryColor),
          content: title == 'Gift Sent' ? _buildGiftContent(gift!, message) : _buildMessageContent(message),
          actions: _buildDialogActions(context, isError, buttonColor),
          actionsAlignment: MainAxisAlignment.end,
        );
      },
    );
  }

  static Widget _buildDialogTitle(IconData icon, String title, Color primaryColor) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 30),
        const SizedBox(width: 10),
        Text(title),
      ],
    );
  }

  static Widget _buildGiftContent(GiftData gift, String message) {
    return Wrap(
      children: [
        SvgPicture.network(
          gift.picture ?? '',
          fit: BoxFit.scaleDown,
          placeholderBuilder: (BuildContext context) => Image.asset('assets/images/icon.png', width: 50, height: 50),
          width: 50,
          height: 50,
        ),
        Text(
          "${gift.nameEn} gift $message",
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  static Widget _buildMessageContent(String message) {
    return Text(
      message,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      textAlign: TextAlign.left,
    );
  }

  static List<Widget> _buildDialogActions(BuildContext context, bool isError, Color buttonColor) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: const Text('OK', style: TextStyle(fontSize: 16)),
      ),
      if (isError)
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          child: const Text('Charge Wallet'),
        ),
    ];
  }
}
