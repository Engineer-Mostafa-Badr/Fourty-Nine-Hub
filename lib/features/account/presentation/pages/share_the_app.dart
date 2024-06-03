import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';

class ShareTheApp extends StatelessWidget {
  const ShareTheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: 'Share App',
          backColor: AppColors.PRIMARY_COLOR,
          iconColor: Colors.white,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    decoration:
                        const BoxDecoration(color: AppColors.PRIMARY_COLOR),
                  )),
                  Expanded(
                      child: Container(
                    decoration:
                        const BoxDecoration(color: AppColors.LIGHT_GRAY_COLOR),
                  )),
                ],
              ),
            ),
            Positioned.fill(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildRefrenceNumberWidget(),
                        const Sizer(),
                        _buildLinkWidget(),
                        const Sizer(),
                        _buildStatisticsWidget(),
                      ],
                    ),
                  ),
                  const Sizer(
                    height: 20,
                  ),
                  _buildShareChannelsWidget(),
                ],
              ),
            ))
          ],
        ));
  }

  Widget _buildRefrenceNumberWidget() {
    return Image.asset(Assets.share);
  }

  Widget _buildLinkWidget() {
    return Column(
      children: [
        const BadgedLabel(
            // height: kToolbarHeight,
            width: double.infinity,
            color: AppColors.GREY_NORMAL_COLOR,
            label: 'https://49hub.com/register?reference=300404004'),
        const Sizer(),
        AppButton(label: 'Share The App', onPressed: () {}),
      ],
    );
  }

  Widget _buildStatisticsWidget() {
    return Row(
      children: [
        Expanded(
            child: _buildStatisticsItem(
                color: AppColors.PRIMARY_COLOR,
                title: 'Users',
                subTitle: '240 user')),
        const Sizer(),
        Expanded(
            child: _buildStatisticsItem(
                color: AppColors.PRIMARY_COLOR,
                title: 'Balance',
                subTitle: '40 EGP')),
      ],
    );
  }

  Widget _buildStatisticsItem({
    required Color color,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Label(
            text: title,
            style: Styles.mediumText(color: Colors.white),
          ),
          Label(
            text: subTitle,
            style: Styles.mediumText(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildShareChannelsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
              child: Center(
            child: _buildShareChannelItem(
                label: 'Facebook',
                icon: FontAwesomeIcons.facebook,
                color: Colors.blue,
                onTap: () {}),
          )),
          Expanded(
              child: Center(
            child: _buildShareChannelItem(
                label: 'Instagram',
                icon: FontAwesomeIcons.instagram,
                color: Colors.purple,
                onTap: () {}),
          )),
          Expanded(
              child: Center(
            child: _buildShareChannelItem(
                label: 'WhatsApp',
                icon: FontAwesomeIcons.whatsapp,
                color: Colors.green,
                onTap: () {}),
          )),
          Expanded(
              child: Center(
            child: _buildShareChannelItem(
                label: 'Twitter',
                icon: FontAwesomeIcons.twitter,
                color: Colors.blue,
                onTap: () {}),
          )),
        ],
      ),
    );
  }

  Widget _buildShareChannelItem(
      {required String label,
      required IconData icon,
      required Color color,
      required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHistoryWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Label(
              text: 'Joined At',
              style: Styles.headerText(),
            )),
            TextButton(onPressed: () {}, child: const Label(text: 'See All'))
          ],
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _buildHistoryItemWidget(),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: 10),
      ],
    );
  }

  Widget _buildHistoryItemWidget() {
    return Row(
      children: [
        const ProfileImage(accountId: 0),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: 'Farouk Shahin',
              style: Styles.mediumText(fontWeight: FontWeight.bold),
            ),
            const Label(text: 'Joined At: 2024-05-29')
          ],
        ))
      ],
    );
  }
}
