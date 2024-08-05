import 'package:flutter/material.dart';

class CustomExtendedButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  const CustomExtendedButton(
      {super.key, required this.onTap, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20.0,
        backgroundColor: Colors.white,
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
