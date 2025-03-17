import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/widget/new_trip_join_body.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class NewTripJoinScreen extends StatelessWidget {
  const NewTripJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppbar(
        isWithBackArrow: false,
        language: true,
        isMenu: true,
        inNotifications: true,
      ),
      body: const NewTripJoinBody(),
    );
  }
}
