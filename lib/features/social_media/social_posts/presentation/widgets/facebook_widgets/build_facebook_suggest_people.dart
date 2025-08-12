import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class BuildFacebookSuggestPeople extends StatefulWidget {
  const BuildFacebookSuggestPeople({
    super.key,
    required this.suggestedFriends
  });
  final List<SuggestUserEntity> suggestedFriends;
  @override
  State<BuildFacebookSuggestPeople> createState() =>
      _BuildFacebookSuggestPeopleState();
}

class _BuildFacebookSuggestPeopleState
    extends State<BuildFacebookSuggestPeople> {
  TextEditingController messageController = TextEditingController();
  // late ScrollController _scrollController;
  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController = ScrollController()..addListener(_onScroll);
  // }
  //
  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 200) {
  //     context.read<SocialPostsCubit>().getSuggestedFriends();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      var cubit = context.read<SocialPostsCubit>();
      return Container(
        width: double.infinity,
        // margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.getFillColor(context),
          // border: Border(bottom: BorderSide(color: AppColors.BG_GRAY_COLOR,width: 6)),
        ),
        padding:
            const EdgeInsetsDirectional.only(start: 10, bottom: 16, top: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.groupIcon,
                          height: 18,
                          width: 24,
                          color: context.isDarkMode ? Colors.white : null,
                        ),
                        // const Icon(
                        //   Icons.group_rounded,
                        //   size: 24,
                        //   color: AppColors.black,
                        // ),
                        const Sizer(),
                        Text(
                          context.locale == Locales.english
                              ? 'People you may know'
                              : 'أشخاص قد تعرفهم',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.getTextColor(context),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  ClickableWidget(
                    onTap: () {
                      context.push(Routes.FacebookSuggestPeople);
                    },
                    child: Text( 
                      context.locale == Locales.english
                          ? 'See More'
                          : 'عرض الكل',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.getTextColor(context),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 244,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                        // controller: _scrollController,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => ClickableWidget(
                              onTap: () {
                                context.push(Routes.OTHERSACCOUNT,
                                    extra: widget.suggestedFriends[index].id);
                              },
                              child: Container(
                                width: 167,
                                // padding: const EdgeInsets.only(bottom: 10,left: 8,right: 8),
                                margin: const EdgeInsetsDirectional.only(
                                    end: 10, start: 1, bottom: 2, top: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded corners
                                  border: Border.all(
                                      color: context.isDarkMode
                                          ? Colors.white
                                          : Colors.transparent),
                                  color: AppColors.getFindFillColor(
                                      context), // White background for the entire container
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          image: widget.suggestedFriends[index]
                                              .profilePicture,
                                          fit: BoxFit
                                              .fill, // Ensures the image covers the area
                                          firstChar: widget.suggestedFriends[index].firstName[0].toUpperCase(),
                                            charPadding:5
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
                                            top: 4),
                                        // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? AppColors.fill_Color_DARK
                                              : Colors
                                                  .white, // White background
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(
                                                12), // Rounded bottom corners
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // User Name
                                            Text(
                                              "${widget.suggestedFriends[index].firstName} ${widget.suggestedFriends[index].lastName}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: AppColors
                                                      .getButtonPrimaryWhiteColor(
                                                          context)),
                                            ),
                                            // const SizedBox(height: 4), // Spacing
                                            // Mutual Friends Count
                                            widget.suggestedFriends[index]
                                                        .mutualFriendsCount ==
                                                    0
                                                ? Text(
                                                    context.isArabic
                                                        ? 'لا يوجد اصدقاء مشتركين'
                                                        : 'No Mutual Friends',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                        color: context
                                                                .isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                                .withOpacity(
                                                                    0.5)
                                                            : AppColors.black
                                                                .withOpacity(
                                                                    0.5)),
                                                  )
                                                : Text(
                                                    "${widget.suggestedFriends[index].mutualFriendsCount.toLocalizedArabic(context)} ${LocaleKeys.mutualFriend.localize}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                        color: context
                                                                .isDarkMode
                                                            ? AppColors
                                                                .whiteColor
                                                                .withOpacity(
                                                                    0.5)
                                                            : AppColors.black
                                                                .withOpacity(
                                                                    0.5)),
                                                  ),
                                            // const Spacer(),
                                            // Action Buttons
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                // Add Friend / Follow / Send Greet Message Button
                                                Expanded(
                                                  flex: 2,
                                                  child: ClickableWidget(
                                                    onTap: () async {
                                                      if (widget
                                                              .suggestedFriends[
                                                                  index]
                                                              .addedSuccessfully ==
                                                          false) {
                                                        var response = await context
                                                            .read<
                                                                SocialPostsCubit>()
                                                            .friendRequest(
                                                              context: context,
                                                              userId: widget
                                                                  .suggestedFriends[
                                                                      index]
                                                                  .id,
                                                            );
                                                        if (response == true) {
                                                          widget
                                                              .suggestedFriends[
                                                                  index]
                                                              .addedSuccessfully = true;
                                                          setState(() {});
                                                        }
                                                      } else if (widget
                                                                  .suggestedFriends[
                                                                      index]
                                                                  .addedSuccessfully ==
                                                              true &&
                                                          widget
                                                                  .suggestedFriends[
                                                                      index]
                                                                  .followSuccessfully ==
                                                              false) {
                                                        var response = await context
                                                            .read<
                                                                SocialPostsCubit>()
                                                            .followRequest(
                                                              context: context,
                                                              userId: widget
                                                                  .suggestedFriends[
                                                                      index]
                                                                  .id,
                                                            );
                                                        if (response == true) {
                                                          widget
                                                              .suggestedFriends[
                                                                  index]
                                                              .followSuccessfully = true;
                                                          setState(() {});
                                                        }
                                                      } else if (widget
                                                                  .suggestedFriends[
                                                                      index]
                                                                  .addedSuccessfully ==
                                                              true &&
                                                          widget
                                                                  .suggestedFriends[
                                                                      index]
                                                                  .followSuccessfully ==
                                                              true) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                              surfaceTintColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      214,
                                                                      5,
                                                                      5),
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
                                                                maxLines: null,
                                                                maxLength: 150,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText: LocaleKeys
                                                                      .greetMessage
                                                                      .localize,
                                                                  fillColor: AppColors
                                                                      .getFillColor(
                                                                          context),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                    color: AppColors
                                                                        .getFillColor(
                                                                            context),
                                                                  )),
                                                                  hintStyle: Styles
                                                                      .mediumText(
                                                                    color: AppColors
                                                                        .getTextColor(
                                                                            context),
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                ClickableWidget(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      SizedBox(
                                                                    width: 100,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Label(
                                                                        text: LocaleKeys
                                                                            .cancel
                                                                            .localize,
                                                                        style: Styles
                                                                            .headerText(
                                                                          color:
                                                                              AppColors.getTextColor(context),
                                                                        ),
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
                                                                      bool
                                                                          result =
                                                                          await cubit
                                                                              .sendGreetMessage(
                                                                        context:
                                                                            context,
                                                                        userId: widget
                                                                            .suggestedFriends[index]
                                                                            .id,
                                                                        message:
                                                                            messageController.text,
                                                                      );
                                                                      if (result ==
                                                                          true) {
                                                                        widget.suggestedFriends.removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.suggestedFriends[index].id);
                                                                        showSuccessMessage(
                                                                          context,
                                                                          LocaleKeys
                                                                              .messageSentSuccessfully
                                                                              .localize,
                                                                        );
                                                                      }
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            2),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppColors
                                                                          .getButtonPrimaryColor(
                                                                              context),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4),
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
                                                                        color: AppColors.getReversedTextColor(
                                                                            context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                              actionsAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 31,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: widget
                                                                    .suggestedFriends[
                                                                        index]
                                                                    .followSuccessfully ==
                                                                true
                                                            ? Border.all(
                                                                color: AppColors
                                                                    .getRedColor(
                                                                        context))
                                                            : null,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: widget
                                                                    .suggestedFriends[
                                                                        index]
                                                                    .addedSuccessfully ==
                                                                false
                                                            ? AppColors
                                                                .getButtonPrimaryWhiteColor(
                                                                    context)
                                                            : widget.suggestedFriends[index].addedSuccessfully ==
                                                                        true &&
                                                            widget
                                                                            .suggestedFriends[
                                                                                index]
                                                                            .followSuccessfully ==
                                                                        false
                                                                ? AppColors
                                                                    .getRedColor(
                                                                        context)
                                                                : Colors
                                                                    .transparent,
                                                      ),
                                                      child: Text(
                                                        widget
                                                                    .suggestedFriends[
                                                                        index]
                                                                    .addedSuccessfully ==
                                                                false
                                                            ? LocaleKeys
                                                                .addFriend
                                                                .localize
                                                            : widget.suggestedFriends[index].addedSuccessfully ==
                                                                        true &&
                                                            widget
                                                                            .suggestedFriends[
                                                                                index]
                                                                            .followSuccessfully ==
                                                                        false
                                                                ? LocaleKeys
                                                                    .follow
                                                                    .localize
                                                                : LocaleKeys
                                                                    .sendGreetMessage
                                                                    .localize,
                                                        style: TextStyle(
                                                          color: widget
                                                                      .suggestedFriends[
                                                                          index]
                                                                      .followSuccessfully ==
                                                                  true
                                                              ? AppColors
                                                                  .getRedColor(
                                                                      context)
                                                              : AppColors
                                                                  .getReversedTextColor(
                                                                      context),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: 4), // Spacing
                                                // Remove Button
                                                if (widget
                                                        .suggestedFriends[index]
                                                        .addedSuccessfully ==
                                                    false)
                                                  Expanded(
                                                    child: ClickableWidget(
                                                      onTap: () async {
                                                        bool data = await context
                                                            .read<
                                                                SocialPostsCubit>()
                                                            .removeSuggestUser(
                                                              context: context,
                                                              userId: widget
                                                                  .suggestedFriends[
                                                                      index]
                                                                  .id,
                                                            );
                                                        if (data == true) {
                                                          widget.suggestedFriends.removeAt(index);
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 31,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: context
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .PRIMARY_COLOR_DARK
                                                                : AppColors
                                                                    .whiteColor,
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .PRIMARY_COLOR_DARK)),
                                                        child: Text(
                                                          LocaleKeys
                                                              .deleteRequest
                                                              .localize,
                                                          style: TextStyle(
                                                            color: context
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : AppColors
                                                                    .PRIMARY_COLOR_DARK,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                            ),
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 8,
                            ),
                        itemCount: widget.suggestedFriends.length),
                  ),
                  if (cubit.isLoadingPeopleMore == true)
                    const Center(
                      child: CustomCircularProgressIndicator(),
                    ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
