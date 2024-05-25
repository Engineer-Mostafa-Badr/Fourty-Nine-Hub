import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/CarouselSlider.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AnnounceWidget extends StatelessWidget {
  const AnnounceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSliderWidget(height: kToolbarHeight * 2, widgets: [
      _buildAnnounceItem(),
      _buildAnnounceItem(),
      _buildAnnounceItem(),
    ]);
  }

  Widget _buildAnnounceItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.network(
              UIConst.imagePlaceHolder,
              fit: BoxFit.cover,
            )),
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black.withOpacity(.1),
                    Colors.black.withOpacity(.3),
                    Colors.black.withOpacity(.6),
                  ])),
            )),
            Positioned.fill(
                child: Center(
              child: Label(
                  style: Styles.mediumText(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                  text:
                      'Get 20 L.E Cashback when you use Ride Service for the first Time'),
            )),
          ],
        ),
      ),
    );
  }
}
