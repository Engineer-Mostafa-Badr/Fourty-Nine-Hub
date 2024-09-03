import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class SpotlightView extends StatelessWidget {
  const SpotlightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(child: Image.asset(Assets.spotLightDemo)),
    );
  }
}
