import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/data/models/pick_me_card_model/pick_me_card_model.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/entities/pickme_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';

abstract class ViewAllPickMeRemoteDataSource {
  Future<Either<Failure, List<PickMeCardEntity>>> getAllPickMe(
      {required int page});
  // Future<Either<Failure, bool>> requestTripJoin(
  //     {required String addId,
  //     required String mobile,
  //     bool premuimRequest = false});
}

class ViewAllPickMeRemoteDataSourceImp
    implements ViewAllPickMeRemoteDataSource {
  final ApiConsumer apiConsumer;

  ViewAllPickMeRemoteDataSourceImp({required this.apiConsumer});
  @override
  Future<Either<Failure, List<PickMeCardEntity>>> getAllPickMe(
      {required int page}) async {
    const t = "ViewAllPickMeRemoteDataSourceImp - getAllPickMe ";
    final response = await apiConsumer.get(
      EndPoints.getAllPickMe,
      queryParameters: {
        'subCategory': UIConst.pickmeCategoryId,
        'page': page,
        'limit': 10,
      },
    );

    return response.fold(
      (failure) {
        pr(failure, t);
        return Left(failure);
      },
      (data) {
        List rawData = data['data']['updatedTrips'];
        if (rawData.isEmpty) {
          pr('No data found', t);
          return const Right([]);
        }
        List<PickMeCardModel> allCards = rawData.map<PickMeCardModel>(
          (e) {
            final pickMeCardModel = PickMeCardModel.fromJson(e);
            pickMeCardModel.subscribedPremium =
                data['data']['subscribedPremium'] as bool?;
            pickMeCardModel.hasNextPage =
                data['data']['pagination']['hasNextPage'] as bool?;
            pickMeCardModel.nextPage =
                data['data']['pagination']['nextPage'] as int?;
            return pickMeCardModel;
          },
        ).toList();
        pr(allCards, t);
        return Right(allCards);
      },
    );
  }

  // @override
  // Future<Either<Failure, bool>> requestTripJoin(
  //     {required String addId,
  //     required String mobile,
  //     bool premuimRequest = false}) async {
  //   final response = await apiConsumer.post(
  //     EndPoints.makeTripJoinRequest(addId),
  //     data: {
  //       'phone': mobile,
  //       'isPremium': premuimRequest,
  //     },
  //   );

  //   return response.fold(
  //     (failure) {
  //       // pr(failure);
  //       return Left(failure);
  //     },
  //     (data) {
  //       // pr('request completed successfully');
  //       return const Right(true);
  //     },
  //   );
  // }
}
