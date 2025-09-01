import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/bunny_video_uploader.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../domain/use_case/upload_my_star_use_case.dart';
import '../controller/cubit/star_cubit.dart';
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Media preview container
            Container(
              height: 330.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.getFindFillColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.getTextColor(context).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: _buildMediaPreview(),
            ),
            const SizedBox(height: 16),

            // Upload progress indicator
            if (_isUploading) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getFindFillColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: _uploadProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.getRedColor(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _uploadStatus,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.getTextColor(context),
                      ),
                    ),
                    Text(
                      '${(_uploadProgress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getRedColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Upload buttons row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () {
                            ManageVibration.vibrate();
                            _pickThumbnail();
                          },
                    icon: Image.asset(Assets.uploadIcon,
                        color: _isUploading
                            ? Colors.grey
                            : AppColors.getReversedTextColor(context)),
                    label: FittedBox(
                      child: Text(
                        LocaleKeys.talent_upload_image.localize,
                        style: TextStyle(
                            color: _isUploading
                                ? Colors.grey
                                : AppColors.getReversedTextColor(context)),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isUploading
                          ? Colors.grey[300]
                          : AppColors.getRedColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () {
                            ManageVibration.vibrate();
                            _pickVideo();
                          },
                    icon: Image.asset(Assets.uploadIcon,
                        color: _isUploading
                            ? Colors.grey
                            : AppColors.getReversedTextColor(context)),
                    label: FittedBox(
                      child: Text(
                        LocaleKeys.talent_upload_video.localize,
                        style: TextStyle(
                            color: _isUploading
                                ? Colors.grey
                                : AppColors.getReversedTextColor(context)),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isUploading
                          ? Colors.grey[300]
                          : AppColors.getRedColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title input
            TextFormField(
              controller: _titleController,
              enabled: !_isUploading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.emptyFieldNotValid.localize;
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: LocaleKeys.title.localize,
                filled: true,
                fillColor: AppColors.getFindFillColor(context),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              focusNode: _titleFocusNode,
            ),
            const SizedBox(height: 16),

            // Description input
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
              decoration: InputDecoration(
                hintText: LocaleKeys.desc.localize,
                filled: true,
                fillColor: AppColors.getFindFillColor(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

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
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isUploading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          context.isArabic ? 'جاري النشر...' : 'Publishing...',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : Text(
                      LocaleKeys.publish.localize,
                      style: Styles.mediumText(
                          color: AppColors.getReversedTextColor(context)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_selectedVideo != null &&
        _videoController?.value.isInitialized == true) {
      // Show video preview
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
          // Thumbnail overlay if available
          if (_selectedThumbnail != null)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    _selectedThumbnail!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          // Play/Pause button
          Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (_videoController!.value.isPlaying) {
                    _videoController!.pause();
                  } else {
                    _videoController!.play();
                  }
                });
              },
              icon: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 64,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      );
    } else if (_selectedThumbnail != null) {
      // Show thumbnail only
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _selectedThumbnail!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else {
      // Show placeholder
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.cameraAddTalent,
            color: context.isDarkMode ? AppColors.whiteColor : null,
            width: 64,
            height: 64,
          ),
          const SizedBox(height: 16),
          Text(
            context.isArabic
                ? 'اختر فيديو وصورة مصغرة'
                : 'Select video and thumbnail',
            style: TextStyle(
              color: AppColors.getTextColor(context).withOpacity(0.6),
              fontSize: 16,
            ),
          ),
        ],
      );
    }
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

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

  // Future<void> _performUpload() async {
  //   setState(() {
  //     _isUploading = true;
  //     _uploadProgress = 0.0;
  //     _uploadStatus = context.isArabic ? 'بدء الرفع...' : 'Starting upload...';
  //   });

  //   try {
  //     // Validate files first
  //     final videoPickerHelper = VideoPickerHelper();
  //     final validation =
  //         await videoPickerHelper.validateVideoForUpload(_selectedVideo!);

  //     print("🔍 Video validation result: $validation");

  //     if (!(validation['isValid'] as bool)) {
  //       final errors = validation['errors'] as List<String>;
  //       _showError('Video validation failed: ${errors.join(', ')}');
  //       return;
  //     }

  //     // Show validation passed
  //     setState(() {
  //       _uploadStatus = context.isArabic
  //           ? 'الفيديو صالح للرفع...'
  //           : 'Video validated successfully...';
  //     });

  //     await Future.delayed(Duration(milliseconds: 500));

  //     final result = await _bunnyUploader.uploadCompleteVideo(
  //       context: context,
  //       title: _titleController.text,
  //       description: _descriptionController.text,
  //       videoFile: _selectedVideo!,
  //       thumbnailFile: _selectedThumbnail!,
  //       subCategoryId: Constants.tubeSubCategory,
  //       onStatusUpdate: (status) {
  //         setState(() {
  //           _uploadStatus = status;
  //         });
  //         print("📊 Status: $status");
  //       },
  //       onProgress: (progress) {
  //         setState(() {
  //           _uploadProgress = progress;
  //         });
  //         // Only print every 5% to reduce log spam
  //         if ((progress * 100).toInt() % 5 == 0) {
  //           print("📈 Progress: ${(progress * 100).toInt()}%");
  //         }
  //       },
  //     );

  //     result.fold(
  //       (failure) {
  //         print("❌ Upload failed: ${failure.toString()}");

  //         String errorMessage;
  //         if (failure is ServerFailure) {
  //           if (failure.statusCode == 401) {
  //             errorMessage = context.isArabic
  //                 ? 'انتهت صلاحية الجلسة. يرجى إعادة المحاولة'
  //                 : 'Session expired. Please try again';
  //           } else {
  //             errorMessage = context.isArabic
  //                 ? 'خطأ في الخادم: ${failure.message}'
  //                 : 'Server error: ${failure.message}';
  //           }
  //         } else if (failure is UnknownFailure) {
  //           if (failure.error.contains('expired')) {
  //             errorMessage = context.isArabic
  //                 ? 'انتهت صلاحية رفع الملف. يرجى إعادة المحاولة'
  //                 : 'Upload session expired. Please try again';
  //           } else {
  //             errorMessage = context.isArabic
  //                 ? 'فشل الرفع: ${failure.error}'
  //                 : 'Upload failed: ${failure.error}';
  //           }
  //         } else {
  //           errorMessage = context.isArabic
  //               ? 'حدث خطأ غير معروف'
  //               : 'An unknown error occurred';
  //         }

  //         _showError(errorMessage);
  //       },
  //       (success) {
  //         print("✅ Upload successful!");
  //         _showSuccess(context.isArabic
  //             ? 'تم رفع الفيديو بنجاح!'
  //             : 'Video uploaded successfully!');

  //         // Clear form and navigate back
  //         _clearForm();
  //         Future.delayed(Duration(seconds: 2), () {
  //           if (mounted) {
  //             Navigator.of(context).pop();
  //           }
  //         });
  //       },
  //     );
  //   } catch (e) {
  //     print("❌ Exception in _performUpload: $e");
  //     _showError(context.isArabic
  //         ? 'حدث خطأ غير متوقع: $e'
  //         : 'An unexpected error occurred: $e');
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isUploading = false;
  //         _uploadProgress = 0.0;
  //         _uploadStatus = '';
  //       });
  //     }
  //   }
  // }

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
    
    final duration = await videoPickerHelper.getVideoDuration(_selectedVideo!);
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

        String errorMessage;
        if (failure is ServerFailure) {
          if (failure.statusCode == 401) {
            errorMessage = context.isArabic
                ? 'انتهت صلاحية الجلسة. يرجى إعادة المحاولة'
                : 'Session expired. Please try again';
          } else {
            errorMessage = context.isArabic
                ? 'خطأ في الخادم: ${failure.message}'
                : 'Server error: ${failure.message}';
          }
        } else if (failure is UnknownFailure) {
          if (failure.error.contains('expired')) {
            errorMessage = context.isArabic
                ? 'انتهت صلاحية رفع الملف. يرجى إعادة المحاولة'
                : 'Upload session expired. Please try again';
          } else if (failure.error.contains('duration')) {
            errorMessage = context.isArabic
                ? 'فشل في الحصول على مدة الفيديو. يرجى إعادة المحاولة'
                : 'Failed to get video duration. Please try again';
          } else {
            errorMessage = context.isArabic
                ? 'فشل الرفع: ${failure.error}'
                : 'Upload failed: ${failure.error}';
          }
        } else {
          errorMessage = context.isArabic
              ? 'حدث خطأ غير معروف'
              : 'An unknown error occurred';
        }

        _showError(errorMessage);
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
        duration: Duration(seconds: 8), // Longer duration for errors
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

// Enhanced error messages in upload status
  Widget _buildUploadStatus() {
    if (!_isUploading) return SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.getFindFillColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _uploadProgress >= 1.0
              ? Colors.green
              : AppColors.getRedColor(context).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _uploadProgress >= 1.0
                    ? Colors.green
                    : AppColors.getRedColor(context),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),

          // Status text
          Text(
            _uploadStatus,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.getTextColor(context),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Progress percentage
          Text(
            '${(_uploadProgress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _uploadProgress >= 1.0
                  ? Colors.green
                  : AppColors.getRedColor(context),
            ),
          ),

          // Cancel button (only show if upload is in progress and below 90%)
          if (_uploadProgress > 0 && _uploadProgress < 0.9) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Implement upload cancellation if needed
                setState(() {
                  _isUploading = false;
                  _uploadProgress = 0.0;
                  _uploadStatus = '';
                });
              },
              child: Text(
                context.isArabic ? 'إلغاء' : 'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
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
