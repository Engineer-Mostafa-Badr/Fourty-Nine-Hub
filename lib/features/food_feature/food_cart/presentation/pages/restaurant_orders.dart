import 'package:flutter/material.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class RestaurantOrders extends StatelessWidget {
  const RestaurantOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.green,
        child: const Text('RestaurantOrders'),
      ),
    );
  }
}
