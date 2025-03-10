import 'package:flutter/material.dart';

class PercentageCompetitionWidget extends StatelessWidget {
  const PercentageCompetitionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: 100,
            height: 100,
            decoration: const ShapeDecoration(
              color: Color(0xFF0B1035),
              shape: OvalBorder(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 149,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(1.00, 0.00),
                end: Alignment(-1, 0),
                colors: [
                  Color(0xFF0B1035),
                  Color(0xFF151F68),
                  Color(0xFF202E9B),
                  Color(0xFF0B1035)
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            width: 100,
            height: 100,
            decoration: const ShapeDecoration(
              color: Color(0xFF0B1035),
              shape: OvalBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
