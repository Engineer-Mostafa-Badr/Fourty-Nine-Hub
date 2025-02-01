import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/select_activity_view.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_colors_ballet.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_create_post.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_create_post_app_bar.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_create_post_header.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_media_card.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_options.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_search_friends.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_sheet_item.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/show_all_images.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import '../../../../../common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import '../../../../account_taps/privacy/domain/entities/privacy_status_enum.dart';
import '../cubit/create_post_cubit.dart';
import 'select_feeling_view.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key, required this.social});
  final String social;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();

    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
  final SheetController sheetController = SheetController();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreatePostCubit>();
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state.status == CreatePostStates.error) {}
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 40),
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    BuildCreatePostAppBar(
                      onTap: (){
                        controller.createPost(
                            context: context, type: widget.social);
                      },
                    ),
                    const BuildCreatePostHeader(),
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () async {
                    //         final res = await CustomVerticalSheetItem.normal<
                    //             PrivacyStatus>(context, [
                    //           CustomSheetModel(
                    //             text: LocaleKeys.public.localize,
                    //             value: PrivacyStatus.public,
                    //             iconData: Icons.language,
                    //           ),
                    //           CustomSheetModel(
                    //             text: LocaleKeys.friends.localize,
                    //             value: PrivacyStatus.friends,
                    //             iconData: Icons.family_restroom,
                    //           ),
                    //           CustomSheetModel(
                    //             text: LocaleKeys.followers.localize,
                    //             value: PrivacyStatus.followers,
                    //             iconData: Icons.accessibility_sharp,
                    //           ),
                    //           CustomSheetModel(
                    //             text: LocaleKeys.friendsAndFollowers.localize,
                    //             value: PrivacyStatus.friendsAndFollowers,
                    //             iconData: Icons.supervised_user_circle_outlined,
                    //           ),
                    //           CustomSheetModel(
                    //             text: LocaleKeys.onlyMe.localize,
                    //             value: PrivacyStatus.onlyMe,
                    //             iconData: Icons.lock,
                    //           ),
                    //         ]);
                    //         print(res?.name);
                    //         print("============>");
                    //         controller.selectPrivacy(
                    //             privacy: res?.name ?? 'public');
                    //       },
                    //       child: Container(
                    //         margin: const EdgeInsetsDirectional.only(start: 10),
                    //         padding: const EdgeInsets.all(5),
                    //         decoration: BoxDecoration(
                    //           color: Colors.blue.withOpacity(0.3),
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //         child: Row(
                    //           children: [
                    //             Icon(
                    //               state.selectedPrivacy == 'onlyMe'
                    //                   ? Icons.lock
                    //                   : state.selectedPrivacy == 'friends'
                    //                       ? Icons.family_restroom
                    //                       : state.selectedPrivacy == 'followers'
                    //                           ? Icons.accessibility_sharp
                    //                           : state.selectedPrivacy ==
                    //                                   'friendsAndFollowers'
                    //                               ? Icons
                    //                                   .supervised_user_circle_outlined
                    //                               : Icons.language,
                    //               size: 16,
                    //             ),
                    //             const Sizer(),
                    //             Text(
                    //               state.selectedPrivacy == 'onlyMe'
                    //                   ? LocaleKeys.onlyMe.localize
                    //                   : state.selectedPrivacy == 'friends'
                    //                       ? LocaleKeys.friends.localize
                    //                       : state.selectedPrivacy == 'followers'
                    //                           ? LocaleKeys.followers.localize
                    //                           : state.selectedPrivacy ==
                    //                                   'friendsAndFollowers'
                    //                               ? LocaleKeys.friendsAndFollowers
                    //                                   .localize
                    //                               : LocaleKeys.public.localize,
                    //               style: Styles.mediumText(
                    //                 color: AppColors.AUTH_CONTAINER_COLOR,
                    //               ),
                    //             ),
                    //             const Sizer(),
                    //             Icon(
                    //               Icons.keyboard_arrow_down_outlined,
                    //               size: 30.sp,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    if (widget.social != 'twitter')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          children: [
                            if (state.selectedFeeling != null &&
                                state.selectedFeeling!.name.isNotEmpty)
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.onRemoveFeeling();
                                      },
                                      child: const Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w),
                                          child: Row(
                                            children: [
                                              Text(
                                                  '${LocaleKeys.feeling.localize} ',
                                                  style: Styles.mediumText(
                                                    color: AppColors
                                                        .AUTH_CONTAINER_COLOR,
                                                  )),
                                              Text(state.selectedFeeling!.name,
                                                  style: Styles.mediumText(
                                                    color: AppColors
                                                        .AUTH_CONTAINER_COLOR,
                                                  )),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            //Sizer(width: 10.w,),
                            if (state.selectedActivity != null &&
                                state.selectedActivity!.name.isNotEmpty)
                              Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.onRemoveActivity();
                                      },
                                      child: const Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            state.selectedActivity!.name,
                                            style: Styles.mediumText(),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (state.selectedUsers != null &&
                        state.selectedUsers!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Label(
                          text: '${LocaleKeys.withKey.localize}: ',
                          style: Styles.headerText(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Enable horizontal scrolling
                          child: Row(
                            children: [
                              Wrap(
                                direction: Axis.horizontal,
                                runSpacing: 10,
                                spacing: 10,
                                children: List.generate(
                                  state.selectedUsers!.length,
                                  (index) => GestureDetector(
                                    onTap: () {},
                                    child: BadgedLabel(
                                      label:
                                          state.selectedUsers?[index].fullName ??
                                              '',
                                      onRemove: () {
                                        controller.onRemoveUser(
                                            state.selectedUsers![index]);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const Sizer(),
                    BuildCreatePost(onChange: (c) {
                      if(c.isNotEmpty){
                        sheetController.collapse();
                      }
                      if (c.length > 80 &&
                          c.length < 120 &&
                          state.backColor != '#FFFFFFFF') {
                        controller.onBigger80();
                      } else if (c.length > 120 &&
                          c.length < 150 &&
                          state.backColor != '#FFFFFFFF') {
                        controller.onBigger120();
                      } else if (c.length > 150) {
                        controller.onBigger150();
                      } else {
                        controller.onSmallerText();
                      }
                      return controller.removeBackground();
                    }, controller: sheetController,),
                    // const Sizer(),
                    // if (widget.social != 'twitter' &&
                    //     (state.images == null || state.images!.isEmpty) &&
                    //     state.isBiggerThen150 == false)
                    //   const BuildColorsBallet(),
                    const Sizer(),
                    if (state.images != null && state.images!.isNotEmpty)
                      const Expanded(child: BuildMediaCard()),
                    // const Sizer(),
                    // BuildOptions(controller:controller,social:widget.social),
                  ],
                ),
                IgnorePointer(
                  ignoring: (sheetController.state?.currentScrollOffset ?? 0) > 0,
                  child: SnappingBottomSheet(
                    controller: sheetController,
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    shadowColor: Colors.black26,
                    elevation: 0,
                    maxWidth: MediaQuery.of(context).size.width ,
                    cornerRadius: 0,
                    closeOnBackdropTap: true,
                    padding: EdgeInsets.zero,
                    snapSpec: const SnapSpec(
                      snap: true,
                      initialSnap: 0.6,

                      snappings: [0.2, 0.8, 0.8],
                      positioning: SnapPositioning.relativeToAvailableSpace,
                    ),
                    body: Container(),
                    builder: (context, state) => Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 10.h,
                          margin: const EdgeInsets.only(bottom: 30),
                          color: Colors.white,
                          child: const Center(
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.black,
                            ),
                          )
                        ),
                        Divider(),
                        BuildSheetItem(icon: Assets.imageIcon,title: "Photo/video",
                            onTap: () async => await controller.uploadPhoto(context: context),
                            hasDivider:true),
                        BuildSheetItem(icon: Assets.tagIcon,title: "Tag people",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.feelingIcon,title: "Feeling/activity",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.locationIcon,title: "Check in",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.liveVideoIcon,title: "Live video",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.backgroundIcon,title: "Background color",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.cameraIcon,title: "Camera",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.gifIcon,title: "GIF",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.lifeEventIcon,title: "Life event",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.musicIcon,title: "Music",onTap: (){},hasDivider:true),
                        BuildSheetItem(icon: Assets.avatarIcon,title: "Your avatar",onTap: (){},hasDivider: false,),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
