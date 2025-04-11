import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../common/widgets/stateless/buttons/default_button.dart';
import '../../../../core/messages/messages.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';

class AddTalentWidget extends StatefulWidget {
  const AddTalentWidget({super.key});

  @override
  State<AddTalentWidget> createState() => _AddTalentWidgetState();
}

class _AddTalentWidgetState extends State<AddTalentWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImages;
  File? _selectedVideo;
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideo(String path) {
    if (_videoController != null) {
      _videoController!.dispose();
    }
    _videoController = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();
        _videoController!.setLooping(true);
      });
  }

  void _showMediaPicker(bool isImage) async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(LocaleKeys.gallery.localize),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file = isImage
                    ? await picker.pickImage(source: ImageSource.gallery)
                    : await picker.pickVideo(source: ImageSource.gallery);

                if (file != null) {
                  setState(() {
                    if (isImage) {
                      _selectedImages = File(file.path);
                      _selectedVideo = null;
                      _videoController?.dispose();
                      _videoController = null;
                    } else {
                      _selectedVideo = File(file.path);
                      _selectedImages = null;
                      _initializeVideo(file.path);
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(LocaleKeys.camera.localize),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file = isImage
                    ? await picker.pickImage(source: ImageSource.camera)
                    : await picker.pickVideo(source: ImageSource.camera);

                if (file != null) {
                  setState(() {
                    if (isImage) {
                      _selectedImages = File(file.path);
                      _selectedVideo = null;
                      _videoController?.dispose();
                      _videoController = null;
                    } else {
                      _selectedVideo = File(file.path);
                      _selectedImages = null;
                      _initializeVideo(file.path);
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages == null && _selectedVideo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.enterImageOrVideo.localize),
          ),
        );
        return;
      }

      context.read<StarCubit>().uploadStar(
            params: StarParams(
              title: _titleController.text,
              mediaUrl: _selectedImages!.path,
              description: _descriptionController.text,
              type: _selectedImages == null ? 'video' : 'image',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image placeholder
            Container(
              height: 330.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: _selectedVideo != null
                  ? _videoController?.value.isInitialized ?? false
                      ? Center(
                          child: AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: SizedBox(
                                  width: _videoController!.value.size.width,
                                  height: _videoController!.value.size.height,
                                  child: VideoPlayer(_videoController!),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator())
                  : _selectedImages == null
                      ? Image.asset(Assets.cameraAddTalent)
                      : Image.file(_selectedImages!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),

            // Upload buttons row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showMediaPicker(true),
                    icon: Image.asset(Assets.uploadIcon, color: Colors.white),
                    label: FittedBox(
                      child: Text(
                        LocaleKeys.talent_upload_image.localize,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showMediaPicker(false),
                    icon: Image.asset(Assets.uploadIcon, color: Colors.white),
                    label: FittedBox(
                      child: Text(
                        LocaleKeys.talent_upload_video.localize,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorRed,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.emptyFieldNotValid.localize;
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: LocaleKeys.title.localize,
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description input
            TextFormField(
              controller: _descriptionController,
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
                fillColor: Colors.grey[200],
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
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorRed,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                LocaleKeys.publish.localize,
                style: Styles.mediumText(color: Colors.white),
                // const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
