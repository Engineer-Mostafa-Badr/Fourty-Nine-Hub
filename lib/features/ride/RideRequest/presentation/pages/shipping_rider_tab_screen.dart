import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/ride_request_view.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_shipping_view.dart';

class ShippingRiderTabScreen extends StatelessWidget {
  const ShippingRiderTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedScaffold(
      mainCategoryId: 1,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Text("Ride"),
                Text("Ship"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RideRequestView(),
                  CreateShippingView()

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
