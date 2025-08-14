import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CreatePostReelCompany extends StatefulWidget {
  const CreatePostReelCompany({super.key, required this.totalPrice});
  final num totalPrice;

  @override
  _CreatePostReelCompanyState createState() => _CreatePostReelCompanyState();
}

class _CreatePostReelCompanyState extends State<CreatePostReelCompany> {
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      _videoFile = File(pickedFile.path);
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    _videoPlayerController = VideoPlayerController.file(_videoFile!);
    _videoPlayerController!.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: true,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
        );
      });
    });
  }

  // Method to clean up video resources
  void _cleanUpVideoResources() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _videoPlayerController = null;
    _chewieController = null;
  }

  // Method to remove the video
  void _removeVideo() {
    setState(() {
      _cleanUpVideoResources();
      _videoFile = null;
    });
  }

  showSubscribeDialog(BuildContext context) {
    showCustomDialogTrip(
        context,
        Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.alert.localize,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
                context.isArabic
                    ? "هذه الخدمة ستكلف ${widget.totalPrice} ${'ج.م'}. هل تريد المتابعة؟"
                    : "This service will cost ${widget.totalPrice} ${"EGP"}. Do you want to proceed?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s16,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: context.isArabic ? 'إلغاء' : 'Close',
                    backColor: AppColors.SECONDARY_COLOR_DARK2,
                    onPressed: () {
                      ManageVibration.vibrate();
                      Navigator.of(context).pop();
                    }),
                const SizedBox(width: 16),
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: context.isArabic ? 'متابعة' : 'Continue',
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () async {
                      ManageVibration.vibrate();
                      Navigator.of(context).pop();
                      showLoadingDialog(context);
                      await context
                          .read<CreateCompanyAdCubit>()
                          .addPostCompanyAdvertise(
                            type: 'reel',
                            totalPrice: widget.totalPrice,
                            context: context,
                          );
                    }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.createPost.localize),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Video selection container
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        if (state.video == null ||
                            (state.video?.isEmpty ?? false)) {
                          showErrorMessage(
                              context,
                              context.isArabic
                                  ? 'يرجى اختيار فيديو'
                                  : 'Please select a video');
                        } else {
                          bool inArabic = context.isArabic;
                          showSubscribeDialog(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 32),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20.r)),
                        child: Label(text: LocaleKeys.save.localize),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  UploadFile().uploadVideo(
                      subCategoryId: Constants.companyAdsSubCategory,
                      onUploaded: (data) {
                        print("data.mediaId ${data.mediaId}");
                        print("data.file ${data.file}");
                        context
                            .read<CreateCompanyAdCubit>()
                            .onUploadVideo(data.mediaId);
                        setState(() {
                          _videoFile = File(data.file.path);
                          _initializeVideoPlayer();
                        });
                      },
                      context: context);
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_library, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Tap to select a video',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Video preview section
              if (_chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 600.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 600.h,
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: _chewieController?.aspectRatio ?? 0,
                            child: Chewie(controller: _chewieController!),
                          ),
                        ),
                        PositionedDirectional(
                          start: 20.w,
                          top: 15.h,
                          child: ClickableWidget(
                            onTap: () {
                              ManageVibration.vibrate();
                              _removeVideo();
                              context
                                  .read<CreateCompanyAdCubit>()
                                  .onRemoveVideo();
                            },
                            child: Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.close,
                                size: 30.w,
                                color: AppColors.SECONDARY_COLOR,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
