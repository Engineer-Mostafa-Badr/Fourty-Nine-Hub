import 'package:flutter/material.dart';

class ReactionDemo extends StatefulWidget {
  const ReactionDemo({super.key});

  @override
  _ReactionDemoState createState() => _ReactionDemoState();
}

class _ReactionDemoState extends State<ReactionDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _controller.forward();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPressStart: _onLongPressStart,
            onLongPressEnd: _onLongPressEnd,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text('Post $index'),
              subtitle: Text('This is the content of post $index.'),
              trailing: ScaleTransition(
                scale: _animation,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.thumb_up),
                    SizedBox(width: 5),
                    Icon(Icons.favorite),
                    SizedBox(width: 5),
                    Icon(Icons.sentiment_satisfied),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
