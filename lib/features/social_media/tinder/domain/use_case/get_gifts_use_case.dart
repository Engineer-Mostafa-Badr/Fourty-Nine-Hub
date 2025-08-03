import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/gift_model.dart';
import '../repositories/tinder_repository.dart';

class GetGiftsUseCase extends UseCase<GiftApi, PaginationParams> {
  final TinderRepository _repository;

  GetGiftsUseCase(this._repository);

  @override
  Future<Either<Failure, GiftApi>> call(PaginationParams params) {
    return _repository.getGifts(params);
  }
}
