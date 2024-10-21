import 'package:flutter/material.dart';

class FloatingActionButtonStar extends StatelessWidget {
  const FloatingActionButtonStar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const CreateChanceView(),
        //   ),
        // );
      },
      backgroundColor: Colors.red,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
