import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../routes/routes.dart';
import 'trip_option_widget.dart';

class NewTripJoinBody extends StatelessWidget {
  const NewTripJoinBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(Icons.arrow_back),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tripOption(Assets.locationTripIcon, 'Captain\nShare', () {
                context.push(Routes.captainShareScreen);
              }),
              tripOption(Assets.locationTripIcon, 'Pick me', () {}),
              tripOption(Assets.locationTripIcon, 'Trip Join', () {}),
            ],
          ),
        ],
      ),
    );
  }
}
