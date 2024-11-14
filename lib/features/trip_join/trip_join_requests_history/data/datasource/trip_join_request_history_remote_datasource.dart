// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/data/models/trip_join_request_model/trip_join_request_model.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/data/models/tripjoin_request_history_model/tripjoin_request_history_model.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_entity.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_history_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';

abstract class TripJoinRequestHistoryRemoteDataSource {
  Future<Either<Failure, List<TripJoinMyRequestEntity>>> fetchMyTripJoinAds(
      {required int page});
  Future<Either<Failure, bool>> deleteTrip(
      {required String subCategory, required String url, required String id});
  Future<Either<Failure, List<TripJoinRequestHistoryEntity>>> getRequests(
      {required String id, required int page});
}

class TripJoinRequestHistoryRemoteDataSourceImp
    implements TripJoinRequestHistoryRemoteDataSource {
  final ApiConsumer apiConsumer;
  TripJoinRequestHistoryRemoteDataSourceImp({
    required this.apiConsumer,
  });

  @override
  Future<Either<Failure, List<TripJoinMyRequestEntity>>> fetchMyTripJoinAds(
      {required int page}) async {
    const t = 'fetchMyTripJoinAds - TripJoinRequestHistoryRemoteDataSource';
    final response = await apiConsumer.get(
      EndPoints.getAllMyTripJoin,
      queryParameters: {
        'subCategory': UIConst.tripJoinCategoryId,
        'limit': 10,
        'page': page,
      },
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        List<TripJoinMyRequestModel> trips =
            data['data']['trips']['docs'].map<TripJoinMyRequestModel>(
          (json) {
            final TripJoinMyRequestModel trip =
                TripJoinMyRequestModel.fromJson(json);
            trip.subscribedPremium = data['data']['subscribedPremium'] as bool?;
            trip.subscriptionEndDate =
                (data['data']['subscriptionEndDate'] as num?)?.toInt();
            trip.hasNextPage = data['data']['trips']['hasNextPage'] as bool?;
            trip.nextPage =
                (data['data']['trips']['nextPage'] as num?)?.toInt();
            return trip;
          },
        ).toList();

        return Right(pr(trips, t));
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteTrip(
      {required String subCategory,
      required String url,
      required String id}) async {
    const t = 'deleteTrip - TripJoinRequestHistoryRemoteDataSource';
    final response = await apiConsumer.delete(
      EndPoints.deleteTrip(url, id),
      queryParameters: {
        'subCategory': subCategory,
        // 'subCategory': UIConst.tripJoinCategoryId,
      },
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        pr('ome with me trip deleted successfully', t);
        return const Right(true);
      },
    );
  }

  @override
  Future<Either<Failure, List<TripJoinRequestHistoryEntity>>> getRequests(
      {required String id, required int page}) async {
    // throw UnimplementedError();
    const t = 'getRequests - TripJoinRequestHistoryRemoteDataSource';
    final response = await apiConsumer.get(
      EndPoints.getRequest(id),
      queryParameters: {
        'subCategory': UIConst.tripJoinCategoryId,
        'limit': 10,
        'page': page,
      },
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        List<TripjoinRequestHistoryModel> requests =
            data['data']['requests']['docs'].map<TripjoinRequestHistoryModel>(
          (json) {
            final TripjoinRequestHistoryModel request =
                TripjoinRequestHistoryModel.fromJson(json);
            request.hasNextPage =
                data['data']['requests']['hasNextPage'] as bool?;
            request.nextPage =
                (data['data']['requests']['nextPage'] as num?)?.toInt();
            return request;
          },
        ).toList();

        return Right(pr(requests, t));
      },
    );
  }
}
