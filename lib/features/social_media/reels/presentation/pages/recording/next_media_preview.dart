import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_status_enum.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/upload_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/upload_video_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/shared/filter_utiles.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../routes/routes.dart';

class NextMediaPreview extends StatefulWidget {
  final String mediaId;
  final String mediaPath;
  final bool isImage;

  const NextMediaPreview({super.key, 
    required this.mediaId,
    required this.mediaPath,
    required this.isImage,
  });

  @override
  _MediaPreviewScreenState createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<NextMediaPreview> {
  VideoPlayerController? _videoController;
  final List<Filter> filters = FilterLibrary.filters;
  Filter? _selectedFilter;
  String? _croppedImagePath;
  var descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isImage) {
      _videoController = VideoPlayerController.file(File(widget.mediaPath))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(() {});
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ReelsCubit, ReelsState>(
          listener: (BuildContext context, state) {
            if(state.status == ReelsStates.uploadSuccess){
              showSuccessMessage(context, LocaleKeys.uploadSuccessfully.localize);
              context.pushReplacementNamed(Routes.REELS);
            }
          },
          builder: (BuildContext context, state) {
            final controller = context.read<ReelsCubit>();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 50.sp,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  widget.isImage
                      ? ColorFiltered(
                          colorFilter: _selectedFilter?.colorFilter ??
                              const ColorFilter.mode(
                                  Colors.transparent, BlendMode.multiply),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.height * .1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: FileImage(
                                  File(_croppedImagePath ?? widget.mediaPath),
                                ),
                              ),
                            ),
                          ),
                        )
                      : _videoController != null &&
                              _videoController!.value.isInitialized
                          ? SizedBox(
                              width: 200.w,
                              height: 200.h,
                              child: Center(
                                child: ColorFiltered(
                                  colorFilter: _selectedFilter?.colorFilter ??
                                      const ColorFilter.mode(Colors.transparent,
                                          BlendMode.multiply),
                                  child: AspectRatio(
                                    aspectRatio: 0.8,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                ),
                              ),
                            )
                          : const CircularProgressIndicator(),
                  const Sizer(),
                  TextFormField(
                    maxLines: 6,
                    controller: descController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: LocaleKeys.addDescription.localize,
                      hintStyle:
                          Styles.mediumText(color: AppColors.GREY_NORMAL_COLOR),
                    ),
                  ),
                  //  const Sizer(),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //       vertical: 10.h,
                  //       horizontal: 10.w
                  //   ),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8.r),
                  //     color: Colors.white12,
                  //   ),
                  //   child: Text('@ Mention',
                  //     style: Styles.mediumText(),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15.h,
                      bottom: 40.h,
                    ),
                    child: const Divider(
                      color: AppColors.GREY_NORMAL_COLOR,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
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
                      controller.selectPrivacy(privacy: res?.name ?? 'public');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        // color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            state.selectedPrivacy == 'onlyMe'
                                ? Icons.lock
                                : state.selectedPrivacy == 'friends'
                                    ? Icons.family_restroom
                                    : state.selectedPrivacy == 'followers'
                                        ? Icons.accessibility_sharp
                                        : state.selectedPrivacy ==
                                                'friendsAndFollowers'
                                            ? Icons
                                                .supervised_user_circle_outlined
                                            : Icons.language,
                            size: 50.sp,
                          ),
                          const Sizer(),
                          Expanded(
                            child: Text(
                              state.selectedPrivacy == 'onlyMe'
                                  ? LocaleKeys.onlyViewThisPost.localize
                                  : state.selectedPrivacy == 'friends'
                                      ? LocaleKeys.friendsViewThisPost.localize
                                      : state.selectedPrivacy == 'followers'
                                          ? LocaleKeys.followersViewThisPost.localize
                                          : state.selectedPrivacy ==
                                                  'friendsAndFollowers'
                                              ? LocaleKeys.friendsAndFollowersViewThisPost.localize
                                                  .localize
                                              : LocaleKeys.everyoneViewThisPost.localize,
                              maxLines: 2,
                              style: Styles.headerText(),
                            ),
                          ),
                          const Sizer(),
                          //  const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 30.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: buildContainer(
                          onTap: () {
                            print('Media Path: ${widget.mediaId}');
                            print('isImage: ${widget.isImage}');
                            if (widget.isImage == true) {
                              controller.uploadReel(
                                  params: UploadReelParams(
                                      images: [widget.mediaId],
                                      //audioMedia:'66ae56014894b5d4015bcb02',
                                      description: descController.text.isNotEmpty ? descController.text : null,
                                      ));
                            } else {
                              controller.uploadVideoReel(
                                  params: UploadVideoReelParams(
                                thumbnailMediaId: widget.mediaId,
                                    description: descController.text.isNotEmpty ? descController.text : null,
                              ));
                            }
                          },
                          color: AppColors.SECONDARY_COLOR,
                          textColor: AppColors.AUTH_CONTAINER_COLOR,
                          title: 'Post',
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_upward,
                                color: AppColors.AUTH_CONTAINER_COLOR,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                LocaleKeys.post.localize,
                                style: Styles.headerText(
                                    color: AppColors.AUTH_CONTAINER_COLOR,
                                    fontSize: 30),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildContainer(
      {required Function onTap,
      required Color color,
      required Color textColor,
      required String title,
      bool image = false,
      Widget? widget}) {
    final user = context.read<UserCubit>().state.data;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 70.h,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color),
        ),
        child: widget ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (image)
                  CircleAvatar(
                    radius: 30.w,
                    backgroundColor: Colors.blue,
                    child: ImageFromInternet(
                      image: user?.profilePicture ?? UIConst.profilePlaceHolder,
                      height: 50.h,
                      width: 50.w,
                      isCircle: true,
                    ),
                  ),
                if (image)
                  SizedBox(
                    width: 10.w,
                  ),
                Text(
                  title,
                  style: Styles.headerText(color: textColor, fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
      ),
    );
  }
}
