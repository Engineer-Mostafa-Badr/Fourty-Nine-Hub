import 'package:flutter/material.dart';

class MinimizedScreen extends StatelessWidget {
  final VoidCallback onTap;

  const MinimizedScreen({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: Text('Minimized')),
      ),
    );
  }
}

class DraggableMinimizedScreen extends StatefulWidget {
  final Widget child;

  const DraggableMinimizedScreen({super.key, required this.child});

  @override
  DraggableMinimizedScreenState createState() =>
      DraggableMinimizedScreenState();
}

class DraggableMinimizedScreenState extends State<DraggableMinimizedScreen> {
  Offset offset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                offset = Offset(
                    offset.dx + details.delta.dx, offset.dy + details.delta.dy);
              });
            },
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
