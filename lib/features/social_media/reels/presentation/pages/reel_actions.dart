import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments/show_comments_sheet.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../ads_feature/create_company_ad/presentation/pages/widgets/reel_post_content.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/explore_reels_cubit/reel_cubit.dart';
import '../widgets/components/unified_widget_view.dart';
import '../widgets/share_count_bottom_sheet.dart';
import 'audio_screen.dart';

class ReelActions extends StatefulWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const ReelActions({
    super.key,
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  @override
  State<ReelActions> createState() => _ReelActionsState();
}

class _ReelActionsState extends State<ReelActions> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            // textDirection: TextDirection.ltr,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const FullScreenWidget(),
                  _UserSection(reel: widget.reel),
                  const SizedBox(height: 12),
                  const CaptionWidget(),
                  const SizedBox(height: 2),
                  const TagWidget(),
                  const SizedBox(height: 6),
                  const SponsoredWidget(),
                  const SizedBox(height: 6),
                  const ShopNowButton(),
                  const SizedBox(height: 6),
                  const SongWidget(),
                  const SizedBox(height: 8),
//                  _AudioAndButtons(reel: widget.reel, width: width),
                ],
              ),
              Expanded(
                flex: 1,
                child: AdvancedTikTokReactionsColumn(
                  reel: widget.reel,
                  itemType: widget.itemType,
                  rotationController: widget.rotationController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopNowButton extends StatelessWidget {
  const ShopNowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: 280,
      height: 34,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(
          0xffFF3308,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.isArabic ? 'تسوق الان' : 'Shop now',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 5),
          Icon(
            size: 12,
            Icons.arrow_forward_ios,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class SponsoredWidget extends StatelessWidget {
  const SponsoredWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 25,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.7),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            context.isArabic ? 'برعاية' : 'sponsored',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SongWidget extends StatelessWidget {
  const SongWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.songIcon,
          ),
          const SizedBox(width: 5),
          Text(
            context.isArabic
                ? 'اسم الأغنية - فنان الأغنية'
                : "Song name - song artist",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        '#fyp #tag #tag #tag #tag #tag ',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CaptionWidget extends StatelessWidget {
  const CaptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        context.isArabic ? 'وصف الريل' : 'Caption of the post ',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FullScreenWidget extends StatelessWidget {
  const FullScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 35),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: SvgPicture.asset(
            Assets.fullScreenIcon,
          ),
        ),
        //     SizedBox(width: 10),
        Text(
          context.isArabic ? "الشاشة الكاملة" : "full screen",
          style: const TextStyle(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

/// Widget to display user avatar and information.
class _UserSection extends StatelessWidget {
  final Reel reel;

  const _UserSection({required this.reel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LocationReelsWidget(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const SizedBox(width: 10),
              // الصورة + زر الإضافة
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2), // سمك الإطار الأبيض
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=3',
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: -10,
                    right: -9,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Color(0xffFF3308),
                      child: Icon(
                        Icons.add,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const Sizer(),
              //     Container(
              //       margin: const EdgeInsets.only(top: 5),
              //       padding: const EdgeInsets.only(left: 10),
              //       child: GestureDetector(
              //         onTap: () {
              //           // setState(() {
              //           //   _isCollapsed = !_isCollapsed;
              //           // });
              //         },
              //         child: SizedBox(
              //           width: 0.7.sw,
              //           child: ReadMoreText(
              //             "Simple DescriptionSimple DescriptionSimple DescriptionSimple DescriptionSimple DescriptionSimple DescriptionSimple DescriptionSimple DescriptionSimple DescriptionSimple DescriptionSimple DescriptionSimple Description",
              //             trimLines: 1,
              //             colorClickableText: AppColors.PRIMARY_COLOR_DARK,
              //             trimMode: TrimMode.Line,
              //             trimCollapsedText: ' See more',
              //             trimExpandedText: ' Hide',
              //             // isExpandable: ,
              //             // isCollapsed: ValueNotifier(_isCollapsed),
              //             textScaler: TextScaler.noScaling,
              //             lessStyle: Styles.headerText(
              //               color: AppColors.PRIMARY_COLOR_DARK,
              //             ),
              //             moreStyle: Styles.headerText(
              //               fontSize: 30,
              //               color: AppColors.PRIMARY_COLOR_DARK,
              //             ),
              //             style: Styles.mediumText(color: Colors.white),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const Sizer(),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 8),
              //       child: Row(
              //         children: [
              //           Container(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 8, vertical: 3),
              //             decoration: BoxDecoration(
              //                 color: Colors.white.withOpacity(0.3),
              //                 borderRadius: BorderRadius.circular(30)),
              //             child: const Row(
              //               children: [
              //                 Icon(
              //                   FontAwesomeIcons.music,
              //                   size: 13,
              //                 ),
              //                 Sizer(),
              //                 Text(
              //                   "taleen-nabil • Original audio",
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(width: 8),
              Text(
                context.isArabic ? 'محمد احمد' : 'Mohamed Ahmed',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                // width: 78,
                // height: 25,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Color(
                    0xff333333,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.photoIcon),
                    SizedBox(width: 8.w),
                    Text(
                      context.isArabic ? 'صور' : 'photo ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6.h),
                width: 30.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xff20D5EC),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(Assets.checkIcon),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LocationReelsWidget extends StatelessWidget {
  const LocationReelsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: const EdgeInsets.all(12),
      width: 220,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            Assets.locationReel,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2),
              Text(
                'badrshein . هرم سقارة المدرج',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Text(
                context.isArabic ? "انظر العنوان" : "see address",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget to display the user's avatar.
class _UserAvatar extends StatefulWidget {
  final Reel reel;

  const _UserAvatar({required this.reel});

  @override
  State<_UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<_UserAvatar> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<SocialPostsCubit>();

    return Container(
      width: 90.h,
      height: 90.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.reel.user.story
              ? AppColors.PRIMARY_COLOR_DARK
              : Colors.transparent,
          width: 3,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (!serviceLocator<UserCubit>().isLoggedIn) {
            context.push(Routes.LOGIN);
          } else {
            context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              // radius: reel.user.profilePictureSignedUrl != null
              //     ? 70.h
              //     : 20.h, // Adjust based on item type if needed
              backgroundImage: widget.reel.user.profilePictureSignedUrl != null
                  ? CachedNetworkImageProvider(
                      widget.reel.user.profilePictureSignedUrl!)
                  : null,
              child: widget.reel.user.profilePictureSignedUrl == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            widget.reel.user.isSentRequest
                ? Container()
                : Positioned(
                    left: 0,
                    right: 0,
                    bottom: -5,
                    child: GestureDetector(
                      onTap: () async {
                        if (context.read<UserCubit>().isLoggedIn) {
                          if (widget.reel.user.areFriends == true) {
                          } else {
                            if (widget.reel.user.isSentRequest == true) {
                              var result = await controller.removeFriendRequest(
                                  context: context,
                                  userId: widget.reel.user.id);
                              if (result == true) {
                                widget.reel.user.isSentRequest = false;
                                setState(() {});
                              }
                            } else {
                              var result = await controller.friendRequest(
                                  context: context,
                                  userId: widget.reel.user.id);
                              if (result == true) {
                                widget.reel.user.isSentRequest = true;
                                setState(() {});
                              }
                            }
                          }
                        } else {
                          context.push(Routes.LOGIN);
                        }
                      },
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: const Center(
                            child: Icon(
                          Icons.add,
                          size: 13,
                        )),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

/// Widget to display the user's name and reel details.
class _UserInfo extends StatefulWidget {
  final Reel reel;

  const _UserInfo({required this.reel});

  @override
  State<_UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<_UserInfo> {
  String get _displayName => capitalizeAndSplit(
      '${widget.reel.user.firstName} ${widget.reel.user.lastName}');

  String get _displayReelName {
    final maxLength = (widget.reel.name.length * 0.75).round();
    return "${widget.reel.name.substring(0, maxLength)}...";
  }

  final bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SocialPostsCubit>();
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.push(Routes.LOGIN);
              } else {
                context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
              }
            },
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    _displayName,
                    overflow: TextOverflow.ellipsis,
                    textScaler: TextScaler.noScaling,
                    style: _nameTextStyle,
                  ),
                ),
                const Sizer(
                  width: 40,
                ),
                widget.reel.user.isFollowed
                    ? Container()
                    : GestureDetector(
                        onTap: () async {
                          if (context.read<UserCubit>().isLoggedIn) {
                            if (widget.reel.user.isFollowed == true) {
                              var result = await controller.unFollowRequest(
                                  context: context,
                                  userId: widget.reel.user.id);
                              if (result == true) {
                                widget.reel.user.isFollowed = false;
                                setState(() {});
                              }
                            } else {
                              var result = await controller.followRequest(
                                  context: context,
                                  userId: widget.reel.user.id);
                              if (result == true) {
                                widget.reel.user.isFollowed = true;
                                setState(() {});
                              }
                            }
                          } else {
                            context.push(Routes.LOGIN);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.white),
                              boxShadow: const [
                                BoxShadow(color: Colors.black, blurRadius: 30)
                              ]),
                          child: Text(
                            LocaleKeys.follow.localize,
                            style: Styles.mediumText(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                if (widget.reel.user.verified)
                  const Icon(
                    Icons.verified,
                    color: AppColors.PRIMARY_COLOR_DARK,
                    size: 25,
                  ),
              ],
            ),
          ),
          // _ReelDetails(name: _displayReelName, viewCount: reel.viewCount),
        ],
      ),
    );
  }

  TextStyle get _nameTextStyle => TextStyle(
        fontSize: 40.sp,
        color: Colors.white,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Colors.black,
          ),
        ],
      );
}

/// Widget to display reel name and view count.
class _ReelDetails extends StatelessWidget {
  final String name;
  final int viewCount;

  const _ReelDetails({
    required this.name,
    required this.viewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          style: _detailsTextStyle,
        ),
        const SizedBox(width: 16),
        FaIcon(
          FontAwesomeIcons.eye,
          size: 20,
          color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Text(
          viewCount.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          style: _detailsTextStyle,
        ),
      ],
    );
  }

  TextStyle get _detailsTextStyle => TextStyle(
        fontSize: 30.sp,
        color: Colors.white60,
        decoration: TextDecoration.none,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Colors.black,
          ),
        ],
      );
}

/// Widget to display audio information and associated buttons.
class _AudioAndButtons extends StatelessWidget {
  final Reel reel;
  final double width;

  const _AudioAndButtons({
    required this.reel,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.withOpacity(0.2),
      child: ScrollingText(text: reel.audio.audioName),
    );
  }
}

class AdvancedTikTokReactionsColumn extends StatelessWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const AdvancedTikTokReactionsColumn({
    super.key,
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  static double iconSize = 0.1.sw;
  static const TextStyle countTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
  static const List<Shadow> iconShadows = [
    Shadow(
      blurRadius: 10,
      color: Colors.black26,
      offset: Offset(0, 3),
    ),
  ];

  // SVG string for the comment icon
  static const String commentIconSvg = '''<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" viewBox="0 0 2048 1926" width="152" height="143" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="10" dy="10" stdDeviation="10" flood-color="black"/>
    </filter>
  </defs>

  <!-- Apply the shadow to the following paths -->
  <path transform="translate(1008,507)" d="m0 0h34l32 2 37 4 33 5 29 6 36 10 35 12 37 15 28 14 28 17 16 10 19 13 11 8 13 10 15 13 7 7 6 5 6 7 8 7 8 9 13 13 11 14 9 11 14 19 14 21 11 19 11 21 11 25 8 20 9 27 7 32 6 32 3 26v48l-3 28-5 29-7 28-12 36-13 31-8 16-11 21-13 21-16 23-13 18-11 14-12 14-22 24-40 40-8 7-16 15-8 7-10 9-14 11-18 14-14 10-16 12-16 11-14 10-15 10-17 11-44 28-29 17-19 11-28 15-21 10-17 5-8-1-8-5-4-5-3-8-2-14-1-17v-74l-1-2-15-2-41-3-27-3-36-6-40-8-40-10-36-12-31-12-18-8-24-12-24-14-20-12-12-8-19-14-15-13-13-12-8-7-29-29-7-8-9-11-14-19-11-17-10-17-8-16-9-19-10-26-10-30-7-30-4-26-3-27-1-22v-13l2-24 7-42 8-34 6-20 8-22 10-23 14-29 15-25 15-22 14-19 14-18 12-13 4-5h2l2-4h2l2-4 17-16 11-10 11-9 18-14 42-28 20-12 18-10 17-9 33-14 38-13 30-8 29-7 30-5 42-5z" fill="#F5F5F5" filter="url(#shadow)"/>

  <path transform="translate(1026,922)" d="m0 0 17 1 15 4 13 7 9 7 6 5 10 13 7 14 4 13 1 5v17l-4 19-9 17-9 11-12 9-12 6-12 4-11 2h-24l-15-4-16-8-11-9-7-8-7-11-5-11-3-11v-21l4-18 6-14 10-13 7-7 15-10 11-5 12-3z" fill="#1E1D29" filter="url(#shadow)"/>

  <path transform="translate(1281,923)" d="m0 0h24l12 3 13 5 14 9 8 7 9 13 5 10 3 9 3 15v16l-5 18-7 13-11 12-10 9-14 8-13 5-9 2h-22l-15-4-12-6-9-7-8-7-10-13-7-12-5-14-1-6v-15l3-15 8-17 8-11 9-10 13-9 12-5z" fill="#1E1D29" filter="url(#shadow)"/>

  <path transform="translate(757,923)" d="m0 0h19l14 3 16 8 11 8 14 14 8 14 4 11 2 16-1 14-5 17-9 15-11 13-13 9-12 6-21 5h-23l-12-3-16-8-10-8-9-10-8-14-5-13-2-10v-20l3-14 5-12 6-9 11-12 13-10 11-5 14-4z" fill="#1E1D29" filter="url(#shadow)"/>
</svg>

  ''';

  @override
  Widget build(BuildContext context) {
    final ReelsCubit reelsCubit = context.read<ReelsCubit>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Profile Icon with Plus Button (Follow)
        // Stack(
        //   alignment: Alignment.bottomCenter,
        //   children: [

        //     // Positioned(
        //     //   bottom: 0,
        //     //   child: Container(
        //     //     decoration: BoxDecoration(
        //     //       color: Colors.red,
        //     //       borderRadius: BorderRadius.circular(15),
        //     //       border: Border.all(color: Colors.white, width: 2),
        //     //     ),
        //     //     child: const Icon(Icons.add, color: Colors.white, size: 15),
        //     //   ),
        //     // ),
        //   ],
        // ).animate().scale(duration: 200.ms),
        // _buildReactionButton(
        //   iconWidget: Image.asset(Assets.giftBoxIcon, color: Colors.white, width: 30, height: 30,),
        //   count: '',
        //   onTap: () {
        //     if (!serviceLocator<UserCubit>().isLoggedIn) {
        //       context.push(Routes.LOGIN);
        //     } else {
        //       _showGiftBottomSheet(context);
        //     }
        //   },
        // ),
        SizedBox(
          height: 20,
        ),
        LiveWidget(),
        const SizedBox(height: 12),
        LoveButton(
          count: reel.likeCount.toString(),
          // onTap: () {
          //   if (!serviceLocator<UserCubit>().isLoggedIn) {
          //     context.push(Routes.LOGIN);
          //   } else {
          //     _handleLikeAction(context, reelsCubit);
          //   }
          // },
        ),

        const SizedBox(height: 15),

        // Comment Icon
        _buildReactionButton(
          iconWidget: SizedBox(
              child: SvgPicture.asset(
            Assets.comReelIcon,
          )),
          count: reel.commentCount.toString(),
          onTap: () {
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.push(Routes.LOGIN);
            } else {
              _handleCommentAction(
                context,
              );
            }
          },
        ),
        const SizedBox(height: 15),

        // Bookmark Icon

        // Share Icon (Reversed)
        _buildReactionButton(
          iconWidget: SvgPicture.asset(
            Assets.shareIcon,
            color: Colors.white,
            width: 25,
          ),
          count: reel.shareCount.toString(),
          isReversed: true,
          onTap: () {
            showModalBottomSheet(
              context: context,
              //     backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                side: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              builder: (context) {
                return ShareCountBottomSheet();
              },
            );
            // if (!serviceLocator<UserCubit>().isLoggedIn) {
            //   context.push(Routes.LOGIN);
            // } else {
            //   _handleShareAction(context, reel.videoMedia);
            // }
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildReactionButton(
                        mainAxisAlignment: MainAxisAlignment.center,
                        iconWidget: Icon(
                          Icons.report,
                          size: iconSize,
                          color: Colors.white,
                          shadows: iconShadows,
                        ),
                        count: LocaleKeys.report.localize,
                        onTap: () {
                          if (!serviceLocator<UserCubit>().isLoggedIn) {
                            context.push(Routes.LOGIN);
                          } else {
                            _showReportBottomSheet(context);
                          }
                        },
                      ),
                      const Sizer(),
                      _buildReactionButton(
                        mainAxisAlignment: MainAxisAlignment.center,
                        iconWidget: Icon(
                          Icons.bookmark,
                          size: iconSize,
                          color: reel.saveCount == 0
                              ? Colors.white
                              : Colors.yellowAccent,
                          shadows: iconShadows,
                        ),
                        count: LocaleKeys.save.localize,
                        onTap: () {
                          if (!serviceLocator<UserCubit>().isLoggedIn) {
                            context.push(Routes.LOGIN);
                          } else {
                            _handleSaveAction(context, reelsCubit);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        RotatingCircularButton(
          reel: reel,
          rotationController: rotationController,
        ),
        SizedBox(height: 20),
        SvgPicture.asset(
          Assets.volumeIcon,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Helper widget for building reaction buttons with scaling animation
  Widget _buildReactionButton(
      {required Widget iconWidget,
      required VoidCallback onTap,
      required String count,
      bool isReversed = false,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    final Widget animatedIcon = iconWidget.animate().scale(duration: 200.ms);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30)
        ]),
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            isReversed
                ? Directionality(
                    textDirection: TextDirection.rtl,
                    child: animatedIcon,
                  )
                : animatedIcon,
            Text(
              count,
              style: countTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLikeAction(BuildContext context, ReelsCubit cubit) async {
    log("LSdkjflskdjflskdjflsdf l");
    try {
      await cubit.likeReel(reel.id).then((_) {
        final response = cubit.state.likeReelResponse;
        if (response?.message == "Reel liked successfully") {
          reel.likeCount++;
        } else if (response?.message == "Reel unlike successfully") {
          // if (reel.likeCount > 0) reel.likeCount--;
          reel.likeCount--;
        }
      });

      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error liking reel: $e');
    }
  }

  Future<void> _handleCommentAction(
    BuildContext context,
    //  ReelsCubit cubit,
  ) async {
    try {
      await showCommentsBottomSheet(
        context,
        //  reel: reel,
      );
    } catch (e) {
      _showSnackBar(
        context,
        'Error showing comments: $e',
      );
    }
  }

  Future<void> _handleShareAction(BuildContext context, String videoUrl) async {
    await Share.share(
      videoUrl,
      subject: 'Check out this reel!',
    );
  }

  Future<void> _handleSaveAction(BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.saveReel(reel.id);
      final response = cubit.state.reelSaveResponse;
      if (response?.message == "saved successfully") {
        reel.saveCount++;
      } else if (response?.message == "unsaved successfully") {
        if (reel.saveCount > 0) reel.saveCount--;
      }
      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error saving reel: $e');
    }
  }

  Future<void> _showReportBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
          child: ReportView(
            id: reel.user.id,
            categoryId: '66684135dbb427ee42aa0141',
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class LiveWidget extends StatefulWidget {
  const LiveWidget({super.key});

  @override
  State<LiveWidget> createState() => _LiveWidgetState();
}

class _LiveWidgetState extends State<LiveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true); // بيرجع تاني عشان يدي تأثير مستمر

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // الدائرة الخارجية بإطار وردي
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3, color: Colors.pink),
          ),
          padding: const EdgeInsets.all(3),
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(Assets.maleUser), // استخدم صورتك هنا
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // النقطة البيضاء في المنتصف
        const Positioned(
          child: CircleAvatar(
            radius: 5,
            backgroundColor: Colors.white,
          ),
        ),

        // كلمة LIVE
        Positioned(
          bottom: -10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A rotating circular button widget for audio interaction
class RotatingCircularButton extends StatelessWidget {
  final Reel reel;
  final AnimationController rotationController;

  const RotatingCircularButton({
    super.key,
    required this.reel,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: RotationTransition(
        turns: rotationController,
        child: Container(
          width: 65.h,
          height: 65.h,
          decoration: BoxDecoration(
            color: reel.audio.audioPicture.isEmpty
                ? Colors.black
                : Colors.transparent,
            image: reel.audio.audioPicture.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(reel.audio.audioPicture),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  )
                : null,
          ),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 32.h),
                      SvgPicture.asset(Assets.dividerIcon),
                      SoundOptionBottomSheet(
                        onTap: () {
                          context.pushNamed(Routes.UseSoundScreen);
                        },
                        icon: Assets.useSoundIcon,
                        title: context.isArabic
                            ? 'استخدم هذا الصوت'
                            : 'Use this sound',
                      ),
                      SoundOptionBottomSheet(
                        onTap: () {},
                        icon: Assets.collabIcon,
                        title: context.isArabic ? 'تعاون' : 'Collab',
                      ),
                      SoundOptionBottomSheet(
                        onTap: () {},
                        icon: Assets.layoutIcon,
                        title: context.isArabic ? 'تَخطِيط' : 'layout',
                      ),
                      SoundOptionBottomSheet(
                        onTap: () {},
                        icon: Assets.mix,
                        title: context.isArabic ? 'بكرات مختلطة' : 'Mix Reel',
                      ),
                    ],
                  );
                },
              );
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Icon(
                    FontAwesomeIcons.music,
                    size: 30.w,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 1.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoundOptionBottomSheet extends StatelessWidget {
  const SoundOptionBottomSheet({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final String icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(icon),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}

class LoveButton extends StatefulWidget {
  final String count;
  final bool isReversed;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle? countTextStyle;

  const LoveButton({
    Key? key,
    required this.count,
    this.isReversed = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.countTextStyle,
  }) : super(key: key);

  @override
  State<LoveButton> createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton>
    with SingleTickerProviderStateMixin {
  bool isLoved = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.8)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.8, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_controller);

    _colorAnimation = ColorTween(begin: Colors.white, end: Colors.red)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleLove() {
    setState(() {
      isLoved = !isLoved;
    });

    _controller.forward(from: 0); // يشغل الأنيميشن من الأول
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleLove,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: widget.mainAxisAlignment,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    Icons.favorite,
                    color: isLoved ? _colorAnimation.value : Colors.white,
                    size: 34,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              widget.count,
              style:
                  widget.countTextStyle ?? const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
