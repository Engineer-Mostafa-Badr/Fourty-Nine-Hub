import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import 'view_followers_and_following.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../../domain/entities/profile_instagram_data_entity.dart';
import '../pages/followers_screen.dart';
import '../../../../../helpers/manage_vibration.dart';

class ValueAndTitleHeaderProfileInstagram extends StatelessWidget {
  const ValueAndTitleHeaderProfileInstagram({
    super.key,
    required this.value,
    required this.title,
    required this.index,
    required this.dataProfile,
  });

  final String value, title;
  final int index;
  final ProfileInstagramDataEntity dataProfile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        if (index == 0 || index == 1) {
          context.pushNamed(Routes.followersScreen,
              extra: FollowersScreenArguments(
                index: index,
                dataProfile: dataProfile,
              ));
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewFollowersAndFollowing(
                      otherId: '67bf629b82c3f5a684b4ebfb',
                      email: '',
                    )));
        // ViewFollowersAndFollowing(index: index, email: '');
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
