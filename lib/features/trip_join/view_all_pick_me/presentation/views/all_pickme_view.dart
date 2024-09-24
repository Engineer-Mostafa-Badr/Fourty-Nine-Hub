import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pick_me_body.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pickme_floating_action_button.dart';

class AllPickMeView extends StatelessWidget {
  const AllPickMeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        SizedBox(width: double.infinity, height: double.infinity),
        AllPickMeBody(),
        AllPickMeFloatingActionButton(),
      ],
    );
  }
}
