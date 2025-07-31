import 'package:flutter/material.dart';

class DeclinedAppBar extends StatelessWidget {
  final String receiverName;
  const DeclinedAppBar({super.key, required this.receiverName});

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                receiverName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Call declined',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ]);
  }
}
