import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_image.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../controller/cubit/chance_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class AddImageWidget extends StatefulWidget {
  const AddImageWidget({super.key});

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  List<XFile> selectedImages = [];

  void _addImage() async {
    ManageVibration.vibrate();

    final uploadImage = UploadImage();
    await uploadImage.uploadImage(
      context: context,
      isGallery: true,
      onUploaded: (XFile file) {
        setState(() {
          selectedImages.add(file);
        });

        // Here you would typically upload the image to your server
        // and get back an image ID, then add it to the cubit
        // For now, we'll use a placeholder ID
        final imageId = "uploaded_${DateTime.now().millisecondsSinceEpoch}";
        context.read<ChanceCubit>().addUploadedImageId(imageId);

        Navigator.of(context).pop();
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });

    // Remove from cubit as well
    final cubit = context.read<ChanceCubit>();
    if (index < cubit.state.uploadedImageIds.length) {
      cubit.removeUploadedImageId(cubit.state.uploadedImageIds[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _addImage,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                boxShadow: AppColors.SHADOW_LIGHT,
                color: Theme.of(context).scaffoldBackgroundColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/image.png",
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.SECONDARY_COLOR,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      LocaleKeys.addImages.localize,
                      textAlign: TextAlign.center,
                      style: Styles.smallText(color: Colors.white, fontSize: 50.sp),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        // Display selected images
        if (selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(selectedImages[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}