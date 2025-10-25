import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../../domain/entity/user_star_entity.dart';
import '../../presentation_exports.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class ProfileHeader extends StatefulWidget {
  final ProfileEntity? profile;
  final UserStarEntity? user;
  final bool isCurrentUser;
  final int videosCount;

  const ProfileHeader({
    super.key,
    this.profile,
    this.user,
    this.isCurrentUser = false,
    required this.videosCount,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingCover = false;
  bool _isUploadingProfilePicture = false;
  bool _isSubscribing = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('ProfileHeader - isCurrentUser: ${widget.isCurrentUser}');
    debugPrint('ProfileHeader - profile: ${widget.profile?.channelName}');
    debugPrint('ProfileHeader - user: ${widget.user?.firstName}');

    return Container(
      // color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(context, 20),
      ),
      child: Column(
        children: [
          // Banner Section
          _buildBannerSection(context),
          SizedBox(height: _getResponsiveSpacing(context, 20)),
          // Profile Info Section
          _buildProfileInfoSection(context),
          // Subscribe Button Section - إخفاؤه للمستخدم الحالي
          if (!widget.isCurrentUser) ...[
            SizedBox(height: _getResponsiveSpacing(context, 16)),
            _buildSubscribeSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildBannerSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.3;

    final bannerUrl = widget.profile?.channelCover != null
        ? widget.profile!.channelCover!.mediaKey
        : null;

    log('bannerUrl: $bannerUrl');

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: bannerHeight,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(_getResponsiveBorderRadius(context, 16)),
            color: Colors.grey[200],
          ),
          child: bannerUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                      _getResponsiveBorderRadius(context, 16)),
                  child: CachedNetworkImage(
                    imageUrl: bannerUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Image.asset(
                        Assets.logo,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                )
              : Center(
                  child: Image.asset(
                    Assets.logo,
                    fit: BoxFit.contain,
                  ),
                ),
        ),

        // Cover photo edit button (only for current user)
        if (widget.isCurrentUser)
          Positioned(
            top: 8,
            right: 8,
            child: _isUploadingCover
                ? Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () =>
                        _showImagePickerDialog(context, ImageType.cover),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }

  bool _isAccountVerified() {
    // للمستخدم الحالي
    if (widget.isCurrentUser) {
      return widget.profile?.user?.isAccountVerified ?? false;
    }

    // للمستخدمين الآخرين - من الـ profile المحمل
    return widget.profile?.user?.isAccountVerified ?? false;
  }

  Widget _buildProfileInfoSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final profileSize = screenWidth < 360 ? 60.0 : 80.0;

    // تحسين null safety
    final profileImageUrl =
        widget.isCurrentUser && widget.profile?.channelPicture != null
            ? widget.profile!.channelPicture!.mediaKey
            : widget.user?.image ?? '';

    // Determine gender - for current user check profile.user.gender, for others check widget.user.gender
    final isMale = widget.isCurrentUser
        ? (widget.profile?.user?.gender.toLowerCase() != 'female')
        : (widget.user?.gender.toLowerCase() != 'female');

    final displayName = widget.isCurrentUser &&
            widget.profile != null &&
            widget.profile!.channelName.isNotEmpty
        ? widget.profile!.channelName
        : (widget.user != null
            ? "${widget.user!.firstName} ${widget.user!.lastName}".trim()
            : "Unknown User");

    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                ImageFromInternet(
                  image: profileImageUrl,
                  width: profileSize,
                  height: profileSize,
                  isCircle: true,
                  isMale: isMale,
                  defaultLogo: profileImageUrl.isEmpty,
                  fit: BoxFit.cover,
                ),

                // Profile picture edit button (only for current user)
                if (widget.isCurrentUser)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _isUploadingProfilePicture
                        ? Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => _showImagePickerDialog(
                                context, ImageType.profile),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.PRIMARY_COLOR,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                  ),
              ],
            ),
            SizedBox(width: _getResponsiveSpacing(context, 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 24),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (_isAccountVerified()) ...[
                        SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: _getResponsiveSpacing(context, 4)),
                  Text(
                    context.isArabic
                        ? "${displayName.toLowerCase().replaceAll(' ', '')}@ • ${_getArabicVideosText(widget.videosCount).toArabicNumbers(context)}"
                        : "@${displayName.toLowerCase().replaceAll(' ', '')} • ${widget.videosCount} videos",
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 16),
                      color: Colors.grey[600],
                    ),
                  ),
                  if (widget.isCurrentUser &&
                      widget.profile?.channelDescription != null &&
                      widget.profile!.channelDescription.isNotEmpty) ...[
                    SizedBox(height: _getResponsiveSpacing(context, 8)),
                    Text(
                      widget.profile!.channelDescription,
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 14),
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscribeSection(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        final isSubscribed = profileState.profile?.isSubscribed ??
            widget.profile?.isSubscribed ??
            false;

        return SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSubscribed ? Colors.grey[300] : Colors.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: _isSubscribing
                          ? null
                          : () async {
                              if (widget.profile?.id == null) return;

                              ManageVibration.vibrate();

                              setState(() {
                                _isSubscribing = true;
                              });

                              // Use userId for subscribe/unsubscribe
                              await profileCubit.toggleSubscription(
                                widget.profile!.userId,
                              );

                              if (mounted) {
                                setState(() {
                                  _isSubscribing = false;
                                });
                              }
                            },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isSubscribing)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isSubscribed ? Colors.black : Colors.white,
                                  ),
                                ),
                              )
                            else
                              Icon(
                                isSubscribed ? Icons.check : Icons.add,
                                color:
                                    isSubscribed ? Colors.black : Colors.white,
                                size: 20,
                              ),
                            SizedBox(width: 8),
                            Text(
                              isSubscribed
                                  ? (context.isArabic ? 'مشترك' : 'Subscribed')
                                  : (context.isArabic ? 'اشتراك' : 'Subscribe'),
                              style: TextStyle(
                                color:
                                    isSubscribed ? Colors.black : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // if (!isSubscribed) ...[
              //   SizedBox(width: 12),
              //   Container(
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //     child: IconButton(
              //       icon: Icon(
              //         Icons.notifications_none,
              //         color: Colors.grey[700],
              //         size: 24,
              //       ),
              //       onPressed: () {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(
              //             content: Text(
              //               context.isArabic
              //                   ? 'اشترك أولاً لتفعيل الإشعارات'
              //                   : 'Subscribe first to enable notifications',
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ],
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerDialog(BuildContext context, ImageType imageType) {
    ManageVibration.vibrate();

    final title = imageType == ImageType.cover
        ? (context.isArabic ? 'تغيير صورة الغلاف' : 'Change Cover Photo')
        : (context.isArabic
            ? 'تغيير الصورة الشخصية'
            : 'Change Profile Picture');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (bottomSheetContext) => Container(
        key: ValueKey('image_picker_${imageType.name}_${widget.hashCode}'),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Options
                Column(
                  children: [
                    _buildImagePickerOption(
                      context: bottomSheetContext,
                      icon: Icons.photo_library,
                      title: context.isArabic ? 'من المعرض' : 'From Gallery',
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        _pickImage(ImageSource.gallery, imageType);
                      },
                    ),
                    SizedBox(height: 12),
                    _buildImagePickerOption(
                      context: bottomSheetContext,
                      icon: Icons.camera_alt,
                      title: context.isArabic ? 'من الكاميرا' : 'From Camera',
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        _pickImage(ImageSource.camera, imageType);
                      },
                    ),
                    if ((imageType == ImageType.cover &&
                            widget.profile?.channelCover != null) ||
                        (imageType == ImageType.profile &&
                            widget.profile?.channelPicture != null)) ...[
                      SizedBox(height: 12),
                      _buildImagePickerOption(
                        context: bottomSheetContext,
                        icon: Icons.delete,
                        title: context.isArabic ? 'حذف الصورة' : 'Remove Photo',
                        isDestructive: true,
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          _removeImage(imageType);
                        },
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isDestructive ? Colors.red.withOpacity(0.3) : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.grey[700],
              size: 24,
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, ImageType imageType) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: imageType == ImageType.cover ? 1200 : 800,
        maxHeight: imageType == ImageType.cover ? 600 : 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (imageType == ImageType.cover) {
            _isUploadingCover = true;
          } else {
            _isUploadingProfilePicture = true;
          }
        });

        await _uploadImage(File(pickedFile.path), imageType);
      }
    } catch (e) {
      print('Error picking image: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       context.isArabic ? 'خطأ في اختيار الصورة' : 'Error picking image',
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      showErrorMessage(context,
          context.isArabic ? 'خطاء في اختيار الصورة' : 'Error picking image');
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingCover = false;
          _isUploadingProfilePicture = false;
        });
      }
    }
  }

  Future<void> _uploadImage(File imageFile, ImageType imageType) async {
    try {
      final uploadFile = UploadFile();
      bool uploadSuccess = false;
      String? mediaId;

      await uploadFile.uploadImageSilent(
        subCategoryId:
            Constants.tubeSubCategory, // You might need to adjust this
        context: context,
        file: imageFile,
        onUploaded: (uploadEntity) {
          uploadSuccess = true;
          mediaId = uploadEntity.mediaId;
        },
      );

      if (uploadSuccess && mediaId != null) {
        // Update profile with new image
        await _updateProfileImage(mediaId!, imageType);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       context.isArabic
        //           ? 'تم تحديث الصورة بنجاح'
        //           : 'Image updated successfully',
        //     ),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        showSuccessMessage(
            context,
            context.isArabic
                ? 'تم تحديث الصورة بنجاح'
                : 'Image updated successfully');
      } else {
        throw Exception(
            context.isArabic ? 'خطأ في رفع الصورة' : 'Error uploading image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       context.isArabic ? 'خطأ في رفع الصورة' : 'Error uploading image',
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      showErrorMessage(context,
          context.isArabic ? 'خطاء في رفع الصورة' : 'Error uploading image');
    }
  }

  Future<void> _updateProfileImage(String mediaId, ImageType imageType) async {
    final profileCubit = context.read<ProfileCubit>();
    final currentProfile = profileCubit.state.profile;

    if (currentProfile != null) {
      await profileCubit.updateProfile(
        channelName: currentProfile.channelName,
        channelDescription: currentProfile.channelDescription,
        channelCover: imageType == ImageType.cover ? mediaId : null,
        channelPicture: imageType == ImageType.profile ? mediaId : null,
      );
    }
  }

  Future<void> _removeImage(ImageType imageType) async {
    try {
      final profileCubit = context.read<ProfileCubit>();
      final currentProfile = profileCubit.state.profile;

      if (currentProfile != null) {
        await profileCubit.updateProfile(
          channelName: currentProfile.channelName,
          channelDescription: currentProfile.channelDescription,
          channelCover: imageType == ImageType.cover ? "" : null,
          channelPicture: imageType == ImageType.profile ? "" : null,
        );

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       context.isArabic ? 'تم حذف الصورة' : 'Image removed',
        //     ),
        //     backgroundColor: Colors.orange,
        //   ),
        // );
        showSuccessMessage(
            context, context.isArabic ? 'تم حذف الصورة' : 'Image removed');
      }
    } catch (e) {
      print('Error removing image: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       context.isArabic ? 'خطأ في حذف الصورة' : 'Error removing image',
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      showErrorMessage(context,
          context.isArabic ? 'خطاء في حذف الصورة' : 'Error removing image');
    }
  }

  // Helper methods for responsive design
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsivePadding(BuildContext context, double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.8;
    } else if (screenWidth > 400) {
      return basePadding * 1.15;
    }
    return basePadding;
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    }
    return baseSpacing;
  }

  double _getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseRadius * 0.8;
    }
    return baseRadius;
  }

  String _getArabicVideosText(int count) {
    if (count == 0) {
      return 'لا توجد فيديوهات';
    } else if (count == 1) {
      return 'فيديو واحد';
    } else if (count == 2) {
      return 'فيديوهان';
    } else if (count >= 3 && count <= 10) {
      return '$count فيديوهات';
    } else {
      return '$count فيديو';
    }
  }
}

enum ImageType { cover, profile }
