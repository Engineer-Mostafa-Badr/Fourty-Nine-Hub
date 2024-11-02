import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_winner_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';

abstract class StarRepository{
  Future<Either<Failure,List<StarEntity>>> fetchAllStar(StarPaginationParams params);
  Future<Either<Failure,List<StarWinnerEntity>>> fetchWinnerStar(StarPaginationParams params);
  Future<Either<Failure,List<StarEntity>>> fetchMyStar();
  Future<Either<Failure,bool>> uploadMyStar(StarParams params);
  Future<Either<Failure,bool>> deleteMyStar({required String id});
}