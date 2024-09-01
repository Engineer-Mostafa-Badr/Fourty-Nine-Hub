import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class SnapView extends StatelessWidget {
  const SnapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(child: Image.asset(Assets.snapDemo)),
    );
  }
}
