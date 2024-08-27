import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:image_picker/image_picker.dart';

class CreateTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  CreateTripCubit({required this.repository}) : super(ShippingInitial());
  createTrip({required RequestModel model}) async {
    var response = await repository.createTrip(model: model);
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) async {
        emit(
          SuccessCreateTrip(
              message:
                  "Your request has been sent successfully, waiting for the driver's response"),
        );
        // for (var item in r.images) {
        //   await sendBinaryFileData(file: item.image, signedUrl: item.sigendUrl);
        //   var confirmResponse = await repository.confirm(id: item.mediaId);
        // }
      },
    );
  }

  Future<void> sendBinaryFileData({
    required XFile file,
    required String signedUrl,
  }) async {
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

    var response = await Dio().put(signedUrl,
        data: Stream.fromIterable(image.map((e) => [e])), options: options);
  }
}
