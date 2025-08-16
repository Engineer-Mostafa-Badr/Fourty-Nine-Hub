import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/localization/locales.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../core/widget/clickable_widget.dart';
import '../../cubit/social_posts_cubit.dart';
import 'image_from_internet.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/custom_show_dialog.dart';

class BuildPeopleYouMayKnow extends StatefulWidget {
  const BuildPeopleYouMayKnow({super.key});

  @override
  State<BuildPeopleYouMayKnow> createState() => _BuildPeopleYouMayKnowState();
}

class _BuildPeopleYouMayKnowState extends State<BuildPeopleYouMayKnow> {
  final messageController = TextEditingController();
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SocialPostsCubit>().getAllFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
        listener: (context, state) {
      if (state.status == StateStatus.error) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure ?? UnknownFailure(''),
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return controller.suggestedFriends.isEmpty
          ? const SizedBox.shrink()
          : Container(
              color: const Color(0xffD9D9D9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 5.h,
                    color: const Color(0xffD9D9D9),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // SvgPicture.asset(Assets.groupIcon),
                            Icon(
                              Icons.group_rounded,
                              size: 40.sp,
                              color: AppColors.black,
                            ),
                            const Sizer(),
                            Label(
                              text: context.locale == Locales.english
                                  ? 'People you may know'
                                  : 'أشخاص قد تعرفهم',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          // height: 325.h,
                          height: 380.h,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              // physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.suggestedFriends.length,
                              itemBuilder: (context, index) {
                                final item = controller.suggestedFriends[index];
                                return ClickableWidget(
                                  onTap: () {
                                    context.pushNamed(Routes.OTHERSACCOUNT,
                                        extra: controller
                                            .suggestedFriends[index].id);
                                  },
                                  child: Container(
                                    width: 350.w,
                                    // padding: const EdgeInsets.only(bottom: 10,left: 8,right: 8),
                                    margin: const EdgeInsetsDirectional.only(
                                        end: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          12), // Rounded corners
                                      // border: Border.all(color: AppColors.DIVIDER_GRAY_COLOR),
                                      color: Colors
                                          .white, // White background for the entire container
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Top Half: Profile Image
                                        Expanded(
                                          flex:
                                              3, // Takes half of the container height
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(
                                                  12), // Rounded top corners
                                            ),
                                            child: ImageFromInternet(
                                              image: item.profilePicture,
                                              fit: BoxFit
                                                  .fill, // Ensures the image covers the area
                                            ),
                                          ),
                                        ),
                                        // Bottom Half: White Container with Details and Buttons
                                        Expanded(
                                          flex:
                                              2, // Takes the other half of the container height
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 8,
                                                right: 8,
                                                top: 8),
                                            // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                            decoration: const BoxDecoration(
                                              color: Colors
                                                  .white, // White background
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(
                                                    12), // Rounded bottom corners
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                // User Name
                                                Label(
                                                  text:
                                                      "${item.firstName} ${item.lastName}",
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .PRIMARY_COLOR),
                                                ),
                                                const SizedBox(
                                                    height: 4), // Spacing
                                                // Mutual Friends Count
                                                Label(
                                                  text:
                                                      "${item.mutualFriendsCount} ${LocaleKeys.mutualFriend.localize}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      color: AppColors.black
                                                          .withOpacity(0.5)),
                                                ),
                                                const Spacer(),
                                                // Action Buttons
                                                Row(
                                                  children: [
                                                    // Add Friend / Follow / Send Greet Message Button
                                                    Expanded(
                                                      flex: 2,
                                                      child: ClickableWidget(
                                                        onTap: () async {
                                                          if (item.addedSuccessfully ==
                                                              false) {
                                                            var response =
                                                                await controller
                                                                    .friendRequest(
                                                              context: context,
                                                              userId: item.id,
                                                            );
                                                            if (response ==
                                                                true) {
                                                              item.addedSuccessfully =
                                                                  true;
                                                              setState(() {});
                                                            }
                                                          } else if (item
                                                                      .addedSuccessfully ==
                                                                  true &&
                                                              item.followSuccessfully ==
                                                                  false) {
                                                            var response =
                                                                await controller
                                                                    .followRequest(
                                                              context: context,
                                                              userId: item.id,
                                                            );
                                                            if (response ==
                                                                true) {
                                                              item.followSuccessfully =
                                                                  true;
                                                              setState(() {});
                                                            }
                                                          } else if (item
                                                                      .addedSuccessfully ==
                                                                  true &&
                                                              item.followSuccessfully ==
                                                                  true) {
                                                            showAnimatedDialog(
                                                              context,
                                                              AlertDialog(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .BACKGROUND_COLOR,
                                                                surfaceTintColor:
                                                                    AppColors
                                                                        .BACKGROUND_COLOR,
                                                                title: Label(
                                                                  text: LocaleKeys
                                                                      .enterGreetMessage
                                                                      .localize,
                                                                  style: Styles
                                                                      .headerText(),
                                                                ),
                                                                content:
                                                                    TextField(
                                                                  controller:
                                                                      messageController,
                                                                  maxLines:
                                                                      null,
                                                                  maxLength:
                                                                      150,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText: LocaleKeys
                                                                        .greetMessage
                                                                        .localize,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    hintStyle:
                                                                        Styles
                                                                            .mediumText(
                                                                      color: AppColors
                                                                          .DARK_GRAY_COLOR,
                                                                    ),
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              AppColors.PRIMARY_COLOR,
                                                                        ),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Label(
                                                                        text: LocaleKeys
                                                                            .cancel
                                                                            .localize,
                                                                        style: Styles
                                                                            .headerText(
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ClickableWidget(
                                                                    onTap:
                                                                        () async {
                                                                      if (messageController
                                                                          .text
                                                                          .isNotEmpty) {
                                                                        await controller
                                                                            .sendGreetMessage(
                                                                          context:
                                                                              context,
                                                                          userId:
                                                                              item.id,
                                                                          message:
                                                                              messageController.text,
                                                                        );
                                                                        controller.suggestedFriends.removeWhere((element) =>
                                                                            element.id ==
                                                                            controller.suggestedFriends[index].id);
                                                                        showSuccessMessage(
                                                                          context,
                                                                          LocaleKeys
                                                                              .messageSentSuccessfully
                                                                              .localize,
                                                                        );
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppColors
                                                                            .PRIMARY_COLOR,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Label(
                                                                        text: LocaleKeys
                                                                            .send
                                                                            .localize,
                                                                        style: Styles
                                                                            .headerText(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 31.h,
                                                          // width: 84.w,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: item.followSuccessfully ==
                                                                    true
                                                                ? Border.all(
                                                                    color: AppColors
                                                                        .PRIMARY_COLOR_DARK)
                                                                : null,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                            color: item.addedSuccessfully ==
                                                                    false
                                                                ? AppColors
                                                                    .PRIMARY_COLOR
                                                                : item.addedSuccessfully ==
                                                                            true &&
                                                                        item.followSuccessfully ==
                                                                            false
                                                                    ? AppColors
                                                                        .PRIMARY_COLOR_DARK
                                                                    : Colors
                                                                        .white,
                                                          ),
                                                          child: Label(
                                                            text: item.addedSuccessfully ==
                                                                    false
                                                                ? LocaleKeys
                                                                    .addFriend
                                                                    .localize
                                                                : item.addedSuccessfully ==
                                                                            true &&
                                                                        item.followSuccessfully ==
                                                                            false
                                                                    ? LocaleKeys
                                                                        .follow
                                                                        .localize
                                                                    : LocaleKeys
                                                                        .sendGreetMessage
                                                                        .localize,
                                                            style: TextStyle(
                                                              color: item.followSuccessfully ==
                                                                      true
                                                                  ? AppColors
                                                                      .PRIMARY_COLOR_DARK
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: 10), // Spacing
                                                    // Remove Button
                                                    if (item.addedSuccessfully ==
                                                        false)
                                                      Expanded(
                                                        child: ClickableWidget(
                                                          onTap: () async {
                                                            bool data =
                                                                await controller
                                                                    .removeSuggestUser(
                                                              context: context,
                                                              userId: item.id,
                                                            );
                                                            if (data == true) {
                                                              controller
                                                                  .suggestedFriends
                                                                  .removeWhere((e) =>
                                                                      e.id ==
                                                                      controller
                                                                          .suggestedFriends[
                                                                              index]
                                                                          .id);
                                                              setState(() {});
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.w),
                                                            height: 31.h,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(8
                                                                            .r),
                                                                color: AppColors
                                                                    .whiteColor,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .PRIMARY_COLOR_DARK)),
                                                            child: Label(
                                                              text: LocaleKeys
                                                                  .deleteRequest
                                                                  .localize,
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColors
                                                                    .PRIMARY_COLOR_DARK,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     context.pushNamed(Routes.FacebookSuggestPeople);
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Label(
                  //         text: LocaleKeys.viewAll.localize,
                  //         style: Styles.headerText(fontSize: 30),
                  //       ),
                  //       const Sizer(),
                  //       Icon(
                  //         Icons.arrow_forward_ios,
                  //         size: 28.w,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  const Sizer(),
                  Container(
                    width: double.infinity,
                    height: 5.h,
                    color: const Color(0xffD9D9D9),
                  ),
                ],
              ),
            );
    });
  }
}
