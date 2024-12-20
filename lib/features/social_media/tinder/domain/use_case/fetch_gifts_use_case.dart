import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

class FetchGiftsUseCase extends UseCase<GiftApi, NoParams> {
  final TinderRepository _repository;

  FetchGiftsUseCase(this._repository);

  @override
  Future<Either<Failure, GiftApi>> call(NoParams params) {
    return _repository.fetchGifts();
  }
}
