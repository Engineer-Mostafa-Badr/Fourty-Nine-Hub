// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SentFileCard extends StatefulWidget {
  const SentFileCard({
    super.key,
    required this.messageEntity,
  });
  final MessageEntity messageEntity;
  @override
  State<SentFileCard> createState() => _SentFileCardState();
}

class _SentFileCardState extends State<SentFileCard> {
  String? fileName;
  String? fileSize;
  String? fileExtension;

  @override
  void initState() {
    // initTheSocket();
    fileName = getFileName();
    log(fileName.toString());
    fileExtension = extension(fileName!).toUpperCase();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 6, top: 6),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 64,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.MESSAGE_COLOR,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0.1,
                          blurRadius: 5,
                          offset: const Offset(
                            0,
                            0,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            log("Downloading...");
                            downloadAndOpenFile(
                              fileUrl: widget.messageEntity.media[0].url,
                            );
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.insert_drive_file,
                                      size: 40,
                                      color: AppColors.GREY_DARK_COLOR,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            fileName!,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.mediumText(
                                                color:
                                                    AppColors.GREY_DARK_COLOR),
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: getFileSizeAsync(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return Text(
                                                '${fileSize ?? ''}'
                                                ' - '
                                                '$fileExtension',
                                                style: Styles.smallText(
                                                    color: AppColors
                                                        .GREY_DARK_COLOR),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.messageEntity.time,
                              style: Styles.smallText(
                                  color: AppColors.GREY_DARK_COLOR),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFileName() {
    String fileUrl = widget.messageEntity.media[0].url;

    String fileName = extractFileName(fileUrl);
    String cleanedFileName = cleanFileName(fileName);
    // print('file name : $cleanedFileName'); // Output: pdf-test.pdf
    return cleanedFileName;
  }

  String extractFileName(String url) {
    Uri uri = Uri.parse(url);
    String path = uri.path;
    List<String> segments = path.split('/');
    return segments.last;
  }

  String cleanFileName(String fileName) {
    // Assuming the format is UUID-fileName.pdf
    return fileName.substring(37);
  }

  Future<void> getFileSizeAsync() async {
    log("getFileSizeAsync");
    fileSize = await getFileSize(
      fileUrl: widget.messageEntity.media[0].url,
    );
  }

  Future<String?> getFileSize({required String fileUrl}) async {
    try {
      final dio = Dio();

      log("before response");
      final response = await dio.head(
        fileUrl,
        options: Options(validateStatus: (status) => status! < 500),
      );
      log("after response");

      if (response.statusCode == 200) {
        log("200 OK");
        // Content-Length header contains the file size in bytes
        String? contentLengthHeader = response.headers.value('content-length');

        if (contentLengthHeader != null) {
          log("contentLengthHeader");
          int fileSizeInBytes = int.parse(contentLengthHeader);

          // Convert the file size to a formatted string
          return formatFileSize(fileSizeInBytes: fileSizeInBytes);
        } else {
          log("Content-Length header not found in the response.");
        }
      } else if (response.statusCode == 403) {
        log("403 Forbidden - Check URL permissions or headers.");
      } else {
        log("Failed to fetch file size. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    }
    return null;
  }

  String formatFileSize({required int fileSizeInBytes}) {
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;

    if (fileSizeInBytes < kb) {
      return '$fileSizeInBytes B';
      log('$fileSizeInBytes B');
    } else if (fileSizeInBytes < mb) {
      double sizeInKB = fileSizeInBytes / kb;
      log('${sizeInKB.toStringAsFixed(2)} KB');
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else if (fileSizeInBytes < gb) {
      double sizeInMB = fileSizeInBytes / mb;
      log('${sizeInMB.toStringAsFixed(2)} MB');
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else {
      double sizeInGB = fileSizeInBytes / gb;
      log('${sizeInGB.toStringAsFixed(2)} GB');
      return '${sizeInGB.toStringAsFixed(2)} GB';
    }
  }
}

Future<void> downloadAndOpenFile({required String fileUrl}) async {
  Dio dio = Dio();

  try {
    var dir = await getDownloadsDirectory();
    String fileName = fileUrl.split('/').last;
    String savePath = '${dir!.path}/$fileName';
    // print(savePath);

    // Check if the file already exists
    if (await File(savePath).exists()) {
      // print('File already exists, opening...');
      // Open the existing file

      OpenFile.open(savePath);
    } else {
      // File doesn't exist, download it
      await dio.download(fileUrl, savePath);

      OpenFile.open(savePath);
    }
  } catch (e) {
    // print("Error: $e");
  }
}
