import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/error/failure.dart';
import '../helper/file_picker_helper.dart';

class UploadFile {
  Future<Either<Failure, String>> uploadImage(
      {bool isGallery = true, required String subCategoryId}) async {
    final file = await FilePickerHelper().pickMedia(isGallery: isGallery);
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
      signedURLResponse.fold((l) => Left(l), (data) async {
        if (await sendBinaryFileData(
            file: file, signedUrl: data['data']['signedUrl'])) {
          // confirm uploading
          final mediaId = data['data']['mediaId'];
          final confirmUploadResponse = await serviceLocator<ApiConsumer>()
              .put(EndPoints.confirmUpload(mediaId));
          confirmUploadResponse.fold((l) => Left(l), (data) => Right(mediaId));
        }
      });
    }
    return const Left(UnknownFailure());
  }

  Future<bool> sendBinaryFileData(
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
    return true;
  }
}
