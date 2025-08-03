import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/gift_model.dart';
import '../repositories/tinder_repository.dart';

class FetchGiftsUseCase extends UseCase<GiftApi, NoParams> {
  final TinderRepository _repository;

  FetchGiftsUseCase(this._repository);

  @override
  Future<Either<Failure, GiftApi>> call(NoParams params) {
    return _repository.fetchGifts();
  }
}
