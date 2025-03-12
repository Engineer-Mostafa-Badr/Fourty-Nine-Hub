import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/error/failure.dart';
import '../helper/file_picker_helper.dart';

class UploadFile {
  Future<Either<Failure, bool>?> uploadImage(
      {bool isGallery = true,
      required String subCategoryId, bool? hasLoading,
      required BuildContext context,
      required Function(UploadFileEntity) onUploaded}) async {
    final file = await FilePickerHelper()
        .pickImage(isGallery: isGallery)
        .then((file) async {
      if (file != null) {
        // Crop the image
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

        XFile finalFile = XFile(croppedFile?.path??'');
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
        if(result == null) {
          context.pop();
        }

        final bytes = await result!.readAsBytes();
        int size = bytes.length;
        // get signed url
        final signedURLResponse =
            await serviceLocator<ApiConsumer>().post(EndPoints.mediaUrl, data: {
          "type": "image/${finalFile.mimeType ?? 'png'}",
          "size": size,
          "subcategoryId": subCategoryId
        });
        // send to w3 storage
        signedURLResponse.fold((l) {
          print(l.toString());
        }, (data) async {
          if(hasLoading!=false)showLoadingDialog(context);

          log("responseData: ${jsonEncode(data)}");
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
          await sendBinaryFileData(
                  file: result!, signedUrl: data['data']['signedUrl'])
              .then((value) async {
            print("amdl;maldmaslkd");
            final mediaId = data['data']['mediaId'];
            final confirmUploadResponse = await serviceLocator<ApiConsumer>()
                .put(EndPoints.confirmUpload(mediaId));
            /* confirmUploadResponse.fold((l) {
              print("object22222");
              return Left(l);
            }, (data) { */
            print("object111");
            onUploaded(UploadFileEntity(mediaId: mediaId, file: finalFile));

            return const Right(true);
            // });
          });
          if(hasLoading!=false)context.pop();

        });
      }
    });
    return null;
  }

  Future<Either<Failure, bool>?> uploadAudio({
    bool isGallery = true,
    required String subCategoryId,
    required Function(UploadFileEntity) onUploaded,
  }) async {
    final file = await FilePickerHelper()
        .pickMedia(isGallery: isGallery)
        .then((file) async {
      if (file != null) {
        final bytes = await file.readAsBytes();
        int size = bytes.length;
        // Step 2: Get a signed URL for uploading.
        final signedURLResponse = await serviceLocator<ApiConsumer>().post(
          EndPoints.mediaUrl,
          data: {
            "type": "audio/${file.mimeType ?? 'mp3'}",
            "size": size,
            "subcategoryId": subCategoryId,
          },
        );

        // Step 3: Handle the signed URL response.
        return signedURLResponse.fold(
          (failure) {
            // Log and handle failure in getting signed URL.
            print(failure.toString());
            return Left(failure);
          },
          (data) async {
            log("Signed URL response: ${jsonEncode(data)}");

            // Step 4: Upload the audio to the signed URL.
            await sendBinaryFileData(
              file: file,
              signedUrl: data['data']['signedUrl'],
            ).then((value) async {
              // Step 5: Confirm the upload.
              final mediaId = data['data']['mediaId'];
              final confirmUploadResponse = await serviceLocator<ApiConsumer>()
                  .put(EndPoints.confirmUpload(mediaId));

              // Handle the confirmation response.
              confirmUploadResponse.fold(
                (failure) {
                  print("Error confirming upload: $failure");
                  return Left(failure);
                },
                (confirmation) {
                  print("Upload confirmed.");
                  // Pass the uploaded file details to the callback function.
                  onUploaded(UploadFileEntity(mediaId: mediaId, file: file));
                  return const Right(true);
                },
              );
            });
          },
        );
      }
    });
    return null;
  }

  Future<Either<Failure, bool>?> uploadVideo({
    bool isGallery = true,
    required String subCategoryId,
    required Function(UploadFileEntity) onUploaded,
  }) async {
    final file = await FilePickerHelper()
        .pickVideo(
            isGallery:
                isGallery) // Assuming you have a method to pick video files
        .then((file) async {
      if (file != null) {
        final bytes = await file.readAsBytes();
        int size = bytes.length;
        // Get signed URL
        final signedURLResponse =
            await serviceLocator<ApiConsumer>().post(EndPoints.mediaUrl, data: {
          "type":
              "video/${file.mimeType ?? 'mp4'}", // Change to video MIME type
          "size": size,
          "subcategoryId": subCategoryId
        });

        // Send to W3 storage
        signedURLResponse.fold((l) {
          print(l.toString());
        }, (data) async {
          log("responseData: ${jsonEncode(data)}");
          await sendBinaryFileData(
                  file: file, signedUrl: data['data']['signedUrl'])
              .then((value) async {
            final mediaId = data['data']['mediaId'];
            final confirmUploadResponse = await serviceLocator<ApiConsumer>()
                .put(EndPoints.confirmUpload(mediaId));

            confirmUploadResponse.fold((l) {
              return Left(l);
            }, (data) {
              onUploaded(UploadFileEntity(mediaId: mediaId, file: file));
              return const Right(true);
            });
          });
        });
      }
    });
    return null;
  }

