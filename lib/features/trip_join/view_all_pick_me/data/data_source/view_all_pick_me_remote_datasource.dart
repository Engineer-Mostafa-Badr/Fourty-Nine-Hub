import 'package:dartz/dartz.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../helpers/print_helper.dart';
import '../models/pick_me_card_model/pick_me_card_model.dart';
import '../../domain/entities/pickme_entity.dart';
import '../../../../../res/style/const.dart';
import '../../../../../service_locator/service_locator.dart';

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
        'userId': serviceLocator<UserCubit>().isLoggedIn
            ? serviceLocator<UserCubit>().state.data?.id
            : '',
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
