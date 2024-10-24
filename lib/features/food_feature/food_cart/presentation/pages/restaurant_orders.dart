import 'package:flutter/material.dart';

class RestaurantOrders extends StatelessWidget {
  const RestaurantOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.green,
        child: const Text('RestaurantOrders'),
      ),
    );
  }
}
