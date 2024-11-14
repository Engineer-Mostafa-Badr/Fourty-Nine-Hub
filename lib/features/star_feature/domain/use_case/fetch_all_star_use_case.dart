import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/star_repository.dart';

class FetchAllStarUseCase extends UseCase<List<StarEntity>,StarPaginationParams>{
  final StarRepository _starRepository;

  FetchAllStarUseCase(this._starRepository);
  @override
  Future<Either<Failure, List<StarEntity>>> call(StarPaginationParams params)async {
    return await _starRepository.fetchAllStar(params);
  }
}

class StarPaginationParams {
  final int page;
  final int limit;

  StarPaginationParams({required this.page, required this.limit});


}