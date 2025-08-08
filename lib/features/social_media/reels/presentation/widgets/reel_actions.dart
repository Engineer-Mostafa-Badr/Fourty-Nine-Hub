import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/reel_entity.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class ReelActions extends StatelessWidget {
  final ReelEntity item;

  const ReelActions({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconAppButton(
          icon: Icons.favorite_border,
          onPressed: () {

      ManageVibration.vibrate();
          }, 
          size: 24,
          color: Colors.white,
        ),
        Label(
          text: item.numberOfLikes.toString(),
          style: Styles.mediumText(color: Colors.white),
        ),
        const Sizer(),
        IconAppButton(
          icon: Icons.comment,
          onPressed: () {

      ManageVibration.vibrate();
          },
          size: 24,
          color: Colors.white,
        ),
        Label(
            text: item.numberOfComments.toString(),
            style: Styles.mediumText(color: Colors.white)),
        const Sizer(),
        IconAppButton(
          icon: Icons.bookmark_outline,
          onPressed: () {

      ManageVibration.vibrate();
          },
          size: 24,
          color: Colors.white,
        ),
        Label(
            text: item.numberOfSaves.toString(),
            style: Styles.mediumText(color: Colors.white)),
        const Sizer(),
        IconAppButton(
          icon: FontAwesomeIcons.share,
          onPressed: () {

      ManageVibration.vibrate();
          },
          size: 24,
          color: Colors.white,
        ),
        Label(
            text: item.numberOfExplores.toString(),
            style: Styles.mediumText(color: Colors.white)),
        const Sizer(),
        InkWell(
          onTap: () {
      ManageVibration.vibrate();
            context.push(Routes.MUSICREELS);
          },
          child: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Image.asset(
              Assets.coin,
              height: 20.h,
            ),
          ),
        ),
        const Sizer(),
      ],
    );
  }
}