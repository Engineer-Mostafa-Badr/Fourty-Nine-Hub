import 'package:dartz/dartz.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import 'subscription_premium_const_data.dart';
import '../models/get_requests_pick_me_model.dart';
import '../../../helpers/print_helper.dart';

abstract class GetRequestsPickMeRemoteDataSource {
  Future<Either<Failure, List<TripDataWithRequests>>> getRequestPickMeTrips();
}

class GetRequestsPickMeRemoteDataSourceImp
    implements GetRequestsPickMeRemoteDataSource {
  final ApiConsumer apiConsumer;

  GetRequestsPickMeRemoteDataSourceImp({required this.apiConsumer});

  @override
  Future<Either<Failure, List<TripDataWithRequests>>>
      getRequestPickMeTrips() async {
    const t = 'getRequestPickMeTrips - getRequestPickMeTripsemoteDataSource';
    final response = await apiConsumer.get(
      EndPoints.getRequestPickMeTrips,
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        GetRequestsPickMeModel getRequestsPickMeModel =
            GetRequestsPickMeModel.fromJson(data);
        SubscriptionPremiumConstData.subscriptionPremium =
            getRequestsPickMeModel.subscriptionPremium ?? false;

        print(SubscriptionPremiumConstData.subscriptionPremium);
        print("getRequestsPickMeModel $getRequestsPickMeModel \n");
        return Right(getRequestsPickMeModel.requests!);
      },
    );
  }
}
