import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:path/path.dart' as path;

class RideMethodHelper {
  getSignUrl(
      {required Map<String, dynamic>? data,
        required String url,
        required Function(Map<String, dynamic> data) onSuccess}) async {
    var response = await serviceLocator<ApiConsumer>().put(url,data: data);
    response.fold(
          (l) {},
          (r) async {
        onSuccess(r);
      },
    );
  }

  getFileExtension(File file) {
    log("image/${path.extension(file.path).substring(1)}");
    if (file.existsSync()) {
      return "image/${path.extension(file.path).substring(1)}";
    } else {
      return "image/png";
    }
  }

  getFileSize(File file) async {
    final bytes = await file.readAsBytes();
    return bytes.length;
  }

  Future<void> sendBinaryFileData({
    required XFile file,
    required String signedUrl,
  }) async {
    log(signedUrl, name: "signedUrlsignedUrl");
    Uint8List image = await file.readAsBytes();

    Options options = Options(contentType: file.mimeType, headers: {
      'Accept': "*/*",
      'Content-Type': 'application/octet-stream',
      'Content-Length': image.length,
      'Connection': 'keep-alive',
      'User-Agent': 'ClinicPlush',
    });

    var response = await Dio().put(signedUrl,
        data: Stream.fromIterable(image.map((e) => [e])), options: options);
    log(response.data.toString(), name: "uploadImage");
    log(response.statusCode.toString(), name: "uploadImage");
  }

  successUploadImage({Map<String, dynamic>? data, required String url}) async {
    await serviceLocator<ApiConsumer>().put(url,data: data);
  }

  uploadDriverId(
      {required XFile idImageInFront,
      required XFile idImageInBehind,
      required String idExpiryDate}) async {
    getSignUrl(
      data: {
        "expireDate": idExpiryDate,
        "idFront": {
          "type": await getFileExtension(File(idImageInFront.path)),
          "size": await getFileSize(File(idImageInFront.path))
        },
        "idBehind": {
          "type": await getFileExtension(File(idImageInBehind.path)),
          "size": await getFileSize(File(idImageInBehind.path))
        }
      },
      url: "${EndPoints.developmentBaseUrl}/ride/info/id",
      onSuccess: (data) async {
        await sendBinaryFileData(
            file: XFile(idImageInFront.path),
            signedUrl: data['data']['idBehindData']['signedUrl'])
            .then(
              (value) async {
            await sendBinaryFileData(
                file: XFile(idImageInBehind.path),
                signedUrl: data['data']['idFrontData']['signedUrl'])
                .then(
                  (value) async {
                await successUploadImage(data: {
                  "frontMediaId": data['data']['idFrontData']['mediaId'],
                  "behindMediaId": data['data']['idBehindData']['mediaId']
                }, url: "${EndPoints.developmentBaseUrl}/ride/info/success-upload");
              },
            );
          },
        );
      },
    );
  }

}