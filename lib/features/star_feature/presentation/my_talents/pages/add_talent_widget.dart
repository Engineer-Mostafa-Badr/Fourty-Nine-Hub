import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/pages.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../data/model/active_category_model.dart';
import '../../../domain/use_case/get_active_categories_use_case.dart';
import '../../presentation_exports.dart';

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

  // Category related
  List<ActiveCategory> _categories = [];
  ActiveCategory? _selectedCategory;
  bool _isLoadingCategories = false;

  // Loading states for media selection
  bool _isLoadingVideo = false;
  bool _isLoadingThumbnail = false;

  // Manual duration input
  int? _manualDuration;
  bool _showManualDurationInput = false;
  final TextEditingController _durationController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  bool _isUploading = false;
  String _uploadStatus = '';
  double _uploadProgress = 0.0;
  bool _preventDoubleSubmit = false;
  String? _currentUploadId;

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
                enabled: !_isUploading &&
                    !_isLoadingVideo &&
                    !_isLoadingThumbnail &&
                    !_preventDoubleSubmit,
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
                enabled: !_isUploading &&
                    !_isLoadingVideo &&
                    !_isLoadingThumbnail &&
                    !_preventDoubleSubmit,
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

              // Category Dropdown Section
              _buildSectionTitle(context.isArabic ? 'الفئة' : 'Category'),
              SizedBox(height: 8.h),
              _buildCategoryDropdown(),

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
                          fontSize: 24.sp,
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
                onPressed: (_isUploading || _preventDoubleSubmit)
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

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getFindFillColor(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _selectedCategory != null
              ? AppColors.getRedColor(context).withOpacity(0.5)
              : AppColors.getTextColor(context).withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: _isLoadingCategories
          ? Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.getRedColor(context),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    context.isArabic
                        ? 'جاري تحميل الفئات...'
                        : 'Loading categories...',
                    style: TextStyle(
                      color: AppColors.getTextColor(context).withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : DropdownButtonFormField<ActiveCategory>(
              decoration: InputDecoration(
                hintText: context.isArabic ? 'اختر فئة' : 'Select a category',
                hintStyle: TextStyle(
                  color: AppColors.getTextColor(context).withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
              initialValue: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem<ActiveCategory>(
                  value: category,
                  child: Text(
                    context.isArabic ? category.nameAr : category.nameEn,
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: _isUploading
                  ? null
                  : (ActiveCategory? newCategory) {
                      setState(() {
                        _selectedCategory = newCategory;
                      });
                    },
              validator: (value) {
                if (value == null) {
                  return context.isArabic
                      ? 'يرجى اختيار فئة'
                      : 'Please select a category';
                }
                return null;
              },
              dropdownColor: AppColors.getFindFillColor(context),
              style: TextStyle(
                color: AppColors.getTextColor(context),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.getTextColor(context).withOpacity(0.6),
              ),
            ),
    );
  }

  Widget _buildVideoSection() {
    return GestureDetector(
      onTap: (_isUploading || _preventDoubleSubmit)
          ? null
          : () {
              ManageVibration.vibrate();
              _pickVideo();
            },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
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
        child: _selectedVideo != null
            ? (_videoController?.value.isInitialized == true
                ? _buildAdaptiveVideoPlayer()
                : _buildVideoPreparingState())
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

  Widget _buildVideoLoadingIndicator() {
    return SizedBox(
      height: 220.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.getTextColor(context).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 48,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            context.isArabic ? 'تم اختيار الفيديو ✓' : 'Video Selected ✓',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          if (_videoController == null ||
              !_videoController!.value.isInitialized)
            Column(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.getRedColor(context),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.isArabic
                      ? 'جاري تحضير الفيديو...'
                      : 'Preparing video...',
                  style: TextStyle(
                    color: AppColors.getTextColor(context).withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildVideoPreparingState() {
    return SizedBox(
      height: 220.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.getRedColor(context),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              context.isArabic ? 'جاري تحضير الفيديو...' : 'Preparing video...',
              style: TextStyle(
                color: AppColors.getTextColor(context).withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return SizedBox(
      height: 220.h,
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
      onTap: (_isUploading || _preventDoubleSubmit)
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
                      onTap: (_isUploading || _preventDoubleSubmit)
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
    try {
      if (_videoController != null) {
        await _videoController!.dispose();
      }

      _videoController = VideoPlayerController.file(File(path));
      await _videoController!.initialize();

      if (mounted) {
        setState(() {});

        // Auto play and loop
        _videoController!.play();
        _videoController!.setLooping(true);
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       context.isArabic
        //           ? 'خطأ في تحميل الفيديو. يرجى المحاولة مرة أخرى.'
        //           : 'Error loading video. Please try again.',
        //     ),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        showErrorMessage(
          context,
          context.isArabic
              ? 'خطأ في تحميل الفيديو. يرجى المحاولة مرة أخرى.'
              : 'Error loading video. Please try again.',
        );

        // Reset video selection on error
        setState(() {
          _selectedVideo = null;
          _videoController = null;
        });
      }
    }
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
    // Prevent double submission
    if (_isUploading || _preventDoubleSubmit) {
      print("⚠️ Upload already in progress, ignoring duplicate request");
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    // Set prevention flag immediately
    _preventDoubleSubmit = true;

    // تحقق إضافي من الوصف
    final description = _descriptionController.text.trim();
    if (description.length < 3 || description.length > 1000) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(context.isArabic
      //         ? 'يجب أن يكون طول الوصف بين 3 و 1000 حرف'
      //         : 'Description length must be between 3-1000 characters'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      showErrorMessage(
        context,
        context.isArabic
            ? 'يجب أن يكون طول الوصف بين 3 و 1000 حرف'
            : 'Description length must be between 3-1000 characters',
      );
      _preventDoubleSubmit = false; // Reset flag on validation error
      return;
    }

    if (_selectedVideo == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //         context.isArabic ? 'يرجى اختيار فيديو' : 'Please select a video'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      showErrorMessage(
        context,
        context.isArabic ? 'يرجى اختيار فيديو' : 'Please select a video',
      );
      _preventDoubleSubmit = false; // Reset flag on validation error
      return;
    }

    if (_selectedThumbnail == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(context.isArabic
      //         ? 'يرجى اختيار صورة مصغرة'
      //         : 'Please select a thumbnail'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      showErrorMessage(
        context,
        context.isArabic
            ? 'يرجى اختيار صورة مصغرة'
            : 'Please select a thumbnail',
      );
      _preventDoubleSubmit = false; // Reset flag on validation error
      return;
    }

    if (_selectedCategory == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(context.isArabic
      //         ? 'يرجى اختيار فئة'
      //         : 'Please select a category'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      showErrorMessage(
        context,
        context.isArabic ? 'يرجى اختيار فئة' : 'Please select a category',
      );
      _preventDoubleSubmit = false; // Reset flag on validation error
      return;
    }

    // Check subscription first - for now skip subscription check
    // serviceLocator<SubscriptionController>().checkIfUserSubscribed(
    //   onSubscribed: () => _performUpload(),
    //   subCategoryId: Constants.tubeSubCategory,
    // );

    // Direct upload for testing
    _performUpload();
  }

  Future<void> _performUpload() async {
    // Double check to prevent multiple uploads
    if (_isUploading) {
      print("⚠️ Upload already in progress in _performUpload, aborting");
      return;
    }

    // Generate unique upload ID for tracking
    final uploadId = DateTime.now().millisecondsSinceEpoch.toString();
    _currentUploadId = uploadId;
    print("🆔 Starting new upload with ID: $uploadId");

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

      int? duration = await videoPickerHelper.getVideoDuration(_selectedVideo!);

      // إذا فشل في الحصول على المدة، استخدم المدة اليدوية أو قيمة افتراضية
      if (duration == null) {
        if (_manualDuration != null) {
          duration = _manualDuration!;
          print("📹 Using manual duration: ${duration}s");
        } else {
          // اعرض خيار للمستخدم لإدخال المدة يدوياً
          duration = await _showDurationInputDialog();
          if (duration == null) {
            _showError(context.isArabic
                ? 'يرجى إدخال مدة الفيديو'
                : 'Please enter video duration');
            return;
          }
        }
      }

      print("📹 Final video duration: ${duration}s");

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
        categoryId: _selectedCategory!.id, // إضافة categoryId
        videoDuration: duration, // إضافة duration المحسوبة
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
          print("❌ Upload failed for ID $uploadId: ${failure.toString()}");

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
          print("✅ Upload successful for ID $uploadId!");

          // Show success message with processing note
          showSuccessMessage(
              context,
              context.isArabic
                  ? 'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. البث المباشر أو ملف الفيديو غير جاهز بعد. يحتاج وقت ليصبح متاحاً للمستخدمين.'
                  : 'Video uploaded successfully!\n\nNote: Video is not currently available. The live stream or video file are not yet ready. It takes time before it becomes available to users.');

          // Clear form and navigate back
          _clearForm();
          Future.delayed(Duration(seconds: 4), () {
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
      print("🔄 Cleaning up upload ID: $uploadId");
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
          _uploadStatus = '';
          _preventDoubleSubmit = false; // Reset double submission prevention
          _currentUploadId = null; // Clear upload ID
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    showErrorMessage(context, message);
  }

  // Dialog لإدخال مدة الفيديو يدوياً
  Future<int?> _showDurationInputDialog() async {
    _durationController.clear();

    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.getFindFillColor(context),
          title: Text(
            context.isArabic ? 'إدخال مدة الفيديو' : 'Enter Video Duration',
            style: TextStyle(
              color: AppColors.getTextColor(context),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.isArabic
                    ? 'لم نتمكن من الحصول على مدة الفيديو تلقائياً. يرجى إدخال المدة بالثواني:'
                    : 'Unable to get video duration automatically. Please enter duration in seconds:',
                style: TextStyle(
                  color: AppColors.getTextColor(context).withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                ),
                decoration: InputDecoration(
                  hintText: context.isArabic ? 'مثال: 120' : 'Example: 120',
                  hintStyle: TextStyle(
                    color: AppColors.getTextColor(context).withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.getFindFillColor(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.getTextColor(context).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.getRedColor(context),
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                context.isArabic
                    ? 'تلميح: دقيقة واحدة = 60 ثانية'
                    : 'Tip: 1 minute = 60 seconds',
                style: TextStyle(
                  color: AppColors.getTextColor(context).withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: Text(
                context.isArabic ? 'إلغاء' : 'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final durationText = _durationController.text.trim();
                final duration = int.tryParse(durationText);

                if (duration != null && duration > 0 && duration <= 3600) {
                  // حفظ المدة للاستخدام المستقبلي
                  _manualDuration = duration;
                  Navigator.of(dialogContext).pop(duration);
                } else {
                  // عرض خطأ
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       context.isArabic
                  //           ? 'يرجى إدخال مدة صحيحة (1-3600 ثانية)'
                  //           : 'Please enter valid duration (1-3600 seconds)',
                  //     ),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                  showErrorMessage(
                    context,
                    context.isArabic
                        ? 'يرجى إدخال مدة صحيحة (1-3600 ثانية)'
                        : 'Please enter valid duration (1-3600 seconds)',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.getRedColor(context),
              ),
              child: Text(
                context.isArabic ? 'تأكيد' : 'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _durationController.clear();
    setState(() {
      _selectedVideo = null;
      _selectedThumbnail = null;
      _videoMediaId = null;
      _thumbnailMediaId = null;
      _selectedCategory = null;
      _manualDuration = null;
      _showManualDurationInput = false;
      _isLoadingVideo = false;
      _isLoadingThumbnail = false;
    });
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final getActiveCategoriesUseCase =
          serviceLocator<GetActiveCategoriesUseCase>();
      final result = await getActiveCategoriesUseCase(NoParams());

      result.fold(
        (failure) {
          print("Error loading categories: $failure");
          // Show error message to user if needed
        },
        (response) {
          setState(() {
            _categories = response.data.categories;
            _isLoadingCategories = false;
          });
        },
      );
    } catch (e) {
      print("Exception loading categories: $e");
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }
}
