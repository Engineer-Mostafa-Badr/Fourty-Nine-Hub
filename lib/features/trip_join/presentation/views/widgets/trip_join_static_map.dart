import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class TripJoinStaticMap extends StatelessWidget {
  const TripJoinStaticMap({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          Assets.map,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
