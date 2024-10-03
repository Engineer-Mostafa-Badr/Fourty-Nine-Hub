import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../widgets/public/order_card.dart';

class InstallmentOrdersList extends StatelessWidget {
  const InstallmentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (context, index) => const InstallmentOrderCard(),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: 7),
      ),
    );
  }
}
