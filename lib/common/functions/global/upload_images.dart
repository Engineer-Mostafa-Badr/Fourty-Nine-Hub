import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/helper/file_picker_helper.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class UploadImages{
  Future<Either<Failure, bool>?> uploadImage(
      {bool isGallery = true,
        required String subCategoryId,
        required BuildContext context,
        required Function(UploadImagesEntity) onUploaded}) async {
    final file = await FilePickerHelper()
        .pickImages(isGallery: isGallery)
        .then((uploadedFiles) async {
      if (uploadedFiles != null) {
        List<CroppedFile> croppedImages = [];

        for (var file in uploadedFiles) {
          // Crop each image
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

          if (croppedFile != null) {
            croppedImages.add(croppedFile);
          }
        }
        // // Crop the image
        // final CroppedFile? croppedFile = await ImageCropper().cropImage(
        //   sourcePath: file.path,
        //   uiSettings: [
        //     AndroidUiSettings(
        //       toolbarTitle: LocaleKeys.cropImage.localize,
        //       toolbarColor: AppColors.SECONDARY_COLOR,
        //       toolbarWidgetColor: Colors.white,
        //       initAspectRatio: CropAspectRatioPreset.original,
        //       lockAspectRatio: false,
        //     ),
        //     IOSUiSettings(
        //       title: 'Crop Image',
        //     ),
        //   ],
        // );

        XFile finalFile = XFile(croppedImages[0].path??'');
        List<XFile> finalFiles = List<XFile>.generate(croppedImages.length, (index) => XFile(croppedImages[index].path));
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
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator.adaptive(),
                        const SizedBox(height: 20),
                        Text(
                           context.isArabic?'جاري التحميل...':'Loading...',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: 20,
                      bottom: 40,
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
        List<File> compressedImages = [];
        final tempDir = await getTemporaryDirectory();

        // final tempDir = await getTemporaryDirectory();
        final uniqueFileName =
            'compressed_${DateTime.now().millisecondsSinceEpoch}_${finalFile.name}';
        final targetPath = '${tempDir.path}/$uniqueFileName';
        var result = await FlutterImageCompress.compressAndGetFile(
          finalFile.path,
          targetPath,
          quality: 50,
          rotate: 360,
        );



        for (var croppedImage in croppedImages) {
          final uniqueFileName =
              'compressed_${DateTime.now().millisecondsSinceEpoch}_${croppedImage.path.split('/').last}';
          final targetPath = '${tempDir.path}/$uniqueFileName';

          // Compress the image
          var compressedFile = await FlutterImageCompress.compressAndGetFile(
            croppedImage.path,
            targetPath,
            quality: 50,
            rotate: 360,
          );

          if (compressedFile != null) {
            compressedImages.add(File(compressedFile.path));
          }
        }

        final List<Map<String, dynamic>> imageDetails = [];

        for (var file in compressedImages) {
          // Read bytes and calculate size
          final bytes = await file.readAsBytes();
          final size = bytes.length;

          // Add image details to the list
          imageDetails.add({
            "type": "image/${(file.path.split('.').last ?? 'png')}",
            "size": size,
            "subcategoryId": subCategoryId,
          });
        }
        final Map<String, dynamic> payload = {"images": imageDetails};

        // get signed url
        final signedURLResponse =
        await serviceLocator<ApiConsumer>().post(EndPoints.bulkMediaUrl, data: payload);
        // send to w3 storage
        signedURLResponse.fold((l) {
          print(l.toString());
        }, (data) async {
          // log("responseData: ${jsonEncode(data)}");
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
          for(var item in data['data']){


          }
          await sendBinaryFileData(
              file: result!, signedUrl: data['data'][0]['signedUrl'])
              .then((value) async {
            print("amdl;maldmaslkd");
            List<String> mediaIds = [];
            List<String> files = [];
            mediaIds = data['data'].map<String>((item) => item['mediaId'] as String).toList();
            final Map<String, dynamic> payloadMedia = {"mediaIds": imageDetails};

            for(String id in mediaIds){
              await serviceLocator<ApiConsumer>()
                  .put("/media/confirm",data:payloadMedia);
            }
            // await serviceLocator<ApiConsumer>()
            //     .put(EndPoints.confirmUpload(mediaId));
            /* confirmUploadResponse.fold((l) {
              print("object22222");
              return Left(l);
            }, (data) { */
            print("object111");
            onUploaded(UploadImagesEntity(mediaIds: mediaIds, files: compressedImages.map((e)=> XFile(e.path)).toList(),));
            context.pop();

            return const Right(true);
            // });
          });
        });
      }
    });
    return null;
  }

  Future<void> sendBinaryFileData(
      {required XFile file, required String signedUrl}) async {
    print("signedUrl$signedUrl");
    Uint8List image = await file.readAsBytes();
    print("object${image.length}");
    print("object$image");
    String fileName = file.path.split('/').last;

    Options options = Options(contentType: file.mimeType, headers: {
      'Accept': "*/*",
      'Content-Type': 'application/octet-stream',
      'Content-Length': image.length,
      'Connection': 'keep-alive',
      'User-Agent': 'ClinicPlush',
      // 'File-Name': fileName,
    });

    await Dio().put(signedUrl, data: image, options: options);
    print("aasl;das;ld,");
  }
}

class UploadImagesEntity {
  final List<String> mediaIds;
  final List<XFile> files;

  UploadImagesEntity({required this.mediaIds, required this.files});
}
