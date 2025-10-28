import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:path/path.dart' as path;

class UploadRecord{
  mediaUrl({
    required String path,
    required String subcategoryId,
    required String tripId,
    required Function(String mediaId, String tripId) onSuccess
  }) async {
    var response = await serviceLocator<ApiConsumer>().post(
      EndPoints.mediaUrl, data: {
      "type": "audio/${getFileExtension(File(path))}",
      "size": await getFileSize(File(path)),
      "subcategoryId": subcategoryId
    }
    );
    response.fold(
          (l) {},
          (r) {
        sendBinaryFileData(
            file: XFile(path),
            signedUrl: r['data']['signedUrl'],
            mediaId: r['data']['mediaId'],
            tripId: tripId,
            onSuccess: (mediaId, tripId) => onSuccess(mediaId, tripId));
      },
    );
  }

  Future<void> sendBinaryFileData({
    required XFile file,
    required String signedUrl,
    required String mediaId,
    required String tripId,
    required Function(String mediaId, String tripId) onSuccess
  }) async {
    Uint8List image = await file.readAsBytes();
    log(image.length.toString(), name: 'signedUrlll');
    log(signedUrl.toString(), name: 'signedUrlll');
    Options options = Options(contentType: file.mimeType, headers: {
      'Accept': "*/*",
      'Content-Type': 'application/octet-stream',
      'Content-Length': image.length,
      'Connection': 'keep-alive',
      'User-Agent': 'ClinicPlush',
      // 'File-Name': fileName,
    });
    var response = await Dio().put(signedUrl,
        data: Stream.fromIterable(image.map((e) => [e])), options: options);
    log(response.data.toString(), name: "uploadImage");
    log(response.statusCode.toString(), name: "uploadImage");
    if (response.statusCode == 200) {
      confirmUpload(mediaId: mediaId, tripId: tripId,
      onSuccess: (mediaId, tripId) => onSuccess(mediaId, tripId)
      );
    }
  }

  getFileExtension(File file) {
    log("image/${path.extension(file.path).substring(1)}");
    if (file.existsSync()) {
      return path.extension(file.path).substring(1);
    } else {
      return "image/png";
    }
  }

  Future<int> getFileSize(File file) async {
    final bytes = await file.readAsBytes();
    return bytes.length;
  }

  confirmUpload({required String mediaId, required String tripId,required Function(String mediaId, String tripId) onSuccess}) async {
    var response = await serviceLocator<ApiConsumer>().put(EndPoints.confirmUpload(mediaId));
    response.fold(
          (l) {},
          (r) {
            log(mediaId.toString(), name: "uploadImagemediaId");
            log(r.toString(), name: "uploadImagemediaId");
            onSuccess(mediaId, tripId);
        // uploadVice(tripId: tripId, mediaId: mediaId);
      },
    );
  }
}