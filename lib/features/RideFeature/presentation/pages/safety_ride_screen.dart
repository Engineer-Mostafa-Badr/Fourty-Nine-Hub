import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';

import 'widgets/map_section.dart';
import 'widgets/saftey_card.dart';


class SafetyRideScreen extends StatelessWidget {
  const SafetyRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SharedScaffold(
        mainCategoryId: 2,
        body: Stack(
          children: [
        MapSection(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafetyCard(),
            ),
          ],
        ),
      ),
    );
  }
}
