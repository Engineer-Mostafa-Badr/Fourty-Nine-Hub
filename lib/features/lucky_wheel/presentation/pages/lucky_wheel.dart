import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../common/widgets/stateless/buttons/elevated_button.dart';

class LuckyWheelView extends StatefulWidget {
  LuckyWheelView({super.key});

  @override
  State<LuckyWheelView> createState() => _LuckyWheelViewState();
}

class _LuckyWheelViewState extends State<LuckyWheelView> {
  StreamController<int> controller = StreamController<int>();

  var selectedIdea = "";

  List<String> prizes = [
    '1K Points',
    '100 Point',
    '300 Points',
    '2k Points',
    '500 Points'
  ];

  List<FortuneItem> fortunelist = [];

  void setValue(value) {
    selectedIdea = prizes[value];
  }

  @override
  void initState() {
    prizes.forEach((prize) {
      fortunelist.add(
        FortuneItem(
          child: Text(prize),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: 'lucky wheel',
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                selected: controller.stream,
                animateFirst: false,
                duration: const Duration(seconds: 3),
                hapticImpact: HapticImpact.heavy,
                onAnimationEnd: () {
                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: AlertDialog(
                            scrollable: false,
                            title: const Center(child: Text("You Win!")),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    selectedIdea,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  ElevatedAppButton(
                                    label: 'back',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },

                onFocusItemChanged: (value) {
                  setValue(value);
                },

                // selected: controller.stream,
                items: fortunelist,
              ),
            ),
            AppButton(
              height: 50,
              width: 300,
              label: 'Spin',
              onPressed: () async {
                controller.add(
                  Fortune.randomInt(0, fortunelist.length),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
