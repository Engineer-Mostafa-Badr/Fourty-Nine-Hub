import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../../domain/entities/profile_instagram_data_entity.dart';
import '../pages/followers_screen.dart';

class ValueAndTitleHeaderProfileInstagram extends StatelessWidget {
  const ValueAndTitleHeaderProfileInstagram({
    super.key,
    required this.value,
    required this.title,
    required this.index, required this.dataProfile,
  });

  final String value, title;
  final int index;
  final ProfileInstagramDataEntity dataProfile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 0 || index == 1) {
          context.push(Routes.followersScreen, extra: FollowersScreenArguments(
            index: index,
            dataProfile: dataProfile,
          ));
        }
      },
      child: Column(
        children: [
          Label(
            text: value,
            style: Styles.headerText(fontSize: 32),
          ),
          const SizedBox(
            height: 6,
          ),
          Label(
            text: title,
            style: Styles.headerText(fontSize: 32),
          ),
        ],
      ),
    );
  }
}
