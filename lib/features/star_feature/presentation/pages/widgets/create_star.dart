import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:video_player/video_player.dart';

class CreateStar extends StatefulWidget {
  const CreateStar({super.key});

  @override
  State<CreateStar> createState() => _CreateStarState();
}

class _CreateStarState extends State<CreateStar> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late List<VideoPlayerController> _videoControllers = [];
  var controllerStar;

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeVideoControllers(List<UploadFileEntity> videos) {
    // Dispose of any existing controllers
    for (var controller in _videoControllers) {
      controller.dispose();
    }

    // Initialize new controllers
    _videoControllers = videos.map((video) {
      return VideoPlayerController.file(File(video.file.path))
        ..initialize().then((_) {
          setState(() {}); // Refresh when video is initialized
        });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  BackAppBar(
        label: LocaleKeys.addStar.localize,
      ),
      body: BlocProvider(
        create: (BuildContext context) => serviceLocator<CreatePostCubit>(),
        child: BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (BuildContext context, photo) {
            final controller = context.read<CreatePostCubit>();
            return BlocProvider<StarCubit>(
              create: (BuildContext context) => serviceLocator(),
              child: BlocConsumer<StarCubit, StarState>(
                listener: (BuildContext context, state) {
                  if(state.status ==StarStates.uploadSuccess){
                    showSuccessMessage(context, LocaleKeys.publishSuccessfully.localize);
                   // context.read<CreatePostCubit>().clearSelectedImages();
                  //  context.read<StarCubit>().clearSelectedVideos();
                    setState(() {
                      titleController.clear();
                      descController.clear();
                      controller.selectedImages ==[];
                      context.read<StarCubit>().selectedVideo==null;
                    });
                  }
                  if(state.status ==StarStates.error){
                    showErrorMessage(context,  getFailureMessage(
                      state.failure!,
                      context,
                    ),);
                  }
                },
                builder: (BuildContext context, state) {
                  controllerStar = context.read<StarCubit>();


                  // Initialize video controllers based on state.videos
                  _videoControllers = state.video?.map((video) {
                    return VideoPlayerController.file(File(video.file.path))
                      ..initialize().then((_) {
                        setState(() {}); // Refresh when video is initialized
                      });
                  }).toList() ??[];
                  return Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: kToolbarHeight * 3,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 0.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // if (state.)
                                        //   const CircularProgressIndicator.adaptive(),
                                        // if (!state.isImageUploading)
                                        Image.asset(
                                          Assets.image,
                                          height: kToolbarHeight * .8,
                                        ),
                                        //   if (!state.isImageUploading)
                                        Row(
                                          children: [
                                            if(controllerStar.selectedVideo==null)
                                              Expanded(
                                              child: BadgedLabel(
                                                height: 70.h,
                                                label: LocaleKeys.addImages.localize,
                                                isBordered: true,
                                                style: Styles.mediumText(
                                                    color: AppColors.LIGHT_COLOR),
                                                color: AppColors.SECONDARY_COLOR,
                                                isCentered: true,
                                                close: false,
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    backgroundColor:
                                                    Theme.of(context).scaffoldBackgroundColor,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Wrap(
                                                        children: <Widget>[
                                                          ListTile(
                                                            leading:
                                                            const Icon(Icons.photo_library),
                                                            title: Text(
                                                              LocaleKeys.gallery.localize,
                                                            ),
                                                            onTap: () async {
                                                              Navigator.pop(context);
                                                              controller.uploadPhoto(
                                                                  isGallery: true);
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: const Icon(Icons.camera_alt),
                                                            title:
                                                            Text(LocaleKeys.camera.localize),
                                                            onTap: () async {
                                                              Navigator.pop(context);
                                                              controller.uploadPhoto(
                                                                  isGallery: false);
                                                              // await CompanyAdvertiseCubit.get(context)
                                                              //     .uploadPhoto(isGallery: false);
                                                              // Reload user data if needed
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            const Sizer(),
                                            if(controller.selectedImages ==null)
                                              Expanded(
                                              child: BadgedLabel(
                                                height: 70.h,
                                                label: 'Add Video',
                                                isBordered: true,
                                                style: Styles.mediumText(
                                                    color: AppColors.LIGHT_COLOR),
                                                color: AppColors.SECONDARY_COLOR,
                                                isCentered: true,
                                                close: false,
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    backgroundColor:
                                                    Theme.of(context).scaffoldBackgroundColor,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Wrap(
                                                        children: <Widget>[
                                                          ListTile(
                                                            leading:
                                                            const Icon(Icons.photo_library),
                                                            title: Text(
                                                              LocaleKeys.gallery.localize,
                                                            ),
                                                            onTap: () async {
                                                              Navigator.pop(context);
                                                              controllerStar.uploadVideo(
                                                                  isGallery: true);
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: const Icon(Icons.camera_alt),
                                                            title:
                                                            Text(LocaleKeys.camera.localize),
                                                            onTap: () async {
                                                              Navigator.pop(context);
                                                              controllerStar.uploadVideo(
                                                                  isGallery: false);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Label(
                                        //   text: LocaleKeys.addImagesDesc.localize,
                                        //   style: Styles.mediumText(
                                        //     color: context.isDarkMode
                                        //         ? AppColors.LIGHT_COLOR
                                        //         : AppColors.GREY_DARK_COLOR,
                                        //   ),
                                        //   textAlign: TextAlign.center,
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                                const Sizer(),
                                if (context.watch<CreatePostCubit>().selectedImages?.isNotEmpty ?? false)
                                  SizedBox(
                                    height: kToolbarHeight * 1,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final image = photo.images![index];
                                          return SizedBox(
                                            height: kToolbarHeight * 2,
                                            width: kToolbarHeight * 2,
                                            child: Stack(
                                              alignment:
                                                  AlignmentDirectional.topStart,
                                              children: [
                                                Positioned.fill(
                                                    child: Image.file(
                                                  fit: BoxFit.cover,
                                                  File(image.file.path),
                                                )),
                                                PositionedDirectional(
                                                  start: 5.w,
                                                  top: 0,
                                                  child: IconAppButton(
                                                    width: 35.w,
                                                    height: 35.h,
                                                    icon: Icons.close_sharp,
                                                    color: Colors.red,
                                                    backColor: Colors.white,
                                                    size: 25.w,
                                                    isCircle: true,
                                                    onPressed: () => showAreYouSure(
                                                        context: context,
                                                        title: LocaleKeys.alert.localize,
                                                        subTitle:
                                                        LocaleKeys.removeImage.localize,
                                                        action: () {
                                                          controller
                                                              .removePhoto(image);
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Sizer(),
                                        itemCount: photo.images?.length ?? 0),
                                  ),
                                if (context.watch<StarCubit>().selectedVideo?.isNotEmpty ?? false)
                                  SizedBox(
                                    height: 400.h,
                                    child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        final videoController = _videoControllers[index];
                                        return SizedBox(
                                          height: 400.h,
                                          width: double.infinity,
                                          child: Stack(
                                            alignment: AlignmentDirectional.topStart,
                                            children: [
                                              Positioned.fill(
                                                child: videoController.value.isInitialized
                                                    ? AspectRatio(
                                                  aspectRatio: videoController.value.aspectRatio,
                                                  child: VideoPlayer(videoController),
                                                )
                                                    : Center(child: CircularProgressIndicator()),
                                              ),
                                              PositionedDirectional(
                                                start: 5,
                                                top: 0,
                                                child: IconAppButton(
                                                  width: 70.w,
                                                  height: 70.h,
                                                  icon: Icons.close_sharp,
                                                  color: Colors.red,
                                                  backColor: Colors.white,
                                                  size: 50.sp,
                                                  isCircle: true,
                                                  onPressed: () => showAreYouSure(
                                                    context: context,
                                                    title: LocaleKeys.alert.localize,
                                                    subTitle: LocaleKeys.removeVideo.localize,
                                                    action: () {
                                                      setState(() {
                                                        _videoControllers[index].dispose();
                                                        state.video!.removeAt(index);
                                                        _videoControllers.removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>  SizedBox(width: 20.w),
                                      itemCount: state.video?.length ?? 0,
                                    ),
                                  ),
                              ],
                            ),
                            Sizer(),
                            buildTextField(
                                label: LocaleKeys.title.localize,
                                controller: titleController),
                            const Sizer(),
                            buildTextField(
                                label: LocaleKeys.desc.localize,
                                controller: descController),
                            Sizer(),
                            DefaultButton(
                                width: double.infinity,
                                label: LocaleKeys.publish.localize,
                                backgroundColor: AppColors.SECONDARY_COLOR,
                                onPressed: () {
                                  print(controller.selectedImages);
                                  if(formKey.currentState!.validate()) {
                                    if(controller.selectedImages !=null ||controllerStar.selectedVideo !=null) {
                                      context.read<StarCubit>().uploadStar(
                                          params: StarParams(
                                        title: titleController.text,
                                        mediaUrl:controllerStar.selectedVideo ?? controller.selectedImages,
                                        description: descController.text,
                                        type:controllerStar.selectedVideo==null? 'image' :'video',
                                      ));
                                    }else{
                                      showErrorMessage(context, LocaleKeys.enterImageOrVideo.localize);
                                    }
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: label),
          TextFormField(
            maxLines: null,
            controller: controller,
            //  onChanged: (v) => controller.title = v,
            style: Styles.headerText(fontSize: 55.sp),
            decoration: InputDecoration(
                fillColor: context.isDarkMode
                    ? AppColors.GREY_DARK_COLOR
                    : AppColors.LIGHT_COLOR,
                contentPadding: const EdgeInsets.all(5),
                hintText: label,
                hintStyle: Styles.mediumText(),
                prefix: Sizer(
                  width: 20.w,
                )),
            validator: (value) {
              if ((value == null || value.isEmpty)) {
                return LocaleKeys.required.localize;
              } else {
                return null;
              }
            },
          ),
        ],
      );
}
