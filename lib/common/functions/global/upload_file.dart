import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';

import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/error/failure.dart';
import '../helper/file_picker_helper.dart';

 class UploadFile {
  Future<Either<Failure, bool>?> uploadImage(
      {bool isGallery = true,
      required String subCategoryId,
      required Function(UploadFileEntity) onUploaded}) async {
    final file = await FilePickerHelper()
        .pickImage(isGallery: isGallery)
        .then((file) async {
      if (file != null) {
        final bytes = await file.readAsBytes();
        int size = bytes.length;
        // get signed url
        final signedURLResponse =
            await serviceLocator<ApiConsumer>().post(EndPoints.mediaUrl, data: {
          "type": "image/${file.mimeType ?? 'png'}",
          "size": size,
          "subcategoryId": subCategoryId
        });
        // send to w3 storage
        signedURLResponse.fold((l) {}, (data) async {
          log("response: ${jsonEncode(data)}");
          await sendBinaryFileData(
                  file: file, signedUrl: data['data']['signedUrl'])
              .then((value) async {
            final mediaId = data['data']['mediaId'];
            final confirmUploadResponse = await serviceLocator<ApiConsumer>()
                .put(EndPoints.confirmUpload(mediaId));
            /* confirmUploadResponse.fold((l) {
              print("object22222");
              return Left(l);
            }, (data) { */
            print("object111");
            onUploaded(UploadFileEntity(mediaId: mediaId, file: file));
            return const Right(true);
            // });
          });
        });
      }
    });
    return null;
  }

  static Future<String?> uploadPickedFile(
      {required File file, required String subCategoryId}) async {
    try {
      final fileInBytes = await file.readAsBytes();
      String? mediaId;
      final uploadUrlResponse =
          await serviceLocator<ApiConsumer>().post(EndPoints.mediaUrl, data: {
        "type": "${file.type.name}/${file.path.split('.').last}",
        "size": fileInBytes.length,
        "subcategoryId": subCategoryId,
      });

      uploadUrlResponse.fold(
        (l) {
          CliLogger.error("can't get upload url");
        },
        (data) async {
          final uploadUrl = data['data']['signedUrl'];
          mediaId = data['data']['mediaId'];
          Options options = Options(contentType: file.type.name, headers: {
            'Accept': "*/*",
            'Content-Type': 'application/octet-stream',
            'Content-Length': fileInBytes.length,
            'Connection': 'keep-alive',
            'User-Agent': 'ClinicPlush',
          });

          await Dio().put(uploadUrl,
              data: Stream.fromIterable(fileInBytes.map((e) => [e])),
              options: options);
        },
      );

      return mediaId;
    } catch (e) {
      CliLogger.error("can't upload file $e");
      rethrow;
    }
  }

  Future<void> sendBinaryFileData(
      {required XFile file, required String signedUrl}) async {
    Uint8List image = await file.readAsBytes();
    String fileName = file.path.split('/').last;

    Options options = Options(contentType: file.mimeType, headers: {
      'Accept': "*/*",
      'Content-Type': 'application/octet-stream',
      'Content-Length': image.length,
      'Connection': 'keep-alive',
      'User-Agent': 'ClinicPlush',
      // 'File-Name': fileName,
    });

    await Dio().put(signedUrl,
        data: Stream.fromIterable(image.map((e) => [e])), options: options);
  }
}

class UploadFileEntity {
  final String mediaId;
  final XFile file;

  UploadFileEntity({required this.mediaId, required this.file});
}
