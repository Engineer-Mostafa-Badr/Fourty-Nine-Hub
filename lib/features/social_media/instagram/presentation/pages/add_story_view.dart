import 'package:flutter/material.dart';

class AddStoryView extends StatelessWidget {
  const AddStoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: CameraScreenState(),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
