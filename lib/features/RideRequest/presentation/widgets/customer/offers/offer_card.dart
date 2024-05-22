import 'package:flutter/material.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../res/style/styles.dart';



class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const Sizer(),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text:
                          'Farouk Shahin',
                      style: TextStyle(color: Colors.black)),
                  const WidgetSpan(
                      child: Icon(
                    Icons.star_rounded,
                    color: Colors.orange,
                    size: 16,
                  )),
                  TextSpan(
                      text: '120',
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: '  3)\n',
                      style: TextStyle(color: Colors.grey)),
                  TextSpan(
                      text: 'Fiat Tipo', style: TextStyle(color: Colors.black)),
                ])),
              ),
              RichText(
                  text:  TextSpan(children: [
                TextSpan(
                    text: '2\n', style: TextStyle(color: Colors.black)),
                TextSpan(text: '30km', style: TextStyle(color: Colors.black)),
              ]))
            ],
          ),
          const Sizer(),
          Row(
            children: [
              Expanded(child: Label(text: 'EGP 120', style: Styles.mediumText())),
              ElevatedButton(
                  onPressed: () {}, child: Label(text: 'Accept', style: Styles.mediumText(color: Colors.white))),
            ],
          )
        ],
      ),
    );
  }
}
