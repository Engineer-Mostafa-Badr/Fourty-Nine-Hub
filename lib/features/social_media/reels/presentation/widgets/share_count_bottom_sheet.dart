import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/comment_widget_insta.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/assets/assets.dart';
import 'components/social_widget.dart';
import 'send_to_bottom_sheet.dart';

class ShareCountBottomSheet extends StatelessWidget {
  final Reel? reel;

  const ShareCountBottomSheet({super.key, this.reel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor:
                          context.isDarkMode ? Colors.grey[900] : Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        side: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      builder: (context) {
                        return const SendToBottomSheet();
                      },
                    );
                  },
                  child: SvgPicture.asset(
                    Assets.searchCountBottom,
                    width: 25,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const Spacer(),
                Text(
                  context.isArabic ? 'أرسل إلى' : 'Send to',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3),
          const SendPersonWidget(),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SocialAndTextWidget(
                        onTap: () {},
                        text: context.isArabic ? 'إعادة النشر' : 'Repost',
                        icon: Assets.repostIcon,
                        backGroundColor: 0xffFACE15,
                      ),
                      SizedBox(width: 30.w),
                      SocialAndTextWidget(
                        onTap: () {},
                        text: context.isArabic ? 'واتساب' : 'Whatsapp',
                        icon: Assets.whatsIcon,
                        backGroundColor: 0xff25D366,
                      ),
                      SizedBox(width: 35.w),
                      SocialAndTextWidget(
                        onTap: () {},
                        text: context.isArabic ? 'حالة' : 'Status',
                        icon: Assets.whatsIcon,
                        backGroundColor: 0xff25D366,
                      ),
                      SizedBox(width: 35.w),
                      SocialAndTextWidget(
                        width: 33,
                        onTap: () {},
                        text: context.isArabic ? 'حالة' : 'Status',
                        icon: Assets.messengerIcon,
                        backGroundColor: 0xffF5F5F5,
                      ),
                      SizedBox(width: 35.w),
                      SocialAndTextWidget(
                        width: 55,
                        onTap: () {},
                        text: context.isArabic ? 'فيسبوك' : 'Facebook',
                        icon: Assets.faceIcon,
                        backGroundColor: 0,
                      ),
                      SizedBox(width: 35.w),
                      SocialAndTextWidget(
                        onTap: () {},
                        text: context.isArabic ? 'انستقرام' : 'instagram ',
                        icon: Assets.instagram,
                        backGroundColor: 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  child: Row(
                    children: [
                      OptionWidget(
                        onTap: () {
                          _showReportBottomSheet(context);
                        },
                        text: context.isArabic ? 'ابلاغ' : 'Report',
                        icon: Assets.reportSheet,
                      ),
                      SizedBox(width: 40.w),
                      // OptionWidget(
                      //   onTap: () {},
                      //   text: context.isArabic ? 'غير مهتم' : 'not interested',
                      //   icon: Assets.notIcon,
                      // ),
                      OptionWidget(
                        onTap: () {},
                        text: context.isArabic ? ' اضف للقصة' : 'Add to story',
                        icon: Assets.addStoryIcon,
                      ),
                      // OptionWidget(
                      //   onTap: () {},
                      //   text: context.isArabic ? ' ترقية' : 'promote',
                      //   icon: Assets.promoteIcon,
                      // ),
                      // OptionWidget(
                      //   onTap: () {},
                      //   text: context.isArabic ? ' كاست' : 'Cast',
                      //   icon: Assets.castIcon,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 31),
        ],
      ),
    );
  }

  Future<void> _showReportBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
          child: ReportView(
            id: '5',
            categoryId: '66684135dbb427ee42aa0141',
          ),
        );
      },
    );
  }
}

class OptionWidget extends StatelessWidget {
  final String text;
  final String icon;
  final Function()? onTap;
  const OptionWidget({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            icon,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}

class SocialAndTextWidget extends StatelessWidget {
  final String text;
  final String icon;
  final int backGroundColor;
  final Function()? onTap;
  final double? radius;
  final double? width;
  const SocialAndTextWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.backGroundColor,
    this.onTap,
    this.width,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SocialCommentWidget(
            width: width,
            radius: radius ?? 23,
            icon: icon,
            backGroundColor: backGroundColor,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}

class SocialCommentWidget extends StatelessWidget {
  final String icon;
  final int backGroundColor;
  final Color? color;
  final double? radius;
  final double? width;
  final void Function()? onTap;

  const SocialCommentWidget({
    super.key,
    required this.icon,
    required this.backGroundColor,
    this.color,
    this.onTap,
    this.radius,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Color(backGroundColor),
        child: SvgPicture.asset(
          icon,
          color: color,
          width: width,
        ),
      ),
    );
  }
}

class SendPersonWidget extends StatelessWidget {
  const SendPersonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLlsHCzHU2GndYsMJQscyixYSlDVggHDzbXtXSuEmLAc309Z-6e1TUhHJFCLCw40Kicw0'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    textAlign: TextAlign.center,
                    context.isArabic ? 'احمد\n محمد' : "AHMED\nMOHAMED",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xffD806DC),
                    child: SvgPicture.asset(Assets.inviteIcon),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.isArabic
                        ? "دعوة صديق \n للمحادثة"
                        : "invite friend \nto chat",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
