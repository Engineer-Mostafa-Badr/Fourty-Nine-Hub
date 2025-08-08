import 'package:flutter/material.dart';

import '../pages/create_chance_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
      ManageVibration.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateChanceView(),
          ),
        );
      },
      backgroundColor: Colors.red,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}