import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/star_repository.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';

class StarRepositoryImpl extends StarRepository{
  @override
  Future<Either<Failure, StarEntity>> fetchAllStar() {
    // TODO: implement fetchAllStar
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, StarEntity>> fetchMyStar() {
    // TODO: implement fetchMyStar
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> uploadMyStar(StarParams params) {
    // TODO: implement uploadMyStar
    throw UnimplementedError();
  }

}