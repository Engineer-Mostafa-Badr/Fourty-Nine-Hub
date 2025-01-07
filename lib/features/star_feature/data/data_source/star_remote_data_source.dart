import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/data/model/banner_talent_model.dart';
import 'package:fourtyninehub/features/star_feature/data/model/star_model.dart';
import 'package:fourtyninehub/features/star_feature/data/model/star_winner_model.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/banner_talent_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_winner_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';

abstract class StarRemoteDataSource {
  Future<Either<Failure, List<StarEntity>>> fetchAllStar(
      StarPaginationParams params);
  Future<Either<Failure, List<StarWinnerEntity>>> fetchWinnerStar(
      StarPaginationParams params);

  Future<Either<Failure, List<StarEntity>>> fetchMyStar();

  Future<Either<Failure, bool>> uploadMyStar(StarParams params);
  Future<Either<Failure, bool>> deleteMyStar({required String id});
  Future<Either<Failure, BannerTalentEntity>> fetchBanner();
}

class StarRemoteDataSourceImpl extends StarRemoteDataSource {
  final ApiConsumer _apiConsumer;

  StarRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<StarEntity>>> fetchAllStar(
      StarPaginationParams params) async {
    final response = await _apiConsumer.get(EndPoints.allStar(params),
        queryParameters: {"subCategory": "6723913b74f292b91ad2de54"});

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['data']['talents'] as List)
            .map((e) => StarModel.fromJson(e))
            .toList());
      },
    );
  }

  @override
  Future<Either<Failure, List<StarEntity>>> fetchMyStar() async {
    final response = await _apiConsumer.get(EndPoints.myStar);

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['data']['talents'] as List)
            .map((e) => StarModel.fromJson(e))
            .toList());
      },
    );
  }

  @override
  Future<Either<Failure, bool>> uploadMyStar(StarParams params) async {
    final response = await _apiConsumer.post(EndPoints.uploadStar,
        data: params.toJson(),
        queryParameters: {"subCategory": "6723913b74f292b91ad2de54"});

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['status']));
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteMyStar({required String id}) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteMyStar(id: id),
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['status']));
      },
    );
  }

  @override
  Future<Either<Failure, List<StarWinnerEntity>>> fetchWinnerStar(
      StarPaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.winnerStar(params),
      queryParameters: {"subCategory": "6723913b74f292b91ad2de54"},
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((response['data'] as List)
            .map((e) => StarWinnerModel.fromJson(e))
            .toList());
      },
    );
  }

  @override
  Future<Either<Failure, BannerTalentEntity>> fetchBanner() async {
    final response = await _apiConsumer.get(
      EndPoints.bannerTalent,
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right((BannerTalentModel.fromJson(response['data'])));
      },
    );
  }
}
