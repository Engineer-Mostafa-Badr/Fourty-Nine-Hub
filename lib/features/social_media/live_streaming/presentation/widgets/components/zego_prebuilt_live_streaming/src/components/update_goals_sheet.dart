import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../../../res/style/const.dart';
import '../../../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_state.dart';
import '../../../../../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

Future<void> showUpdateGoalsSheet(BuildContext context,
    {bool? showEdit = false,
    required Function(String id) onEdit,
    Function? editGift}) async {
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
        return BlocBuilder<StreamCubit, StreamState>(builder: (context, state) {
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
                      padding: EdgeInsets.all(30.w),
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
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
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
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Label(
                                        text: 'Edit Live Goal',
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Styles.headerText(fontSize: 65.sp),
                                        maxLines: 1,
                                      ),
                                      Label(
                                        text: 'Ends in 3:00:47',
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.mediumText(),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(30.w),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Manage your Goals:',
                                              style: Styles.headerText(
                                                  fontSize: 65.sp),
                                            ),
                                            const Spacer(),
                                            // Text(
                                            //   '0/${context.read<StreamCubit>().state.selectedGifts.length} Gifts',
                                            //   style: Styles.mediumText(),
                                            // ),
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
                                          child: ListView.builder(
                                            itemCount: context
                                                .read<StreamCubit>()
                                                .state
                                                .selectedGifts
                                                .length,
                                            // gridDelegate:
                                            //     SliverGridDelegateWithFixedCrossAxisCount(
                                            //   crossAxisCount: 3,
                                            //   crossAxisSpacing: 10.w,
                                            //   mainAxisSpacing: 10.h,
                                            //   childAspectRatio: 0.52,
                                            // ),
                                            itemBuilder: (context, index) {
                                              final isLastInRow =
                                                  (index + 1) % 3 == 0 ||
                                                      index == 4;

                                              return _buildItem(
                                                  context,
                                                  context
                                                      .read<StreamCubit>()
                                                      .state
                                                      .selectedGifts[index],
                                                  onEdit: onEdit);
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
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
                                          style: Styles.headerText(
                                              fontSize: 65.sp),
                                        ),
                                        const Sizer(),
                                        Expanded(
                                          child: ListView.separated(
                                            itemBuilder: (context, index) =>
                                                Row(
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Styles.mediumText(),
                                                  maxLines: 1,
                                                ),
                                                const Sizer(),
                                              ],
                                            ),
                                            separatorBuilder:
                                                (context, index) =>
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
      });
}

Widget _buildItem(BuildContext context, GiftData gift,
    {required Function(String id) onEdit}) {
  print("gift.showEdit${gift.showEdit}");
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SvgPicture.network(
        gift.picture!,
        width: 100.w,
        height: 100.h,
      ),
      // ImageFromInternet(
      //   image:
      //   gift.picture??'',
      //   width: 100.w,
      //   height: 100.h,
      //   isCircle: true,
      // ),
      Sizer(
        width: 10.h,
      ),
      Expanded(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.isArabic ? gift.nameAr ?? '' : gift.nameEn ?? '',
                    style: Styles.mediumText(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  '0/${gift.currentValue}',
                  style: Styles.mediumText(),
                ),
              ],
            ),
            const Sizer(),
            LinearProgressIndicator(
              value: 0 / (gift.currentValue ?? 1),
            ),
          ],
        ),
      ),
      Sizer(
        height: 10.h,
      ),

      Sizer(height: 5.h),
      IconButton(
          onPressed: () {
            // Navigator.of(context).push(createCustomTransitionRoute(
            //   MultiBlocProvider(providers: [
            //     BlocProvider(
            //         create: (context) =>
            //         serviceLocator<GiftsCubit>()..fetchGifts()),
            //   ], child: const SelectLiveGoalsScreen()),
            //   TransitionType.bottomToTop,
            // ));
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Form(
                  key: context.read<StreamCubit>().formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Update Goals',
                        style: Styles.headerText(),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: context.read<StreamCubit>().goalController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter goals quantity';
                          } else if (int.parse(value) <= 0) {
                            return 'Please enter valid goals quantity';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter Goals quantity',
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          print(
                              'state.liveCreateResponseEntity?.goals${context.read<StreamCubit>().state.liveCreateResponseEntity?.goals}');
                          print(context
                              .read<StreamCubit>()
                              .state
                              .liveCreateResponseEntity
                              ?.goals
                              .length);
                          print(context
                              .read<StreamCubit>()
                              .state
                              .liveCreateResponseEntity
                              ?.goals
                              .firstWhereOrNull((e) => e.giftId == gift.sId)
                              ?.id);

                          if (context
                              .read<StreamCubit>()
                              .formKey
                              .currentState!
                              .validate()) {
                            print(
                                "context.read<StreamCubit>().${context.read<StreamCubit>().goalController.text}");
                            context.read<StreamCubit>().editGoal(
                                gift.sId ?? '',
                                context
                                    .read<StreamCubit>()
                                    .goalController
                                    .text
                                    .trim());
                            context.read<StreamCubit>().goalController.clear();
                            context.pop();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50.w, vertical: 5.h),
                          decoration: BoxDecoration(
                              color: AppColors.PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Text(
                            'save',
                            style: Styles.mediumText(
                                color: AppColors.AUTH_CONTAINER_COLOR),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          icon: const Icon(Icons.edit_off_sharp)),
    ],
  );
}
