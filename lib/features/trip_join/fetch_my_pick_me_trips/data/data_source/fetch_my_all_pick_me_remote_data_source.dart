import 'package:dartz/dartz.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../models/fetch_my_pick_me_model.dart';
import '../../../helpers/print_helper.dart';

abstract class FetchMyAllPickMeRemoteDataSource {
  Future<Either<Failure, List<TripData>>> fetchMyPickMeTrips(
      {required int page});
}

class FetchMyAllPickMeRemoteDataSourceImp
    implements FetchMyAllPickMeRemoteDataSource {
  final ApiConsumer apiConsumer;

  FetchMyAllPickMeRemoteDataSourceImp({required this.apiConsumer});

  @override
  Future<Either<Failure, List<TripData>>> fetchMyPickMeTrips(
      {required int page}) async {
    const t = 'fetchMyPickMeTrips - fetchMyPickMeRemoteDataSource';
    final response = await apiConsumer.get(
      EndPoints.getAllMyPickMeTrips,
      queryParameters: {
        'subCategory': "62ea008d69ea29c91dfc3908",
        'limit': 10,
        'page': page,
      },
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        FetchMyPickMeModel fetchMyPickMeModel =
            FetchMyPickMeModel.fromJson(data);

        print("Status: ${fetchMyPickMeModel.status}");
        print("Message: ${fetchMyPickMeModel.message}");
        print(
            "Subscribed Premium: ${fetchMyPickMeModel.data.subscribedPremium}");
        print(
            "Subscription End Date: ${fetchMyPickMeModel.data.subscriptionEndDate}");
        print("Total Trips: ${fetchMyPickMeModel.data.trips.totalDocs}");

        for (var trip in fetchMyPickMeModel.data.trips.docs) {
          print("Trip ID: ${trip.id}");
          print("From: ${trip.fromEn} - To: ${trip.toEn}");
          print("Price: ${trip.price}, Distance: ${trip.distance}");
        }

        return Right(fetchMyPickMeModel
            .data.trips.docs); // Return only the list of trips
      },
    );
  }
}
