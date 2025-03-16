import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';

import 'widgets/map_section.dart';
import 'widgets/saftey_card.dart';


class SafetyRideScreen extends StatelessWidget {
  const SafetyRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedScaffold(
        mainCategoryId: 2,
        body: Stack(
          children: [
        const MapSection(),
    DraggableScrollableSheet(
    initialChildSize: 0.4,
    minChildSize: 0.2,
    maxChildSize: 0.9,
    builder: (context, scrollController) {
   return   Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SingleChildScrollView(
            controller: scrollController,
            child: SafetyCard()),
      );
    }),
          ],
        ),
      ),
    );
  }
}

