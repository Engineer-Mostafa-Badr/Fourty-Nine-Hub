import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/custom_page/data/model/social_page_model.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/social_page_entity.dart';
import '../../domain/use_case/update_social_page_use_case.dart';

abstract class CustomPageRemoteDataSource {
  Future<Either<Failure, SocialPageEntity>> fetchSocialPage();
  Future<Either<Failure,bool>>updateSocialPage(SocialPageParams params);
}

class CustomPageRemoteDataSourceImpl extends CustomPageRemoteDataSource {
  final ApiConsumer _apiConsumer;

  CustomPageRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, SocialPageEntity>> fetchSocialPage() async {
    var response = await _apiConsumer.get(EndPoints.SocialPage);

    return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(SocialPageModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> updateSocialPage(SocialPageParams params)async {
    var response = await _apiConsumer.put(EndPoints.SocialPage,
    data: params.toJson()
    );

    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right(response['status']),
    );
  }
}
