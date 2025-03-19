import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class PercentageCompetitionWidget extends StatefulWidget {
  const PercentageCompetitionWidget({
    super.key,
    required this.currentPoints,
    required this.price,
    required this.totalPoints,
    required this.percentage,
  });
  final num price;
  final int totalPoints;
  final num currentPoints;
  final double percentage;

  @override
  State<PercentageCompetitionWidget> createState() =>
      _PercentageCompetitionWidgetState();
}

class _PercentageCompetitionWidgetState
    extends State<PercentageCompetitionWidget> {
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Positioned(
          top: 50 - 16,
          left: 95,
          right: 95,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 149,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(1.00, 0.00),
                end: const Alignment(-1, 0),
                stops: widget.percentage == 100 ? [1] : null,
                colors: widget.percentage == 100
                    ? [const Color(0xFFF33D49)]
                    : [
                        const Color(0xFF0B1035),
                        const Color(0xFF151F68),
                        const Color(0xFF202E9B),
                        const Color(0xFF0B1035)
                      ],
              ),
            ),
            child: Center(
              child: Label(
                text: '${widget.currentPoints}/${widget.totalPoints}',
                style: Styles.headerText(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 100,
            height: 100,
            decoration: ShapeDecoration(
              // color: Color(0xFF0B1035),
              gradient: LinearGradient(
                colors: const [Color(0xFFF33D49), Color(0xFF0B1035)],
                stops: [widget.percentage / 100, widget.percentage / 100],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              ),
              shape: const OvalBorder(),
            ),
            child: Center(
              child: Label(
                text: '${widget.price}',
                style: Styles.headerText(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 100,
            height: 100,
            decoration: ShapeDecoration(
              // color: Color(0xFF0B1035),
              gradient: LinearGradient(
                colors: const [Color(0xFFF33D49), Color(0xFF0B1035)],
                stops: [widget.percentage / 100, widget.percentage / 100],
                begin: AlignmentDirectional.centerEnd,
                end: AlignmentDirectional.centerStart,
              ),
              shape: const OvalBorder(),
            ),
            child: Center(
              child: Label(
                text: '${widget.percentage.toStringAsFixed(1)}%',
                style: Styles.headerText(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
