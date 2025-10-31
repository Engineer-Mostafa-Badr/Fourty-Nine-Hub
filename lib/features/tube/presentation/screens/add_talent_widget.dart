import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/tube/domain/entities/get_active_category_entity.dart';
import 'package:fourtyninehub/features/tube/presentation/cubit/tube_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';
import '../../../../res/style/styles.dart';
import '../../../star_feature/presentation/shared/helpers/bunny_video_uploader.dart';

class AddTubeWidget extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final GlobalKey<FormState> formKey;

  const AddTubeWidget({
    super.key,
    required this.titleController,
    required this.descController,
    required this.formKey,
  });

  @override
  State<AddTubeWidget> createState() => _AddTubeWidgetState();
}

class _AddTubeWidgetState extends State<AddTubeWidget> {
  File? _selectedThumbnail;
  VideoPlayerController? _videoController;
  ActiveCategoryEntity? _selectedCategory;
  bool _isLoadingVideo = false;
  bool _isLoadingThumbnail = false;
  bool _isUploading = false;
  String _uploadStatus = '';
  double _uploadProgress = 0.0;
  bool _preventDoubleSubmit = false;
  final BunnyVideoUploader _bunnyUploader = BunnyVideoUploader();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await context.read<TubeCubit>().loadActiveCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TubeCubit, TubeState>(
      listener: (context, state) {
        if (state.uploadStatus == StateStatus.success && state.addFavoriteTubeData != null) {
          showSuccessMessage(
            context,
            context.isArabic
                ? 'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. يحتاج وقت ليصبح متاحاً للمستخدمين.'
                : 'Video uploaded successfully!\n\nNote: Video is not currently available. It takes time before it becomes available to users.',
          );
          _clearForm();
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        } else if (state.uploadStatus == StateStatus.error && state.failure != null) {
          // Improved error handling to show specific validation messages
          String errorMessage = getFailureMessage(state.failure!, context);
          if (state.failure is ServerFailure) {
            final serverFailure = state.failure as ServerFailure;
            if (serverFailure.name != null && serverFailure.name is List) {
              final errors = serverFailure.name as List;
              errorMessage = errors
                  .map((e) => e is Map && e['message'] != null
                  ? (context.isArabic ? e['message']['ar'] : e['message']['en'])
                  : errorMessage)
                  .join('\n');
            }
          }
          showErrorMessage(context, errorMessage);
          setState(() {
            _isUploading = false;
            _preventDoubleSubmit = false;
            _uploadStatus = '';
            _uploadProgress = 0.0;
          });
        }
      },
      child: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              _buildSectionTitle(LocaleKeys.title.localize),
              SizedBox(height: 8.h),
              TextFormField(
                controller: widget.titleController,
                enabled: !_isUploading && !_isLoadingVideo && !_isLoadingThumbnail,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.emptyFieldNotValid.localize;
                  }
                  return null;
                },
                style: TextStyle(color: AppColors.getTextColor(context)),
                decoration: InputDecoration(
                  hintText: context.isArabic ? 'أدخل عنوان الفيديو' : 'Enter video title',
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
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Description Field
              _buildSectionTitle(LocaleKeys.desc.localize),
              SizedBox(height: 8.h),
              TextFormField(
                controller: widget.descController,
                enabled: !_isUploading && !_isLoadingVideo && !_isLoadingThumbnail,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.emptyFieldNotValid.localize;
                  }
                  if (value.length < 3 || value.length > 1000) {
                    return context.isArabic
                        ? 'يجب أن يكون طول الوصف بين 3 و 1000 حرف'
                        : 'Description length must be between 3-1000 characters';
                  }
                  return null;
                },
                maxLines: 4,
                style: TextStyle(color: AppColors.getTextColor(context)),
                decoration: InputDecoration(
                  hintText: context.isArabic ? 'أدخل وصف الفيديو' : 'Enter video description',
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
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
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
              _buildSectionTitle(context.isArabic ? 'الصورة المصغرة' : 'Thumbnail'),
              SizedBox(height: 8.h),
              _buildThumbnailSection(),

              SizedBox(height: 20.h),

              // Upload Progress Indicator
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
                        style: Styles.mediumText(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${(_uploadProgress * 100).toInt()}%',
                        style: Styles.mediumText(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // Publish Button
              ElevatedButton(
                onPressed: (_isUploading || _preventDoubleSubmit)
                    ? null
                    : () async {
                  await _handleSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isUploading
                      ? Colors.grey[300]
                      : AppColors.getRedColor(context),
                  minimumSize: const Size(double.infinity, 50),
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
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      context.isArabic ? 'جاري النشر...' : 'Publishing...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
                    : Text(
                  LocaleKeys.publish.localize,
                  style: const TextStyle(
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
      style:Styles.headerText(
        color: AppColors.getTextColor(context)
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
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
          child: state.status == StateStatus.loading && state.activeCategories == null
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
                  context.isArabic ? 'جاري تحميل الفئات...' : 'Loading categories...',
                  style:Styles.mediumText(
                    color: AppColors.getTextColor(context).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          )
              : DropdownButtonHideUnderline(
            child: DropdownButtonFormField<ActiveCategoryEntity>(
              isExpanded: false, // يمنعها من أخذ الشاشة كلها
              menuMaxHeight: 300, // يحدد أقصى ارتفاع للقائمة
              decoration: InputDecoration(
                hintText: context.isArabic ? 'اختر فئة' : 'Select a category',
                hintStyle: Styles.mediumText(
                  color: AppColors.getTextColor(context).withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
              value: _selectedCategory,
              items: state.activeCategories?.map((category) {
                return DropdownMenuItem<ActiveCategoryEntity>(
                  value: category,
                  child: Text(
                    context.isArabic ? category.nameAr : category.nameEn,
                    style: Styles.mediumText(
                      color: context.isDarkMode ? Colors.white : Colors.black
                      // color: AppColors.getTextColor(context).withOpacity(0.5),
                    ),
                  ),
                );
              }).toList() ??
                  [],
              onChanged: _isUploading
                  ? null
                  : (ActiveCategoryEntity? newCategory) {
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
              style: Styles.mediumText(
                color: AppColors.getTextColor(context).withOpacity(0.5),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.getTextColor(context).withOpacity(0.6),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildVideoSection() {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        final video = state.videos?.isNotEmpty == true ? state.videos!.first : null;
        return GestureDetector(
          onTap: (_isUploading || _isLoadingVideo)
              ? null
              : () async {
            setState(() {
              _isLoadingVideo = true;
            });
            await _pickVideo();
            setState(() {
              _isLoadingVideo = false;
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            constraints: BoxConstraints(minHeight: 200.h, maxHeight: 400.h),
            decoration: BoxDecoration(
              color: AppColors.getFindFillColor(context),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: video != null
                    ? AppColors.getRedColor(context).withOpacity(0.5)
                    : AppColors.getTextColor(context).withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: _isLoadingVideo
                ? _buildVideoPreparingState()
                : video != null
                ? (_videoController?.value.isInitialized == true
                ? _buildAdaptiveVideoPlayer()
                : _buildVideoPreparingState())
                : _buildVideoPlaceholder(),
          ),
        );
      },
    );
  }

  Widget _buildAdaptiveVideoPlayer() {
    final aspectRatio = _videoController!.value.aspectRatio;
    final isVertical = aspectRatio < 1.0;
    final isSquare = (aspectRatio - 1.0).abs() < 0.1;
    double containerHeight = isVertical
        ? MediaQuery.of(context).size.width / aspectRatio
        : isSquare
        ? MediaQuery.of(context).size.width * 0.8
        : 200.h;
    containerHeight = containerHeight.clamp(200.h, 400.h);

    return SizedBox(
      height: containerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
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
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: _videoController!.value.isPlaying
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVertical ? Icons.stay_current_portrait : Icons.stay_current_landscape,
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
                  GestureDetector(
                    onTap: _isUploading
                        ? null
                        : () async {
                      setState(() {
                        _isLoadingVideo = true;
                      });
                      await _pickVideo();
                      setState(() {
                        _isLoadingVideo = false;
                      });
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
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
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
                    Text(
                      _getCurrentTimeText(),
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
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
                    Text(
                      _getTotalTimeText(),
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
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
              style: Styles.mediumText(),
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
            style: Styles.mediumText(),
          ),
          SizedBox(height: 4.h),
          Text(
            context.isArabic ? 'MP4, MOV, AVI • حتى 500 ميجا' : 'MP4, MOV, AVI • Up to 500MB',
            style: Styles.mediumText(),
          ),
        ],
      ),
    );
  }

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
      onTap: (_isUploading || _isLoadingThumbnail)
          ? null
          : () async {
        setState(() {
          _isLoadingThumbnail = true;
        });
        await _pickThumbnail();
        setState(() {
          _isLoadingThumbnail = false;
        });
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
        child: _isLoadingThumbnail
            ? Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.getRedColor(context),
            ),
          ),
        )
            : _selectedThumbnail != null
            ? Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(
                _selectedThumbnail!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.error_outline,
                    color: AppColors.getTextColor(context),
                    size: 48,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _isUploading
                    ? null
                    : () async {
                  setState(() {
                    _isLoadingThumbnail = true;
                  });
                  await _pickThumbnail();
                  setState(() {
                    _isLoadingThumbnail = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.getRedColor(context),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(
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
              context.isArabic ? 'اضغط لاختيار صورة' : 'Tap to select thumbnail',
              style: Styles.mediumText(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 720,
      imageQuality: 85,
    );
    if (image != null) {
      final file = File(image.path);
      final sizeInMB = (await file.length()) / (1024 * 1024);
      if (sizeInMB > 5) {
        showErrorMessage(
          context,
          context.isArabic
              ? 'حجم الصورة المصغرة يجب ألا يتجاوز 5 ميجابايت'
              : 'Thumbnail size must not exceed 5MB',
        );
        return;
      }
      setState(() {
        _selectedThumbnail = file;
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final file = File(video.path);
      final sizeInMB = (await file.length()) / (1024 * 1024);
      if (sizeInMB > 500) {
        showErrorMessage(
          context,
          context.isArabic
              ? 'حجم الفيديو يجب ألا يتجاوز 500 ميجابايت'
              : 'Video size must not exceed 500MB',
        );
        return;
      }
      final uploadFile = UploadFileEntity(mediaId: '', file: XFile(file.path));
      context.read<TubeCubit>().addVideo(uploadFile);
      await _initializeVideo(file.path);
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
        setState(() {
          _videoController!.setLooping(true);
        });
      }
    } catch (e) {
      showErrorMessage(
        context,
        context.isArabic
            ? 'خطأ في تحميل الفيديو. يرجى المحاولة مرة أخرى.'
            : 'Error loading video. Please try again.',
      );
      context.read<TubeCubit>().clearUploadedVideos();
      setState(() {
        _videoController = null;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_preventDoubleSubmit || _isUploading) return;
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _preventDoubleSubmit = true;
      _isUploading = true;
      _uploadStatus = context.isArabic ? 'بدء الرفع...' : 'Starting upload...';
      _uploadProgress = 0.0;
    });

    final state = context.read<TubeCubit>().state;
    final video = state.videos?.isNotEmpty == true ? state.videos!.first : null;

    if (video == null) {
      showErrorMessage(
        context,
        context.isArabic ? 'يرجى اختيار فيديو' : 'Please select a video',
      );
      setState(() {
        _isUploading = false;
        _preventDoubleSubmit = false;
      });
      return;
    }

    if (_selectedThumbnail == null) {
      showErrorMessage(
        context,
        context.isArabic ? 'يرجى اختيار صورة مصغرة' : 'Please select a thumbnail',
      );
      setState(() {
        _isUploading = false;
        _preventDoubleSubmit = false;
      });
      return;
    }

    if (_selectedCategory == null) {
      showErrorMessage(
        context,
        context.isArabic ? 'يرجى اختيار فئة' : 'Please select a category',
      );
      setState(() {
        _isUploading = false;
        _preventDoubleSubmit = false;
      });
      return;
    }

    try {
      setState(() {
        _uploadStatus = context.isArabic
            ? 'جاري الحصول على معلومات الفيديو...'
            : 'Getting video information...';
      });

      final duration = _videoController?.value.duration.inSeconds;
      if (duration == null || duration <= 0) {
        showErrorMessage(
          context,
          context.isArabic ? 'يرجى إدخال مدة فيديو صالحة' : 'Please provide a valid video duration',
        );
        setState(() {
          _isUploading = false;
          _preventDoubleSubmit = false;
        });
        return;
      }

      // Log category_id for debugging
      final categoryId = _selectedCategory!.id;
      print('Selected Category ID: $categoryId');

      // Validate categoryId format
      final isValidMongoId = RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(categoryId);
      if (!isValidMongoId) {
        showErrorMessage(
          context,
          context.isArabic
              ? 'معرف الفئة غير صالح. يرجى اختيار فئة صالحة.'
              : 'Invalid category ID. Please select a valid category.',
        );
        setState(() {
          _isUploading = false;
          _preventDoubleSubmit = false;
        });
        return;
      }

      final bunnyResponse = await _bunnyUploader.uploadCompleteVideo(
        context: context,
        title: widget.titleController.text,
        description: widget.descController.text,
        videoFile: File(video.file.path),
        thumbnailFile: _selectedThumbnail!,
        subCategoryId: Constants.tubeSubCategory,
        categoryId: categoryId,
        videoDuration: duration,
        onStatusUpdate: (status) {
          setState(() {
            _uploadStatus = status;
          });
        },
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      bunnyResponse.fold(
            (failure) {
          showErrorMessage(context, getFailureMessage(failure, context));
          setState(() {
            _isUploading = false;
            _preventDoubleSubmit = false;
          });
        },
            (success) {
          print("✅ Upload successful, checking database...");
          // Success case: mimic AddTalentWidget
          showSuccessMessage(
            context,
            context.isArabic
                ? 'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. يحتاج وقت ليصبح متاحاً للمستخدمين.'
                : 'Video uploaded successfully!\n\nNote: Video is not currently available. It takes time before it becomes available to users.',
          );
          _clearForm();
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        },
      );
    } catch (e) {
      showErrorMessage(
        context,
        context.isArabic ? 'حدث خطأ غير متوقع: $e' : 'An unexpected error occurred: $e',
      );
      setState(() {
        _isUploading = false;
        _preventDoubleSubmit = false;
      });
    }
  }

  void _clearForm() {
    widget.titleController.clear();
    widget.descController.clear();
    setState(() {
      _selectedThumbnail = null;
      _selectedCategory = null;
      _videoController?.dispose();
      _videoController = null;
      _isUploading = false;
      _preventDoubleSubmit = false;
      _uploadStatus = '';
      _uploadProgress = 0.0;
    });
    context.read<TubeCubit>().clearUploadedVideos();
  }

  @override
  void dispose() {
    _videoController?.pause();
    _videoController?.dispose();
    super.dispose();
  }
}