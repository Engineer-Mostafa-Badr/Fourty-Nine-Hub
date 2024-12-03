import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../../../res/style/const.dart';
import '../../../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_state.dart';
import '../../../../../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

Future<void> showUpdateGoalsSheet(BuildContext context) async {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // Make background transparent for rounded effect
      isScrollControlled: true,
      // Allows the sheet to take more space
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9.h,
            // Adjust as needed
            maxChildSize: 1.h,
            minChildSize: 0.6.h,
            builder: (context, controller) {
              return SingleChildScrollView(
                child: Container(
                    constraints: BoxConstraints(
                      maxHeight: context.screenHeight / 1.18,
                    ),
                    padding:  EdgeInsets.all(30.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 52.r,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: ImageFromInternet(
                                  image: context
                                          .read<UserCubit>()
                                          .state
                                          .data!
                                          .profilePicture ??
                                      UIConst.imagePlaceHolder,
                                  width: 100.w,
                                  height: 100.h,
                                  isCircle: true,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(
                                    text:
                                        'moaz.official.com\'s LIVE',
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.headerText(fontSize: 65.sp),
                                    maxLines: 1,
                                  ),
                                  Label(
                                    text: 'Ends in 3:00:47',
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.mediumText(),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    FontAwesomeIcons.circleQuestion,
                                    color: AppColors.GREY_NORMAL_COLOR,
                                  ))
                            ],
                          ),
                          const Sizer(),
                          SizedBox(
                            height: 480.h,
                            child: Card(
                              color: AppColors.PRIMARY_COLOR,
                              elevation: 20,
                              child: Container(
                                height: 300.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(30.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Progress:',
                                            style: Styles.headerText(
                                                fontSize: 65.sp),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '0/3 Gifts',
                                            style: Styles.mediumText(),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 15.h,
                                          bottom: 20.h,
                                        ),
                                        child: Divider(
                                          color: Colors.grey[700],
                                          thickness: 2,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 300.h,
                                        child: GridView.builder(
                                          itemCount: 5,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 10.w,
                                            mainAxisSpacing: 10.h,
                                            childAspectRatio: 0.52,
                                          ),
                                          itemBuilder: (context, index) {
                                            final isLastInRow =
                                                (index + 1) % 3 == 0 ||
                                                    index == 4;

                                            return Row(
                                              children: [
                                                Expanded(child: _buildItem()),
                                                if (!isLastInRow)
                                                  VerticalDivider(
                                                    width: 10.w,
                                                    thickness: 2,
                                                    color: Colors.grey[900],
                                                    indent: 100.h,
                                                    endIndent: 100.h,
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Sizer(),
                          SizedBox(
                            height: 480.h,
                            child: Card(
                              color: AppColors.PRIMARY_COLOR,
                              elevation: 20,
                              child: Container(
                                height: 480.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(30.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contribution',
                                        style:
                                            Styles.headerText(fontSize: 65.sp),
                                      ),
                                      const Sizer(),
                                      Expanded(
                                        child: ListView.separated(
                                          itemBuilder: (context, index) => Row(
                                            children: [
                                              ImageFromInternet(
                                                image: context
                                                        .read<UserCubit>()
                                                        .state
                                                        .data!
                                                        .profilePicture ??
                                                    UIConst.imagePlaceHolder,
                                                width: 70.w,
                                                height: 70.h,
                                                isCircle: true,
                                              ),
                                              SizedBox(width: 20.w),
                                              Label(
                                                text: context
                                                    .read<UserCubit>()
                                                    .state
                                                    .data!
                                                    .fullName,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.mediumText(),
                                                maxLines: 1,
                                              ),
                                              const Sizer(),
                                            ],
                                          ),
                                          separatorBuilder: (context, index) =>
                                              const Sizer(),
                                          itemCount: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // BlocBuilder<StreamCubit, StreamState>(
                          //   builder: (context, state) {
                          //     return Container(
                          //       margin:
                          //           const EdgeInsets.symmetric(horizontal: 10),
                          //       padding: const EdgeInsets.all(10),
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //         color: Colors.white10,
                          //       ),
                          //       child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: List.generate(
                          //               state.selectedGifts.length,
                          //               (index) => Padding(
                          //                     padding: const EdgeInsets.symmetric(
                          //                         vertical: 15),
                          //                     child: Row(
                          //                       children: [
                          //                         SvgPicture.network(
                          //                             state.selectedGifts[index]
                          //                                 .picture!,
                          //                             height: 100.h,
                          //                             width: 100.w),
                          //                         Row(
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .spaceBetween,
                          //                           children: [
                          //                             Label(
                          //                                 text: context.isArabic
                          //                                     ? state
                          //                                         .selectedGifts[
                          //                                             index]
                          //                                         .nameAr!
                          //                                     : state
                          //                                         .selectedGifts[
                          //                                             index]
                          //                                         .nameEn!),
                          //                             RichText(
                          //                                 text: TextSpan(
                          //                                     text: '0',
                          //                                     style: TextStyle(
                          //                                         color: Colors
                          //                                             .yellow,
                          //                                         fontSize:
                          //                                             30.sp),
                          //                                     children: [
                          //                                   TextSpan(
                          //                                       text: '/',
                          //                                       style: TextStyle(
                          //                                         color: Colors
                          //                                             .white,
                          //                                         fontSize: 30.sp,
                          //                                       )),
                          //                                   TextSpan(
                          //                                       text: state
                          //                                           .selectedGifts[
                          //                                               index]
                          //                                           .currentValue
                          //                                           .toString(),
                          //                                       style: TextStyle(
                          //                                           color: Colors
                          //                                               .white,
                          //                                           fontSize:
                          //                                               30.sp))
                          //                                 ]))
                          //                           ],
                          //                         )
                          //                       ],
                          //                     ),
                          //                   ))),
                          //     );
                          //   },
                          // )
                        ])),
              );
            });
      });
}

Widget _buildItem() => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageFromInternet(
          image:
              'https://th.bing.com/th?id=OIP.UznDEOEWJftccLROzqmM5wHaIL&w=237&h=262&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2',
          width: 100.w,
          height: 100.h,
          isCircle: true,
        ),
        Sizer(
          height: 5.h,
        ),
        Text(
          'Lion',
          style: Styles.mediumText(),
        ),
        const Sizer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/coin.png',
              width: 30.w,
              height: 30.h,
            ),
            Sizer(
              width: 5.h,
            ),
            Text(
              '200000',
              style: Styles.mediumText(),
            ),
          ],
        ),
        Sizer(
          height: 10.h,
        ),
        Text(
          '0/1',
          style: Styles.mediumText(),
        ),
        Sizer(height: 40.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 5.h),
          decoration: BoxDecoration(
              color: Colors.red.shade500,
              borderRadius: BorderRadius.circular(12.r)),
          child: Text(
            'Send',
            style: Styles.mediumText(color: AppColors.AUTH_CONTAINER_COLOR),
          ),
        )
      ],
    );
