import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/helper/file_picker_helper.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class UploadImages {
  Future<Either<Failure, bool>?> uploadImage({
    bool isGallery = true,
    int limit = 20,
    required String subCategoryId,
    required BuildContext context,
    required Function(UploadImagesEntity) onUploaded,
  }) async {
    // Step 1️⃣ Pick images
    final uploadedFiles =
        await FilePickerHelper().pickImages(isGallery: isGallery);

    if (uploadedFiles == null || uploadedFiles.isEmpty) return null;

    // 🔹 If user selects more than 20 → take only the first 20
    List<XFile> limitedFiles = uploadedFiles.length > limit
        ? uploadedFiles.take(limit).toList()
        : uploadedFiles;

    // Step 2️⃣ Crop all images
    List<CroppedFile> croppedImages = [];
    for (var file in limitedFiles) {
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
          IOSUiSettings(title: 'Crop Image'),
        ],
      );
      if (croppedFile != null) croppedImages.add(croppedFile);
    }

    if (croppedImages.isEmpty) return null;

    // Step 3️⃣ Show Loading Dialog
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, _, __) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                content: const CustomCircularProgressIndicator(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInExpo),
          ),
          child: child,
        );
      },
    );

    // Step 4️⃣ Compress all cropped images
    List<File> compressedImages = [];
    final tempDir = await getTemporaryDirectory();

    for (var croppedImage in croppedImages) {
      final uniqueFileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}_${croppedImage.path.split('/').last}';
      final targetPath = '${tempDir.path}/$uniqueFileName';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        croppedImage.path,
        targetPath,
        quality: 50,
        rotate: 360,
      );

      if (compressedFile != null) {
        compressedImages.add(File(compressedFile.path));
      }
    }

    // Step 5️⃣ Prepare image details payload
    final List<Map<String, dynamic>> imageDetails = [];
    for (var file in compressedImages) {
      final bytes = await file.readAsBytes();
      final size = bytes.length;

      imageDetails.add({
        "type": "image/${file.path.split('.').last}",
        "size": size,
        "subcategoryId": subCategoryId,
      });
    }

    final Map<String, dynamic> payload = {"images": imageDetails};

    // Step 6️⃣ Get signed URLs
    final signedURLResponse = await serviceLocator<ApiConsumer>()
        .post(EndPoints.bulkMediaUrl, data: payload);

    signedURLResponse.fold((l) {
      debugPrint("Error getting signed URLs: $l");
      context.pop();
      return Left(l);
    }, (data) async {
      final List<dynamic> uploadData = data['data'];
      debugPrint("Response signed URLs count: ${uploadData.length}");
      debugPrint("Compressed images count: ${compressedImages.length}");

      if (uploadData.length != compressedImages.length) {
        debugPrint(
            "❌ Mismatch: uploadData(${uploadData.length}) != compressedImages(${compressedImages.length})");
        context.pop();
        throw Exception("Image count mismatch with signed URLs");
      }

      // Step 7️⃣ Upload each image to its corresponding signed URL
      for (int i = 0; i < compressedImages.length; i++) {
        final signedUrl = uploadData[i]['signedUrl'];
        final fileToUpload = XFile(compressedImages[i].path);

        print("Uploading image ${i + 1}/${compressedImages.length}");
        print("fileToUpload.path: ${fileToUpload.path}");
        print("signedUrl: $signedUrl");

        await sendBinaryFileData(file: fileToUpload, signedUrl: signedUrl);
      }

      // Step 8️⃣ Confirm upload
      final List<String> mediaIds =
          uploadData.map<String>((item) => item['mediaId'] as String).toList();

      final Map<String, dynamic> payloadMedia = {"mediaIds": mediaIds};

      await serviceLocator<ApiConsumer>()
          .put("/media/confirm", data: payloadMedia);

      // Step 9️⃣ Return success
      onUploaded(
        UploadImagesEntity(
          mediaIds: mediaIds,
          files: compressedImages.map((e) => XFile(e.path)).toList(),
        ),
      );

      context.pop();
      return const Right(true);
    });

    return null;
  }

  /// Uploads a single file to its signed URL
  Future<void> sendBinaryFileData({
    required XFile file,
    required String signedUrl,
  }) async {
    debugPrint("Uploading binary file to: $signedUrl");

    Uint8List imageBytes = await file.readAsBytes();

    Options options = Options(
      contentType: 'application/octet-stream',
      headers: {
        'Accept': "*/*",
        'Content-Type': 'application/octet-stream',
        'Content-Length': imageBytes.length,
        'Connection': 'keep-alive',
        'User-Agent': 'ClinicPlush',
      },
    );

    await Dio().put(signedUrl, data: imageBytes, options: options);
    debugPrint("✅ Uploaded: ${file.path}");
  }
}

class UploadImagesEntity {
  final List<String> mediaIds;
  final List<XFile> files;

  UploadImagesEntity({
    required this.mediaIds,
    required this.files,
  });
}
