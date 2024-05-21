import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../../../../common/widgets/stateless/appbar/back_appbar.dart';

class LuckyWheelView extends StatelessWidget {
  StreamController<int> controller = StreamController<int>();

  LuckyWheelView({super.key});
  List<FortuneItem> list = [
    FortuneItem(
      child: Text('1K Points'),
    ),
    FortuneItem(child: Text('100 Point')),
    FortuneItem(child: Text('300 Points')),
    FortuneItem(child: Text('2k Points')),
    FortuneItem(child: Text('500 Points')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FortuneWheel(
          hapticImpact: HapticImpact.heavy,

          // selected: controller.stream,
          items: list,
        ),
      ),
    );
  }
}
