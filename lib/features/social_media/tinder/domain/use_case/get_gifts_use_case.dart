import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';


class GetGiftsUseCase extends UseCase<GiftApi, PaginationParams> {
  final TinderRepository _repository;

  GetGiftsUseCase(this._repository);

  @override
  Future<Either<Failure, GiftApi>> call(PaginationParams params) {
    return _repository.getGifts(params);
  }
}
