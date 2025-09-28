import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repository/chance_repository.dart';

class ToggleChanceAdFavoriteUseCase {
  final ChanceRepository repository;

  ToggleChanceAdFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(ToggleChanceAdFavoriteParams params) async {
    return await repository.toggleChanceAdFavorite(params);
  }
}

class ToggleChanceAdFavoriteParams {
  final String adId;

  ToggleChanceAdFavoriteParams({required this.adId});
}