import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/bunny_video_uploader.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../routes/pages.dart';
import '../../domain/use_case/upload_my_star_use_case.dart';
import '../controller/star_cubit/star_cubit.dart';
import '../../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../common/functions/global/upload_file.dart';
import '../../../../core/constants/constants.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../helper/video_picker_helper.dart';

class AddTalentWidget extends StatefulWidget {
  const AddTalentWidget({super.key});

  @override
  State<AddTalentWidget> createState() => _AddTalentWidgetState();
}

class _AddTalentWidgetState extends State<AddTalentWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Media files
  File? _selectedThumbnail;
  File? _selectedVideo;
  VideoPlayerController? _videoController;

  // Media IDs from upload
  String? _thumbnailMediaId;
  String? _videoMediaId;

  final FocusNode _titleFocusNode = FocusNode();
  bool _isUploading = false;
  String _uploadStatus = '';
  double _uploadProgress = 0.0;

  // Create instance of Bunny uploader
  final BunnyVideoUploader _bunnyUploader = BunnyVideoUploader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode
          ? AppColors.Scaffold_Color_DARK
          : AppColors.BACKGROUND_COLOR,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              _buildSectionTitle(LocaleKeys.title.localize),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _titleController,
                enabled: !_isUploading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.emptyFieldNotValid.localize;
                  }
                  return null;
                },
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                ),
                decoration: InputDecoration(
                  hintText: context.isArabic
                      ? 'أدخل عنوان الفيديو'
                      : 'Enter video title',
                  hintStyle: TextStyle(
                    color: AppColors.getTextColor(context).withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.getFindFillColor(context),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.getTextColor(context).withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.getRedColor(context),
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
                focusNode: _titleFocusNode,
              ),

              // Description Field
              _buildSectionTitle(LocaleKeys.desc.localize),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _descriptionController,
                enabled: !_isUploading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.emptyFieldNotValid.localize;
                  }
                  return null;
                },
                maxLines: 4,
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                ),
                decoration: InputDecoration(
                  hintText: context.isArabic
                      ? 'أدخل وصف الفيديو'
                      : 'Enter video description',
                  hintStyle: TextStyle(
                    color: AppColors.getTextColor(context).withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.getFindFillColor(context),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.getTextColor(context).withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.getRedColor(context),
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Video Section
              _buildSectionTitle(context.isArabic ? 'الفيديو' : 'Video'),
              SizedBox(height: 8.h),
              _buildVideoSection(),

              SizedBox(height: 20.h),

              // Thumbnail Section
              _buildSectionTitle(
                  context.isArabic ? 'الصورة المصغرة' : 'Thumbnail'),
              SizedBox(height: 8.h),
              _buildThumbnailSection(),

              SizedBox(height: 20.h),

              // Upload progress indicator
              if (_isUploading) ...[
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.getFindFillColor(context),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.getRedColor(context).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: LinearProgressIndicator(
                          value: _uploadProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.getRedColor(context),
                          ),
                          minHeight: 6,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        _uploadStatus,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.getTextColor(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${(_uploadProgress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getRedColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // Publish button
              ElevatedButton(
                onPressed: _isUploading
                    ? null
                    : () async {
                        ManageVibration.vibrate();
                        await _handleSubmit();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isUploading
                      ? Colors.grey[300]
                      : AppColors.getRedColor(context),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                child: _isUploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            context.isArabic
                                ? 'جاري النشر...'
                                : 'Publishing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        LocaleKeys.publish.localize,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextColor(context),
      ),
    );
  }

  Widget _buildVideoSection() {
    return GestureDetector(
      onTap: _isUploading
          ? null
          : () {
              ManageVibration.vibrate();
              _pickVideo();
            },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: 200.h,
          maxHeight: 400.h, // Allow flexibility for vertical videos
        ),
        decoration: BoxDecoration(
          color: AppColors.getFindFillColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _selectedVideo != null
                ? AppColors.getRedColor(context).withOpacity(0.5)
                : AppColors.getTextColor(context).withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: _selectedVideo != null &&
                _videoController?.value.isInitialized == true
            ? _buildAdaptiveVideoPlayer()
            : _buildVideoPlaceholder(),
      ),
    );
  }

  Widget _buildAdaptiveVideoPlayer() {
    // Get video aspect ratio
    final aspectRatio = _videoController!.value.aspectRatio;
    final isVertical = aspectRatio < 1.0; // Portrait video
    final isSquare = (aspectRatio - 1.0).abs() < 0.1; // Nearly square

    // Calculate optimal height based on aspect ratio
    double containerHeight;
    if (isVertical) {
      // For vertical videos, use more height
      containerHeight = MediaQuery.of(context).size.width / aspectRatio;
      // Cap the height to prevent too tall videos
      containerHeight = containerHeight.clamp(250.h, 400.h);
    } else if (isSquare) {
      // For square videos
      containerHeight = MediaQuery.of(context).size.width * 0.8;
      containerHeight = containerHeight.clamp(200.h, 300.h);
    } else {
      // For horizontal videos
      containerHeight = 200.h;
    }

    return SizedBox(
      height: containerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player with proper aspect ratio
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
          ),

          // Gradient overlay for better UI visibility
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 1.0],
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),

          // Play/Pause button
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_videoController!.value.isPlaying) {
                    _videoController!.pause();
                  } else {
                    _videoController!.play();
                  }
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: _videoController!.value.isPlaying
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 36.w,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Top controls bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Video info
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVertical
                              ? Icons.stay_current_portrait
                              : Icons.stay_current_landscape,
                          color: Colors.white,
                          size: 14.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _getVideoDurationText(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Change video button
                  GestureDetector(
                    onTap: _isUploading
                        ? null
                        : () {
                            ManageVibration.vibrate();
                            _pickVideo();
                          },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.getRedColor(context),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.swap_horiz_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom video progress bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Row(
                  children: [
                    // Current time
                    Text(
                      _getCurrentTimeText(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                    // Progress bar
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: VideoProgressIndicator(
                          _videoController!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: AppColors.getRedColor(context),
                            bufferedColor: Colors.white.withOpacity(0.3),
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    // Total duration
                    Text(
                      _getTotalTimeText(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return SizedBox(
      height: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.getTextColor(context).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.videocam_rounded,
              size: 48,
              color: AppColors.getTextColor(context).withOpacity(0.4),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            context.isArabic ? 'اضغط لاختيار فيديو' : 'Tap to select video',
            style: TextStyle(
              color: AppColors.getTextColor(context).withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            context.isArabic
                ? 'MP4, MOV, AVI • حتى 500 ميجا'
                : 'MP4, MOV, AVI • Up to 500MB',
            style: TextStyle(
              color: AppColors.getTextColor(context).withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

// Helper methods for video time display
  String _getVideoDurationText() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      final duration = _videoController!.value.duration;
      return _formatDuration(duration);
    }
    return '0:00';
  }

  String _getCurrentTimeText() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      final position = _videoController!.value.position;
      return _formatDuration(position);
    }
    return '0:00';
  }

  String _getTotalTimeText() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      final duration = _videoController!.value.duration;
      return _formatDuration(duration);
    }
    return '0:00';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildThumbnailSection() {
    return GestureDetector(
      onTap: _isUploading
          ? null
          : () {
              ManageVibration.vibrate();
              _pickThumbnail();
            },
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.getFindFillColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _selectedThumbnail != null
                ? AppColors.getRedColor(context).withOpacity(0.5)
                : AppColors.getTextColor(context).withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: _selectedThumbnail != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      _selectedThumbnail!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Change image button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _isUploading
                          ? null
                          : () {
                              ManageVibration.vibrate();
                              _pickThumbnail();
                            },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.getRedColor(context),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: AppColors.getTextColor(context).withOpacity(0.4),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    context.isArabic
                        ? 'اضغط لاختيار صورة'
                        : 'Tap to select thumbnail',
                    style: TextStyle(
                      color: AppColors.getTextColor(context).withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickThumbnail() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedThumbnail = File(image.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
      });
      await _initializeVideo(video.path);
    }
  }

  Future<void> _initializeVideo(String path) async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }

    _videoController = VideoPlayerController.file(File(path));
    await _videoController!.initialize();

    setState(() {});

    // Auto play and loop
    _videoController!.play();
    _videoController!.setLooping(true);
  }

  // Future<void> _handleSubmit() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   if (_selectedVideo == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //             context.isArabic ? 'يرجى اختيار فيديو' : 'Please select a video'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   if (_selectedThumbnail == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(context.isArabic
  //             ? 'يرجى اختيار صورة مصغرة'
  //             : 'Please select a thumbnail'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   // Check subscription first
  //   serviceLocator<SubscriptionController>().checkIfUserSubscribed(
  //     onSubscribed: () => _performUpload(),
  //     subCategoryId: Constants.tubeSubCategory,
  //   );
  // }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // تحقق إضافي من الوصف
    final description = _descriptionController.text.trim();
    if (description.length < 3 || description.length > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.isArabic
              ? 'يجب أن يكون طول الوصف بين 3 و 1000 حرف'
              : 'Description length must be between 3-1000 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              context.isArabic ? 'يرجى اختيار فيديو' : 'Please select a video'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedThumbnail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.isArabic
              ? 'يرجى اختيار صورة مصغرة'
              : 'Please select a thumbnail'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check subscription first
    serviceLocator<SubscriptionController>().checkIfUserSubscribed(
      onSubscribed: () => _performUpload(),
      subCategoryId: Constants.tubeSubCategory,
    );
  }

  Future<void> _performUpload() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadStatus = context.isArabic ? 'بدء الرفع...' : 'Starting upload...';
    });

    try {
      // Validate files first
      final videoPickerHelper = VideoPickerHelper();

      // Get video duration first
      setState(() {
        _uploadStatus = context.isArabic
            ? 'جاري الحصول على معلومات الفيديو...'
            : 'Getting video information...';
      });

      final duration =
          await videoPickerHelper.getVideoDuration(_selectedVideo!);
      if (duration == null) {
        _showError(context.isArabic
            ? 'فشل في الحصول على مدة الفيديو'
            : 'Failed to get video duration');
        return;
      }

      print("📹 Video duration: ${duration}s");

      // Validate video
      final validation =
          await videoPickerHelper.validateVideoForUpload(_selectedVideo!);

      print("🔍 Video validation result: $validation");

      if (!(validation['isValid'] as bool)) {
        final errors = validation['errors'] as List<String>;
        _showError('Video validation failed: ${errors.join(', ')}');
        return;
      }

      // Show validation passed
      setState(() {
        _uploadStatus = context.isArabic
            ? 'الفيديو صالح للرفع...'
            : 'Video validated successfully...';
      });

      await Future.delayed(Duration(milliseconds: 500));

      final result = await _bunnyUploader.uploadCompleteVideo(
        context: context,
        title: _titleController.text,
        description: _descriptionController.text,
        videoFile: _selectedVideo!,
        thumbnailFile: _selectedThumbnail!,
        subCategoryId: Constants.tubeSubCategory,
        onStatusUpdate: (status) {
          setState(() {
            _uploadStatus = status;
          });
          print("📊 Status: $status");
        },
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
          });
          // Only print every 5% to reduce log spam
          if ((progress * 100).toInt() % 5 == 0) {
            print("📈 Progress: ${(progress * 100).toInt()}%");
          }
        },
      );

      result.fold(
        (failure) {
          print("❌ Upload failed: ${failure.toString()}");

          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));

          // String errorMessage;
          // if (failure is ServerFailure) {
          //   if (failure.statusCode == 401) {
          //     errorMessage = context.isArabic
          //         ? 'انتهت صلاحية الجلسة. يرجى إعادة المحاولة'
          //         : 'Session expired. Please try again';
          //   } else {
          //     errorMessage = context.isArabic
          //         ? 'خطأ في الخادم: ${failure.message}'
          //         : 'Server error: ${failure.message}';
          //   }
          // } else if (failure is UnknownFailure) {
          //   if (failure.error.contains('expired')) {
          //     errorMessage = context.isArabic
          //         ? 'انتهت صلاحية رفع الملف. يرجى إعادة المحاولة'
          //         : 'Upload session expired. Please try again';
          //   } else if (failure.error.contains('duration')) {
          //     errorMessage = context.isArabic
          //         ? 'فشل في الحصول على مدة الفيديو. يرجى إعادة المحاولة'
          //         : 'Failed to get video duration. Please try again';
          //   } else {
          //     errorMessage = context.isArabic
          //         ? 'فشل الرفع: ${failure.error}'
          //         : 'Upload failed: ${failure.error}';
          //   }
          // } else {
          //   errorMessage = context.isArabic
          //       ? 'حدث خطأ غير معروف'
          //       : 'An unknown error occurred';
          // }

          // _showError(errorMessage);
        },
        (success) {
          print("✅ Upload successful!");
          _showSuccess(context.isArabic
              ? 'تم رفع الفيديو بنجاح!'
              : 'Video uploaded successfully!');

          // Clear form and navigate back
          _clearForm();
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        },
      );
    } catch (e) {
      print("❌ Exception in _performUpload: $e");
      _showError(context.isArabic
          ? 'حدث خطأ غير متوقع: $e'
          : 'An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
          _uploadStatus = '';
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 8),
        action: SnackBarAction(
          label: context.isArabic ? 'إغلاق' : 'Close',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedVideo = null;
      _selectedThumbnail = null;
      _videoMediaId = null;
      _thumbnailMediaId = null;
    });
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    _descriptionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });
  }
}
