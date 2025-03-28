import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../routes/routes.dart';
import 'trip_option_widget.dart';

class NewTripJoinBody extends StatelessWidget {
  const NewTripJoinBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TripOptionWidget(
                imagePath: Assets.locationTripIcon,
                title: 'Captain\nShare',
                onTap: () {
                  context.push(Routes.captainShareScreen);
                },
              ),
              TripOptionWidget(
                imagePath: Assets.locationTripIcon,
                title: 'Trip Join',
                icon: Assets.car,
                onTap: () {},
              ),
              TripOptionWidget(
                imagePath: Assets.locationTripIcon,
                title: 'Pick me',
                onTap: () {},
                icon: Assets.pickMeImage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
