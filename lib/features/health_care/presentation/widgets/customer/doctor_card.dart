import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.VISITADOCTORDETAILS),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.LIGHT_COLOR,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ProfileImage(
                  accountId: 0,
                  size: 25,
                ),
                const Sizer(),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(text: 'dr. ', style: Styles.mediumText()),
                          TextSpan(
                              text: 'Nader Noshy\n',
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Dermatologist',
                              style: Styles.mediumText(color: Colors.grey)),
                        ])),
                        const RatingStars(
                          rating: 2,
                        ),
                        Label(
                            text: 'Reviews from 365 visitors',
                            style: Styles.mediumText())
                      ],
                    ),
                  ],
                )),
                Row(
                  children: [
                    IconAppButton(
                      onPressed: () {},
                      isCircle: true,
                      backColor: AppColors.PRIMARY_COLOR,
                      color: Colors.white,
                      icon: Icons.call,
                    ),
                    const Sizer(),
                    IconAppButton(
                      onPressed: () {},
                      isCircle: true,
                      backColor: AppColors.PRIMARY_COLOR,
                      color: Colors.white,
                      icon: Icons.video_camera_front_outlined,
                    ),
                  ],
                )
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.userDoctor,
                ),
                Sizer(),
                Expanded(
                    child: ReadMoreLabel(
                  text: UIConst.placeholderText,
                  trimLines: 1,
                ))
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.attach_money_sharp,
                ),
                const Sizer(),
                Expanded(
                  child: Label(
                    text: 'Price: 50 L.E',
                    style: Styles.mediumText(),
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.chat,
                ),
                const Sizer(),
                Expanded(
                  child: Label(
                    text: 'Speaking: Arabic, English',
                    style: Styles.mediumText(),
                  ),
                )
              ],
            ),
            const Sizer(),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppButton(
                    backColor: AppColors.LIGHT_GRAY_COLOR,
                    textColor: Colors.black,
                    //  label: '${'Avaialble'.tr()} 3 pm :10 pm',
                    label: 'Available',
                    onPressed: () {},
                  ),
                ),
                const Sizer(),
                Expanded(
                  child: AppButton(
                    label: 'Book now',
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
