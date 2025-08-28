import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/profile_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entity/profile_entity.dart';


class EditProfileBottomSheet extends StatefulWidget {
  final ProfileEntity? currentProfile;

  const EditProfileBottomSheet({
    super.key,
    required this.currentProfile,
  });

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedChannelPicture;
  File? _selectedChannelCover;

  String? _channelPictureId;
  String? _channelCoverId;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.currentProfile?.channelName ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.currentProfile?.channelDescription ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageType type) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: type == ImageType.cover ? 1200 : 400,
        maxHeight: type == ImageType.cover ? 600 : 400,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (type == ImageType.cover) {
            _selectedChannelCover = File(pickedFile.path);
          } else {
            _selectedChannelPicture = File(pickedFile.path);
          }
        });

        // TODO: رفع الصورة للسيرفر والحصول على الـ ID
        await _uploadImage(pickedFile, type);
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في اختيار الصورة: $e');
    }
  }

  Future<void> _uploadImage(XFile imageFile, ImageType type) async {
    setState(() => _isUploading = true);

    try {
      // TODO: تنفيذ رفع الصورة الفعلي
      // final uploadedImageId = await uploadImageToServer(imageFile);

      // مؤقتاً سنستخدم ID وهمي
      final uploadedImageId = "66993df106144734b59b0a5c";

      setState(() {
        if (type == ImageType.cover) {
          _channelCoverId = uploadedImageId;
        } else {
          _channelPictureId = uploadedImageId;
        }
      });
    } catch (e) {
      _showErrorSnackBar('خطأ في رفع الصورة: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar(context.isArabic
          ? 'يرجى إدخال اسم القناة'
          : 'Please enter channel name');
      return;
    }

    final success = await context.read<ProfileCubit>().updateProfile(
          channelName: _nameController.text.trim(),
          channelDescription: _descriptionController.text.trim(),
          channelCover: _channelCoverId,
          channelPicture: _channelPictureId,
        );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.isArabic
              ? 'تم حفظ التغييرات بنجاح'
              : 'Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 24),
                  padding: EdgeInsets.zero,
                ),
                Expanded(
                  child: Text(
                    context.isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 40), // Balance the close button
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[200]),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel Cover Section
                  _buildSectionTitle(
                      context.isArabic ? 'غلاف القناة' : 'Channel Cover'),
                  SizedBox(height: 12),
                  _buildCoverImagePicker(),

                  SizedBox(height: 24),

                  // Profile Picture Section
                  _buildSectionTitle(context.isArabic
                      ? 'صورة الملف الشخصي'
                      : 'Profile Picture'),
                  SizedBox(height: 12),
                  _buildProfileImagePicker(),

                  SizedBox(height: 24),

                  // Channel Name
                  _buildSectionTitle(
                      context.isArabic ? 'اسم القناة' : 'Channel Name'),
                  SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hintText: context.isArabic
                        ? 'أدخل اسم القناة'
                        : 'Enter channel name',
                    maxLines: 1,
                  ),

                  SizedBox(height: 20),

                  // Channel Description
                  _buildSectionTitle(
                      context.isArabic ? 'وصف القناة' : 'Channel Description'),
                  SizedBox(height: 8),
                  _buildTextField(
                    controller: _descriptionController,
                    hintText: context.isArabic
                        ? 'أدخل وصف القناة (اختياري)'
                        : 'Enter channel description (optional)',
                    maxLines: 3,
                  ),

                  SizedBox(height: 32),

                  // Save Button
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final isLoading =
                          state.status == ProfileStatus.updating ||
                              _isUploading;

                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  context.isArabic
                                      ? 'حفظ التغييرات'
                                      : 'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildCoverImagePicker() {
    return GestureDetector(
      onTap: () => _pickImage(ImageType.cover),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.grey[50],
        ),
        child: _selectedChannelCover != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedChannelCover!,
                  fit: BoxFit.cover,
                ),
              )
            : widget.currentProfile?.channelCover?.mediaKey != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.currentProfile!.channelCover!.mediaKey,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildPlaceholder(
                        Icons.image,
                        context.isArabic
                            ? 'انقر لتغيير الغلاف'
                            : 'Tap to change cover',
                      ),
                      errorWidget: (context, url, error) => _buildPlaceholder(
                        Icons.image,
                        context.isArabic
                            ? 'انقر لإضافة غلاف'
                            : 'Tap to add cover',
                      ),
                    ),
                  )
                : _buildPlaceholder(
                    Icons.image,
                    context.isArabic ? 'انقر لإضافة غلاف' : 'Tap to add cover',
                  ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: () => _pickImage(ImageType.profile),
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 2),
                color: Colors.grey[50],
              ),
              child: _selectedChannelPicture != null
                  ? ClipOval(
                      child: Image.file(
                        _selectedChannelPicture!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : widget.currentProfile?.channelPicture?.mediaKey != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.currentProfile!.channelPicture!.mediaKey,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: Icon(Icons.person,
                                  size: 40, color: Colors.grey[400]),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(Icons.person,
                                  size: 40, color: Colors.grey[400]),
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(Icons.person,
                              size: 40, color: Colors.grey[400]),
                        ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 32, color: Colors.grey[400]),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

enum ImageType { cover, profile }
