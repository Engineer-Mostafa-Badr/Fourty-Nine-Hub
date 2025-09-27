import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repository/chance_repository.dart';

class IncrementChanceAdViewUseCase {
  final ChanceRepository repository;

  IncrementChanceAdViewUseCase(this.repository);

  Future<Either<Failure, bool>> call(String adId) async {
    return await repository.incrementChanceAdView(adId);
  }
}