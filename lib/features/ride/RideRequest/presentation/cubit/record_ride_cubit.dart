import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  final record = AudioRecorder();

  RecordRideCubit({required this.repository}) : super(RiderInitial());

  // Start recording
  Future<void> startRecord() async {
    log('startRecorddd${await record.hasPermission()}');
    try {
      log('record.hasPermission');
      if (await record.hasPermission()) {
        log('record.hasPermission');
        Directory tempDir = await getTemporaryDirectory();
        String tempPath =
            '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
        await record.start(const RecordConfig(),
          path: tempPath,
        );
      } else {
        throw Exception('Microphone permission not granted');
      }
    } catch (e) {
      log('Error starting record: $e');
    }
  }

  Future<String?> stopRecord(
      {required String subcategoryId, required String tripId}) async {
    try {
      log('stopRecord');
      String? path = await record.stop();
      mediaUrl(
        tripId: tripId,
        path: path ?? "",
        size: await getFileSize(File(path ?? "")),
        subcategoryId: subcategoryId,
        type: getFileExtension(File(path ?? "")),
      );
      return path;
    } catch (e) {
      log('Error stopping record: $e');
      return null;
    }
  }

  mediaUrl({
    required String type,
    required String path,
    required int size,
    required String subcategoryId,
    required String tripId,
  }) async {
    var response = await repository.mediaUrl(
      size: size,
      subcategoryId: subcategoryId,
      type: type,
    );
    response.fold(
      (l) {},
      (r) {
        sendBinaryFileData(
            file: XFile(path),
            signedUrl: r['data']['signedUrl'],
            mediaId: r['data']['mediaId'],
            tripId: tripId);
      },
    );
  }

  Future<void> sendBinaryFileData({
    required XFile file,
    required String signedUrl,
    required String mediaId,
    required String tripId,
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
      confirmUpload(mediaId: mediaId, tripId: tripId);
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

  confirmUpload({required String mediaId, required String tripId}) async {
    var response = await repository.confirmUpload(mediaId: mediaId);
    response.fold(
      (l) {},
      (r) {
        uploadVice(tripId: tripId, mediaId: mediaId);
      },
    );
  }

  uploadVice({required String tripId, required String mediaId}) async {
    var response =
        await repository.recordVoiceRide(tripId: tripId, mediaId: mediaId);
  }
}
