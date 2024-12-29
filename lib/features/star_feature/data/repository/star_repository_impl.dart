import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/data/data_source/star_remote_data_source.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/banner_talent_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_winner_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/star_repository.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';

class StarRepositoryImpl extends StarRepository {
  final StarRemoteDataSource _remoteDataSource;

  StarRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<StarEntity>>> fetchAllStar(
      StarPaginationParams params) {
    return _remoteDataSource.fetchAllStar(params);
  }

  @override
  Future<Either<Failure, List<StarEntity>>> fetchMyStar() {
    return _remoteDataSource.fetchMyStar();
  }

  @override
  Future<Either<Failure, bool>> uploadMyStar(StarParams params) {
    return _remoteDataSource.uploadMyStar(params);
  }

  @override
  Future<Either<Failure, bool>> deleteMyStar({required String id}) {
    return _remoteDataSource.deleteMyStar(id: id);
  }

  @override
  Future<Either<Failure, List<StarWinnerEntity>>> fetchWinnerStar(
      StarPaginationParams params) {
    return _remoteDataSource.fetchWinnerStar(params);
  }

  @override
  Future<Either<Failure, BannerTalentEntity>> fetchBanner() {
    return _remoteDataSource.fetchBanner();
  }
}
