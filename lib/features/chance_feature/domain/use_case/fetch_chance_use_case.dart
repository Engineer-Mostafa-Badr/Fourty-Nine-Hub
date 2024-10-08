import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/repository/chance_repository.dart';

import '../../../../core/abstract/use_case.dart';

class FetchChanceUseCase
    extends NormalUseCase<Future<List<ChanceEntity>>, NoParams> {
  final ChanceRepository _chanceRepository;

  FetchChanceUseCase(this._chanceRepository);

  @override
  Future<List<ChanceEntity>> call(NoParams params) async {
    return _chanceRepository.fetchChance();
  }
}
