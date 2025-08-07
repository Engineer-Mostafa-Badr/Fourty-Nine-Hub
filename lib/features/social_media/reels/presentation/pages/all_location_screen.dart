import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/assets/assets.dart';
import '../screen/widget/all_location_body.dart';
import '../../../../../helpers/manage_vibration.dart';

class AllLocationScreen extends StatelessWidget {
  const AllLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
      ManageVibration.vibrate();
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SvgPicture.asset(
              Assets.shareSoundIcon,
              color: context.isDarkMode ? Colors.white : Colors.black,
              width: 20,
            ),
          ),
        ],
      ),
      body: const AllLocationBody(),
    );
  }
}