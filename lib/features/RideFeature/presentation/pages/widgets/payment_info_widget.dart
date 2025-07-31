import 'package:flutter/material.dart';

import 'font_manager.dart';
class PaymentInfoWidget extends StatelessWidget {
  final int price;

  const PaymentInfoWidget({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          const Icon(Icons.attach_money, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            'EGP $price Cash',
            style: const TextStyle(fontSize:  FontSize.s14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
