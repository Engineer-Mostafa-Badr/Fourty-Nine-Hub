import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import 'package:video_player/video_player.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/create_post/presentation/cubit/create_post_cubit.dart';
import '../../presentation_exports.dart';

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
    for (var controller in _videoControllers) {
      controller.dispose();
    }

    _videoControllers = videos.map((video) {
      return VideoPlayerController.file(File(video.file.path))
        ..initialize().then((_) {
          setState(() {});
        });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(
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
                  if (state.status == StarStates.uploadSuccess) {
                    showSuccessMessage(
                        context, LocaleKeys.publishSubmitted.localize);
                    setState(() {
                      titleController.clear();
                      descController.clear();
                      controller.selectedImages == [];
                      // context.read<StarCubit>().selectedVideo == null;
                    });
                  }
                  if (state.status == StarStates.error) {
                    showErrorMessage(
                      context,
                      getFailureMessage(
                        state.failure!,
                        context,
                      ),
                    );
                  }
                },
                builder: (BuildContext context, state) {
                  controllerStar = context.read<StarCubit>();
                  _videoControllers = state.videos?.map((video) {
                        return VideoPlayerController.file(File(video.file.path))
                          ..initialize().then((_) {
                            setState(() {});
                          });
                      }).toList() ??
                      [];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const AddTalentWidget(),
                  );

                  // return createStar(context, controller, photo, state);
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
