import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../zoom/presentation/widgets/meeting_dialogue.dart';
import 'recharge_coins.dart';

class LiveCard extends StatefulWidget {
  const LiveCard({super.key});

  @override
  State<LiveCard> createState() => _LiveCardState();
}

class _LiveCardState extends State<LiveCard> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildLiveAppBar(),
      bottomNavigationBar: _buildGiftsWidget(),
      body: Stack(
        children: [
          Positioned.fill(child: Container()),
          Positioned(
              bottom: 20,
              left: 20,
              right: kToolbarHeight * 2,
              height: height / 3,
              child: _buildCommentsWidget()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildLiveAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ProfileImage(accountId: 0,userId: '',),
          const Sizer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: 'Mohamed Gamal',
                  style: Styles.mediumText(color: Colors.white),
                ),
                Label(
                  text: '❤️ 474',
                  style: Styles.mediumText(color: AppColors.GREY_LIGHT_COLOR),
                ),
              ],
            ),
          ),
          const Sizer(),
          AppButton(
              height: 25,
              label: 'Follow',
              padding: 10,
              radius: 20,
              icon: Icons.add,
              onPressed: () {
                context.push(Routes.LIVEView,
                    extra: ZegoArgs(
                      '123',
                      false,
                    ));
              }),
          const Sizer(),
          Row(
            children: [
              IconAppButton(
                icon: Icons.chair,
                color: Colors.white,
                onPressed: () {},
              ),
              const Sizer(
                width: 5,
              ),
              Label(
                text: '140 view',
                style: Styles.mediumText(color: Colors.white),
              ),
              const Sizer(
                width: 5,
              ),
              IconAppButton(
                icon: Icons.clear,
                color: Colors.white,
                onPressed: () => context.pop(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCommentsWidget() {
    return Container();
    // return ListView.builder(
    //     itemCount: 10,
    //     itemBuilder: (context, index) => const CommentCard(
    //           textColor: Colors.white,
    //         ));
  }

  Widget _buildGiftsWidget() {
    return Container(
      height: kToolbarHeight,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: AppColors.LIGHT_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Label(
                    text: 'Comment',
                    style: Styles.mediumText(color: Colors.white),
                  ),
                  const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const Sizer(),
          _buildActionButton(
              image: Assets.giftbox,
              label: 'Gift',
              onTap: () {
                bottomSheet(
                    context: context,
                    backColor: Colors.black87,
                    widget: Container());
              }),
          const Sizer(),
          _buildActionButton(
              image: Assets.coin,
              label: 'Recharge',
              onTap: () {
                bottomSheet(context: context, widget: const RechargeCoins());
              }),
          const Sizer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.share,
                color: Colors.white,
              ),
              const Sizer(
                height: 5,
              ),
              Label(
                text: 'Share',
                style: Styles.smallText(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required String image, required String label, required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 20,
          ),
          const Sizer(
            height: 5,
          ),
          Label(
            text: label,
            style: Styles.smallText(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
