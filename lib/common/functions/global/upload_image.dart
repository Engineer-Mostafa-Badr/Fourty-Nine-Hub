import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/helper/file_picker_helper.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/localization/locale_keys.g.dart';

class UploadImage {
  Future<Either<Failure, bool>?> uploadImage(
      {bool isGallery = true,
      required BuildContext context,
      required Function(XFile) onUploaded}) async {
    final file = await FilePickerHelper()
        .pickImage(isGallery: isGallery)
        .then((file) async {
      if (file != null) {
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: LocaleKeys.cropImage.localize,
              toolbarColor: AppColors.SECONDARY_COLOR,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        XFile finalFile = XFile(croppedFile?.path ?? '');
        final tempDir = await getTemporaryDirectory();
        final uniqueFileName =
            'compressed_${DateTime.now().millisecondsSinceEpoch}_${finalFile.name}';
        final targetPath = '${tempDir.path}/$uniqueFileName';
        print("finalFile.path${finalFile.path}");
        print("finalFile.path$targetPath");
        print("objectUpload2");
        var result = await FlutterImageCompress.compressAndGetFile(
          finalFile.path,
          targetPath,
          quality: 50,
          rotate: 360,
        );
        if (result == null) {
          context.pop();
        } else {
          onUploaded(result);
        }
      }
    });
    return null;
  }
}
