import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_drop_down.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_search_friends.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

class BuildCreatePostHeader extends StatelessWidget {
  const BuildCreatePostHeader(
      {super.key,
      required this.sheetController,
      required this.controller,
      required this.state});

  final SheetController sheetController;
  final CreatePostCubit controller;
  final CreatePostState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Container(
            width: 53,
            height: 53,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: AppColors.GREYBG),
            child: Center(
              child:ImageFromInternet(
                isCircle: true,
                image: UserCubit.to.state.data?.profilePicture??'',
                fit: BoxFit.cover,
              )
            ),
          ),
          const SizedBox(width: 10),

          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: UserCubit.to.state.data?.fullName ?? '',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR)),
                  if ((controller.state.selectedActivity != null &&
                          (controller.state.selectedActivity?.id.isNotEmpty ??
                              false)) ||
                      (controller.state.selectedFeeling != null &&
                          (controller.state.selectedFeeling?.id.isNotEmpty ??
                              false)) ||
                      (controller.state.place != null &&
                          (controller.state.place?.name.isNotEmpty ?? false)))
                    const WidgetSpan(child: Icon(Icons.remove)),
                  if (controller.state.selectedFeeling != null &&
                      (controller.state.selectedFeeling?.id.isNotEmpty ??
                          false))
                    TextSpan(
                      children: [
                        WidgetSpan(
                            child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              controller.state.selectedFeeling?.image ?? ''),
                          // child: Label(
                          //   text: item.image,
                          //   style: Styles.mediumText(),
                          // ),
                        )),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        TextSpan(
                            text: LocaleKeys.feeling.localize,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : AppColors.PRIMARY_COLOR)),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        TextSpan(
                            text: context.isArabic
                                ? controller.state.selectedFeeling?.name ?? ''
                                : controller.state.selectedFeeling?.nameEn ??
                                    '',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : AppColors.PRIMARY_COLOR))
                      ],
                    ),
                  if (controller.state.selectedActivity != null &&
                      (controller.state.selectedActivity?.id.isNotEmpty ??
                          false))
                    TextSpan(
                      children: [
                        WidgetSpan(
                            child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(controller.state
                                  .selectedActivity?.mainActivity?.image ??
                              ''),
                          // child: Label(
                          //   text: item.image,
                          //   style: Styles.mediumText(),
                          // ),
                        )),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        TextSpan(
                            text: context.isArabic
                                ? controller.state.selectedActivity
                                        ?.mainActivity?.name ??
                                    ''
                                : controller.state.selectedActivity
                                        ?.mainActivity?.nameEn ??
                                    '',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : AppColors.PRIMARY_COLOR)),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        TextSpan(
                            text: context.isArabic
                                ? controller.state.selectedActivity?.name ?? ''
                                : controller.state.selectedActivity?.nameEn ??
                                    '',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : AppColors.PRIMARY_COLOR))
                      ],
                    ),
                  if (state.selectedUsers != null &&
                      state.selectedUsers!.isNotEmpty)
                    TextSpan(children: [
                      const WidgetSpan(child: Sizer()),
                      TextSpan(
                          text: LocaleKeys.withKey.localize,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.GREY_DARK_COLOR)),
                      const WidgetSpan(child: Sizer()),
                      TextSpan(
                          text: state.selectedUsers?.first.fullName ?? '',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR)),
                      if ((state.selectedUsers?.length ?? 0) > 1)
                        WidgetSpan(
                            child: ClickableWidget(
                                onTap: () {
                                  sheetController.collapse();
                                  bottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      widget: BuildSearchFriends(
                                        controller:
                                            context.read<CreatePostCubit>(),
                                        onSelectUser: (user) => context
                                            .read<CreatePostCubit>()
                                            .selectUsers(user),
                                      ));
                                },
                                child: Text(
                                    context.isArabic
                                        ? "و ${(state.selectedUsers?.length ?? 0) - 1} أخرين"
                                        : " and ${(state.selectedUsers?.length ?? 0) - 1} others",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.LIGHT_BLUE))))
                    ]),
                  if (state.place != null &&
                      (state.place?.name.isNotEmpty ?? false))
                    TextSpan(children: [
                      const WidgetSpan(child: Sizer()),
                      TextSpan(
                          text: context.isArabic ? 'في' : 'at',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.GREY_DARK_COLOR)),
                      const WidgetSpan(child: Sizer()),
                      TextSpan(
                          text: state.place?.name ?? '',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR))
                    ]),
                ])),
                // Text(
                //   ''
                //       '${UserCubit.to.state.data?.fullName??''} '
                //       '${(controller.state.selectedActivity!=null||(controller.state.selectedActivity?.id.isNotEmpty??false)||controller.state.selectedFeeling!=null||(controller.state.selectedFeeling?.id.isNotEmpty??false)||controller.state.place!=null||(controller.state.place?.name.isNotEmpty??false))?" - ":''} '
                //       '${(controller.state.selectedFeeling!=null||(controller.state.selectedFeeling?.id.isNotEmpty??false))?"${LocaleKeys.feeling.localize} ${controller.state.selectedFeeling?.name}":''}',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                // ),
                const SizedBox(
                  height: 11,
                ),
                Wrap(
                  spacing: 5, // المسافة الأفقية بين العناصر
                  runSpacing: 8, // المسافة الرأسية بين الصفوف
                  children: [
                    InkWell(
                      onTap: () async {
                        sheetController.collapse();
                        final res =
                            await CustomVerticalSheetItem.normal<PrivacyStatus>(
                                context, [
                          CustomSheetModel(
                            text: LocaleKeys.public.localize,
                            value: PrivacyStatus.public,
                            iconData: Icons.language,
                          ),
                          CustomSheetModel(
                            text: LocaleKeys.friends.localize,
                            value: PrivacyStatus.friends,
                            iconData: Icons.family_restroom,
                          ),
                          CustomSheetModel(
                            text: LocaleKeys.followers.localize,
                            value: PrivacyStatus.followers,
                            iconData: Icons.accessibility_sharp,
                          ),
                          CustomSheetModel(
                            text: LocaleKeys.friendsAndFollowers.localize,
                            value: PrivacyStatus.friendsAndFollowers,
                            iconData: Icons.supervised_user_circle_outlined,
                          ),
                          CustomSheetModel(
                            text: LocaleKeys.onlyMe.localize,
                            value: PrivacyStatus.onlyMe,
                            iconData: Icons.lock,
                          ),
                        ]);
                        print(res?.name);
                        print("============>");
                        controller.selectPrivacy(
                            privacy: res?.name ?? 'public');
                      },
                      child: BuildDropDown(
                        icon: Assets.publicIcon,
                        text: state.selectedPrivacy == 'onlyMe'
                            ? LocaleKeys.onlyMe.localize
                            : state.selectedPrivacy == 'friends'
                                ? LocaleKeys.friends.localize
                                : state.selectedPrivacy == 'followers'
                                    ? LocaleKeys.followers.localize
                                    : state.selectedPrivacy ==
                                            'friendsAndFollowers'
                                        ? LocaleKeys
                                            .friendsAndFollowers.localize
                                        : LocaleKeys.public.localize,
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 5),
                    PopupMenuButton(
                      color: AppColors.getFindFillColor(context),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 'On',
                            onTap: () {
                              controller.onChangePublishInstaStatus(true);
                            },
                            child: Text(LocaleKeys.on.localize)),
                        PopupMenuItem(
                          value: 'Off',
                          onTap: () {
                            controller.onChangePublishInstaStatus(false);
                          },
                          child: Text(LocaleKeys.off.localize),
                        ),
                      ],
                      child: BuildDropDown(
                          icon: Assets.onInstaIcon,
                          text: controller.state.onInsta == true
                              ? LocaleKeys.on.localize
                              : LocaleKeys.off.localize,
                          width: 16,
                          height: 16),
                    ),
                    const SizedBox(width: 5),
                    PopupMenuButton(
                      color: AppColors.getFindFillColor(context),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'On',
                          onTap: () {
                            controller.onChangePublishTweetStatus(true);
                          },
                          child: Text(LocaleKeys.on.localize),
                        ),
                        PopupMenuItem(
                          value: 'Off',
                          onTap: () {
                            controller.onChangePublishTweetStatus(false);
                          },
                          child: Text(LocaleKeys.off.localize),
                        ),
                      ],
                      child: BuildDropDown(
                          icon: Assets.onTweetIcon,
                          text: controller.state.onTweet == true
                              ? LocaleKeys.on.localize
                              : LocaleKeys.off.localize,width: 14,height: 14,),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                // Dropdown Buttons
                // Row(
                //   children: [
                //     PopupMenuButton(itemBuilder: (context)=>[
                //       PopupMenuItem(
                //         value: 'On',
                //         onTap: (){
                //           controller.onChangePublishInstaStatus(true);
                //         },
                //         child: Text(LocaleKeys.on.localize)
                //       ),
                //       PopupMenuItem(
                //         value: 'Off',
                //         onTap: (){
                //           controller.onChangePublishInstaStatus(false);
                //         },
                //         child: Text(LocaleKeys.off.localize),
                //       ),
                //     ],
                //       child:
                //       BuildDropDown(icon:Assets.onInstaIcon,text: controller.state.onInsta==true?LocaleKeys.on.localize:LocaleKeys.off.localize,width: 10,height: 10),
                //     ),
                //     const SizedBox(width: 5),
                //     PopupMenuButton(itemBuilder: (context)=>[
                //       PopupMenuItem(
                //         value: 'On',
                //         onTap: (){
                //           controller.onChangePublishTweetStatus(true);
                //         },
                //         child: Text(LocaleKeys.on.localize),
                //       ),
                //       PopupMenuItem(
                //         value: 'Off',
                //         onTap: (){
                //           controller.onChangePublishTweetStatus(false);
                //         },
                //         child: Text(LocaleKeys.off.localize),
                //       ),
                //     ],
                //       child:
                //       BuildDropDown(icon:Assets.onTweetIcon,text: controller.state.onTweet==true?LocaleKeys.on.localize:LocaleKeys.off.localize),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
