import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:path_provider/path_provider.dart';

class FindMediaId{

  static Future<String> getMediaId({
    required XFile image,
    required String subCategoryId,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final uniqueFileName =
        'compressed_${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    final targetPath = '${tempDir.path}/$uniqueFileName';

    var result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 50,
      rotate: 360,
    );

    final bytes = await result!.readAsBytes();
    int size = bytes.length;

    final signedURLResponse = await serviceLocator<ApiConsumer>().post(
      EndPoints.mediaUrl,
      data: {
        "type": "image/${image.mimeType ?? 'png'}",
        "size": size,
        "subcategoryId": subCategoryId,
      },
    );

    return await signedURLResponse.fold((l) {
      log("Upload Error: $l");
      throw Exception("Failed to get signed URL");
    }, (data) async {
      log("responseData: ${jsonEncode(data)}");

      final uploadTargetPath =
          '${(await getTemporaryDirectory()).path}/compressed_${DateTime.now().millisecondsSinceEpoch}_${image.name}';

      var compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        uploadTargetPath,
        quality: 50,
        rotate: 360,
      );

      await sendBinaryFileData(
        file: compressedFile!,
        signedUrl: data['data']['signedUrl'],
      );

      final mediaId = data['data']['mediaId'];
      await serviceLocator<ApiConsumer>().put(EndPoints.confirmUpload(mediaId));
      return mediaId;
    });
  }


  static Future<void> sendBinaryFileData(
      {required XFile file, required String signedUrl}) async {
    Uint8List image = await file.readAsBytes();
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