import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_winner_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/star_repository.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_all_star_use_case.dart';

class FetchWinnerStarUseCase
    extends UseCase<List<StarWinnerEntity>, StarPaginationParams> {
  final StarRepository _starRepository;

  FetchWinnerStarUseCase(this._starRepository);
  @override
  Future<Either<Failure, List<StarWinnerEntity>>> call(
      StarPaginationParams params) async {
    return await _starRepository.fetchWinnerStar(params);
  }
}
