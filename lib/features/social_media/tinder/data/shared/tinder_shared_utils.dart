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
import 'package:flutter/material.dart';

class TinderSharedUtils {
  static String? _token;

  // Method to initialize _token
  static void initializeToken(String token) {
    if (_token != null) {
      return;
    }
    _token = token;
  }

  // Public getter for _token
  static String get token {
    if (_token == null) {
      throw Exception('Token has not been initialized');
    }
    return _token!;
  }

  // Method to check if the token has been initialized
  static bool get isTokenInitialized => _token != null;

  /// Handles the response from a gift-related operation and displays appropriate UI feedback.
  static void handleGiftResponse({
    required BuildContext context,
    required String response,
  }) {
    const insufficientFundsMessage =
        'You do not have enough money in your wallet.';
    const successMessage = 'The gift has been sent successfully!';

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
          message: '$successMessage\nAmount deducted: ¥10',
          isError: false,
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

  /// Displays a generic popup dialog based on the provided parameters.
  static void _showDialog({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required bool isError,
  }) {
    final primaryColor = isError ? Colors.red : Colors.green;
    final buttonColor = isError ? Colors.red : Colors.indigo;

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(icon, color: primaryColor, size: 30),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.left,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('OK', style: TextStyle(fontSize: 16)),
            ),
            if (isError)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add logic to navigate to the charge wallet screen or perform the charge action
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Charge Wallet'),
              ),
          ],
        );
      },
    );
  }
}
