import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import 'Icon_and_text_widget.dart';
import 'components/social_widget.dart';

class ShareCountBottomSheet extends StatefulWidget {
  const ShareCountBottomSheet({super.key});

  @override
  State<ShareCountBottomSheet> createState() => _ShareCountBottomSheetState();
}

class _ShareCountBottomSheetState extends State<ShareCountBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.search,
                  ),
                ),
                const Spacer(),
                Text(
                  context.isArabic ? 'أرسل إلى' : 'Send to',
                  style: TextStyle(
                    fontSize: 32.sp,
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
          SizedBox(height: 5.h),
          const SendPersonWidget(),
          SizedBox(height: 42.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
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
                      SizedBox(width: 35.w),
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
                        onTap: () {},
                        text: context.isArabic ? 'حالة' : 'Status',
                        icon: Assets.messengerIcon,
                        backGroundColor: 0xffF5F5F5,
                      ),
                      SizedBox(width: 35.w),
                      SocialAndTextWidget(
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
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OptionWidget(
                        onTap: () {},
                        text: context.isArabic ? 'ابلاغ' : 'Report',
                        icon: Assets.reportSheet,
                      ),
                      SizedBox(width: 40.w),
                      OptionWidget(
                        onTap: () {},
                        text: context.isArabic ? 'غير مهتم' : 'not interested',
                        icon: Assets.notIcon,
                      ),
                      SizedBox(width: 40.w),
                      OptionWidget(
                        onTap: () {},
                        text: context.isArabic ? ' اضف للقصة' : 'Add to story',
                        icon: Assets.addStoryIcon,
                      ),
                      SizedBox(width: 40.w),
                      OptionWidget(
                        onTap: () {},
                        text: context.isArabic ? ' ترقية' : 'promote',
                        icon: Assets.promoteIcon,
                      ),
                      SizedBox(width: 40.w),
                      OptionWidget(
                        onTap: () {},
                        text: context.isArabic ? ' كاست' : 'Cast',
                        icon: Assets.castIcon,
                      ),
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
          SvgPicture.asset(icon),
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
  const SocialAndTextWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.backGroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SocialWidget(
            icon: icon,
            backGroundColor: backGroundColor,
          ),
          const SizedBox(height: 5),
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

class SendPersonWidget extends StatelessWidget {
  const SendPersonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage("https://i.pravatar.cc/150?img=3"),
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
                  const SizedBox(height: 4),
                  Text(
                    context.isArabic ? '         "احمد"' : "AHMED",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    context.isArabic ? '         "محمد"' : "MOHAMED",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 30.w),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xffD806DC),
                    child: SvgPicture.asset(Assets.inviteIcon),
                  ),
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
