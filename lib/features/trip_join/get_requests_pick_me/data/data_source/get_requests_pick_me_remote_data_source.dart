import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/data_source/subscription_premium_const_data.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/models/get_requests_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/presentation/cubits/cubit/get_requests_pick_me_cubit.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:path/path.dart';

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
