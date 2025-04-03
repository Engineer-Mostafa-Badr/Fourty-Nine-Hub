import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/widgets/create_star.dart';

class FloatingActionButtonStar extends StatelessWidget {
  const FloatingActionButtonStar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateStar(),
          ),
        );
      },
      backgroundColor: Colors.red,
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: const Text(
        'Add Talent',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
