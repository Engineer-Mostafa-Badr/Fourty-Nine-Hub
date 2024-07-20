import 'package:flutter/material.dart';

class HealthServiceCard extends StatelessWidget {
  final String imagePath;
  final String name;
  const HealthServiceCard(
      {super.key, required this.imagePath, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ]),
      child: Column(
        children: [
          Expanded(child: Image.asset(imagePath)),
          Text(name),
        ],
      ),
    );
  }
}
