import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/star_winner_entity.dart';
import '../repository/star_repository.dart';
import 'fetch_all_star_use_case.dart';

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
