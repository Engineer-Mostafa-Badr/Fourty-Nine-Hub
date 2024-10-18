import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadAndOpenFile({required String fileUrl}) async {
  Dio dio = Dio();

  try {
    var dir = await getDownloadsDirectory();

    // Parse the URL to get the file name
    String fileName = Uri.parse(fileUrl).pathSegments.last;

    String savePath = '${dir!.path}/$fileName';
    log(savePath);

    // Check if the file already exists
    if (await File(savePath).exists()) {
      log('File already exists, opening...');
      // Open the existing file
      OpenFile.open(savePath);
    } else {
      // File doesn't exist, download it
      log("download file");
      await dio.download(fileUrl, savePath);
      log("file is downloaded");
      OpenFile.open(savePath);
    }
  } catch (e) {
    log("Error: $e");
  }
}
