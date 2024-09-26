import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/data/model/live_create_response_model.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/data/model/topic_model.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/live_create_response_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/topic_entity.dart';

import '../../../../../routes/pages.dart';
import '../../domain/usecases/create_live_use_case.dart';

abstract class LiveDataSource {
  Future<Either<Failure, LiveCreateResponseEntity>> createLive(
      CreateLiveParams params);

  Future<Either<Failure, List<LiveEntity>>> getAllRooms();

  Future<Either<Failure, List<TopicEntity>>> getAllTopics();
}

class LiveDataSourceImpl extends LiveDataSource {
  final ApiConsumer _apiConsumer;

  LiveDataSourceImpl({required ApiConsumer apiConsumer})
      : _apiConsumer = apiConsumer;

  @override
  Future<Either<Failure, LiveCreateResponseEntity>> createLive(
      CreateLiveParams params) async {
    final result =
        await _apiConsumer.post(EndPoints.createLive, data: params.toJson());
    return result.fold((l) => Left(l), (r) {
      return Right(LiveCreateResponseModel.fromJson(r['data']));
    });
  }

  @override
  Future<Either<Failure, List<LiveEntity>>> getAllRooms() {
    // TODO: implement getAllRooms
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TopicEntity>>> getAllTopics() async {
    final result = await _apiConsumer.get(EndPoints.allLiveTopics, headers: {
      'Accept-Language': AppPages
          .router.configuration.navigatorKey.currentContext!.locale
          .toString()
    });
    return result.fold((l) => Left(l), (r) {
      final List<TopicEntity> topics =
          List.from(r['data']).map((e) => TopicModel.fromJson(e)).toList();
      return Right(topics);
    });
  }
}