  static Future<String?> uploadPickedFile({
    required File file,
    required String subCategoryId,
  }) async {
    try {
      final fileInBytes = await file.readAsBytes();
      String? mediaId;
      CliLogger.info("Creating upload URL for: ${file.path}");

      log("file name + path is : ${file.type.name == 'document' ? file.type.name.substring(0, 3) : file.type.name}/${file.path.split('.').last}");
      log("file path is : ${file.path.split('/').last}");
      final uploadUrlResponse = await serviceLocator<ApiConsumer>().post(
        EndPoints.mediaUrl,
        data: {
          "type":
              "${file.type.name == 'document' ? file.type.name.substring(0, 3) : file.type.name}/${file.path.split('.').last}",
          "size": fileInBytes.length,
          "fileName": file.path.split('/').last,
          "subcategoryId": subCategoryId,
        },
      ); // mark as deleveerd , database, creating new chat

      await uploadUrlResponse.fold(
        (l) {
          CliLogger.error("Can't get upload URL");
        },
        (data) async {
          CliLogger.info(
              "Upload URL: ${data['data']['signedUrl']}\nMediaId: ${data['data']['mediaId']}");
          final uploadUrl = data['data']['signedUrl'];
          mediaId = data['data']['mediaId'];

          final options = Options(
            contentType: file.type.name,
            headers: {
              'Accept': "*/*",
              'Content-Type': 'application/octet-stream',
              'Content-Length': fileInBytes.length,
              'Connection': 'keep-alive',
              'User-Agent': 'ClinicPlush',
            },
          );

          CliLogger.info("Uploading file: ${file.path}");
          await Dio().put(uploadUrl, data: fileInBytes, options: options);
          CliLogger.success("File uploaded: ${file.path}");
        },
      );

      return mediaId;
    } catch (e) {
      CliLogger.error("Can't upload file: $e");
      return null;
    }
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

class UploadFile2 {
  Future<Either<Failure, bool>?> uploadImage({
    required XFile file, // Change to XFile
    required String subCategoryId,
    required Function(UploadFileEntity) onUploaded,
  }) async {
    try {
      final bytes = await file.readAsBytes(); // XFile method
      int size = bytes.length;

      // Step 1: Get a signed URL
      final signedURLResponse = await serviceLocator<ApiConsumer>().post(
        EndPoints.mediaUrl,
        data: {
          "type": "image/${file.path.split('.').last}",
          "size": size,
          "subcategoryId": subCategoryId,
        },
      );

      return signedURLResponse.fold((failure) {
        print("Error getting signed URL: $failure");
        return Left(failure);
      }, (data) async {
        final signedUrl = data['data']['signedUrl'];
        final mediaId = data['data']['mediaId'];

        // Step 2: Upload the image to the signed URL
        await sendBinaryFileData(file: file, signedUrl: signedUrl);

        // Step 3: Confirm the upload
        final confirmUploadResponse = await serviceLocator<ApiConsumer>()
            .put(EndPoints.confirmUpload(mediaId));

        return confirmUploadResponse.fold((failure) {
          print("Error confirming upload: $failure");
          return Left(failure);
        }, (_) {
          onUploaded(
              UploadFileEntity(mediaId: mediaId, file: file)); // XFile here
          return const Right(true);
        });
      });
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<Either<Failure, bool>?> uploadVideo({
    required XFile file, // Change to XFile
    required String subCategoryId,
    required Function(UploadFileEntity) onUploaded,
  }) async {
    try {
      final bytes = await file.readAsBytes(); // XFile method
      int size = bytes.length;

      // Step 1: Get a signed URL
      final signedURLResponse = await serviceLocator<ApiConsumer>().post(
        EndPoints.mediaUrl,
        data: {
          "type": "video/${file.path.split('.').last}",
          "size": size,
          "subcategoryId": subCategoryId,
        },
      );

      return signedURLResponse.fold((failure) {
        print("Error getting signed URL: $failure");
        return Left(failure);
      }, (data) async {
        final signedUrl = data['data']['signedUrl'];
        final mediaId = data['data']['mediaId'];

        // Step 2: Upload the video to the signed URL
        await sendBinaryFileData(file: file, signedUrl: signedUrl);

        // Step 3: Confirm the upload
        final confirmUploadResponse = await serviceLocator<ApiConsumer>()
            .put(EndPoints.confirmUpload(mediaId));

        return confirmUploadResponse.fold((failure) {
          print("Error confirming upload: $failure");
          return Left(failure);
        }, (_) {
          onUploaded(
              UploadFileEntity(mediaId: mediaId, file: file)); // XFile here
          return const Right(true);
        });
      });
    } catch (e) {
      print("Error uploading video: $e");
      return null;
    }
  }

  Future<void> sendBinaryFileData({
    required XFile file, // Change to XFile
    required String signedUrl,
  }) async {
    final fileBytes = await file.readAsBytes(); // XFile method
    final options = Options(
      contentType: 'application/octet-stream',
      headers: {
        'Content-Length': fileBytes.length,
      },
    );

    await Dio().put(signedUrl, data: fileBytes, options: options);
  }
}

class UploadFileEntity {
  final String mediaId;
  final XFile file;

  UploadFileEntity({required this.mediaId, required this.file});
}
