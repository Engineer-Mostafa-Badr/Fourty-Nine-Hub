import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../repository/chance_repository.dart';

class GetChanceAdWinnersUseCase extends UseCase<List<dynamic>, String> {
  final ChanceRepository _chanceRepository;

  GetChanceAdWinnersUseCase(this._chanceRepository);

  @override
  Future<Either<Failure, List<dynamic>>> call(String adId) async {
    return await _chanceRepository.getChanceAdWinners(adId);
  }
}