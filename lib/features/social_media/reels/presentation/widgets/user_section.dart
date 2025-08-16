import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'location_reels_widget.dart';
import '../../../../../res/assets/assets.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../../data/models/new_reels_model.dart';
import '../../../../../helpers/manage_vibration.dart';

class UserSection extends StatelessWidget {
  final Reel reel;

  const UserSection({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reel.location.isNotEmpty)
            GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                context.pushNamed(Routes.AllLocationScreen);
              },
              child: const LocationReelsWidget(),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 20),
                // InkWell(
                //   onTap: () {
                //     // if (!serviceLocator<UserCubit>().isLoggedIn) {
                //     //   context.read<PreloadBloc>().pauseTheVideo();
                //     //   context.pushNamed(Routes.LOGIN);
                //     // } else {
                //     //   context.pushNamed(Routes.OTHERSACCOUNT, extra: reel.user.id);
                //     // }
                //   },
                //   child: Stack(
                //     clipBehavior: Clip.none,
                //     children: [
                //       Container(
                //         padding: const EdgeInsets.all(2), // سمك الإطار الأبيض
                //         decoration: const BoxDecoration(
                //           color: Colors.white,
                //           shape: BoxShape.circle,
                //         ),
                //         child: const CircleAvatar(
                //           radius: 18,
                //           backgroundImage: NetworkImage(
                //             'https://i.pravatar.cc/150?img=3',
                //           ),
                //         ),
                //       ),
                //       const Positioned(
                //         bottom: -8,
                //         right: -9,
                //         child: CircleAvatar(
                //           radius: 11,
                //           backgroundColor: Color(0xffFF3308),
                //           child: Icon(
                //             Icons.add,
                //             size: 15,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

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
                // const SizedBox(width: 8),
                Text(
                  '${reel.user.firstName} ${reel.user.lastName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17.5,
                  ),
                ),
                const SizedBox(width: 8),

                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                //   // width: 78,
                //   // height: 25,
                //   decoration: const BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(6)),
                //     color: Color(
                //       0xff333333,
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       SvgPicture.asset(Assets.photoIcon),
                //       SizedBox(width: 8.w),
                //       Text(
                //         context.isArabic ? 'صور' : 'photo ',
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.w400,
                //           fontSize: 16,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                if (reel.user.verified) SizedBox(width: 8.w),
                if (reel.user.verified)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    width: 16.5,
                    height: 16.5,
                    decoration: const BoxDecoration(
                      color: Color(0xff20D5EC),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(Assets.checkIcon,
                          fit: BoxFit.fill, width: 14.w, height: 14.h),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
