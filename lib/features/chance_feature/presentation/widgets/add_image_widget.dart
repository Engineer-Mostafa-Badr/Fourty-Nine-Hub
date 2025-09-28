import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/auction/auction_helper.dart'
    as auction_helper;
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../core/localization/locale_keys.g.dart';
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
  List<UploadFileEntity> selectedImages = [];
  bool isUploading = false;

  void _addImage() async {
    ManageVibration.vibrate();

    setState(() {
      isUploading = true;
    });

    final uploadImage = auction_helper.UploadImage();
    await uploadImage.uploadImage(
      isGallery: true,
      onUploaded: (auction_helper.UploadFileEntity uploadedFile) {
        final globalUploadFileEntity = UploadFileEntity(
          mediaId: uploadedFile.mediaId,
          file: uploadedFile.file,
        );

        setState(() {
          selectedImages.add(globalUploadFileEntity);
          isUploading = false;
        });

        // Add the real media ID to the cubit
        context.read<ChanceCubit>().addUploadedImageId(uploadedFile.mediaId);

        return uploadedFile; // Return something to match the expected return type
      },
    );

    // Set uploading to false in case of error
    setState(() {
      isUploading = false;
    });
  }

  void _removeImage(int index) {
    final imageToRemove = selectedImages[index];

    setState(() {
      selectedImages.removeAt(index);
    });

    // Remove from cubit as well using the actual media ID
    context.read<ChanceCubit>().removeUploadedImageId(imageToRemove.mediaId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isUploading ? null : _addImage,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                boxShadow: AppColors.SHADOW_LIGHT,
                color: Theme.of(context).scaffoldBackgroundColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isUploading)
                  const CircularProgressIndicator()
                else
                  Image.asset(
                    "assets/images/image.png",
                  ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color:
                        isUploading ? Colors.grey : AppColors.SECONDARY_COLOR,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      isUploading
                          ? "Uploading..."
                          : LocaleKeys.addImages.localize,
                      textAlign: TextAlign.center,
                      style: Styles.smallText(
                          color: Colors.white, fontSize: 50.sp),
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
                          File(selectedImages[index].file.path),
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
