import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
// ignore: unused_import
import 'package:fourtyninehub/core/data/models/meeting_error_message_model.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/zoom/data/model/room_response_error_model.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../core/error/failure.dart';

abstract class MeetingDataSource {
  Future<Either<Failure, void>> addRoom(MeetingParams params);
  Future<Response?> joinRoom(MeetingParams params);
  Future<Either<Failure, void>> endRoom(MeetingParams params);
}

class MeetingDataSourceImpl extends MeetingDataSource {
  final ApiConsumer apiConsumer;
  final Dio _dio;

  MeetingDataSourceImpl(this.apiConsumer, this._dio);
  @override
  Future<Either<Failure, void>> addRoom(MeetingParams params) async {
    final result =
        await apiConsumer.post(EndPoints.createMeeting, data: params.toJson());
    return result.fold((l) {
      // throw MeetingErrorMessageModel.fromJson(l);
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }

  @override
  Future<Either<Failure, void>> endRoom(MeetingParams params) async {
    final result = await apiConsumer.put(EndPoints.endMeeting(params.id));
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Response?> joinRoom(MeetingParams params) async {
    final url = EndPoints.joinMeeting(params.id);

    try {
      final response = await _dio.put(url);

      if (response.statusCode == 200) {
        return response;
        // Handle success
      } else {
        // Handle other status codes
        return response;
      }
    } on DioException catch (e) {
      // Handle network error
      if (e.response != null && e.response?.statusCode == 404) {
        // Extract the error message specifically for 404 status code
        final String errorMessage = e.response?.data['error']['message'] ?? '';
        final Map<String, dynamic> localizedMessage = json.decode(errorMessage);

        // Show the localized message in a Snackbar
        showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          (localizedMessage['en'] ?? 'Room not registered'),
        );
        return e.response;
      } else if (e.response != null) {
        // Handle other status codes
        showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          ('Error: ${e.response?.statusMessage}'),
        );
        return e.response;
      } else {
        // Handle cases where no response was returned (e.g., network error)
        showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          ('Failed to join meeting. Please try again later.'),
        );
        return null;
      }
    }
  }
}
