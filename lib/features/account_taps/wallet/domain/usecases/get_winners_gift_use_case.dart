import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/data_winners_gift_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

class GetWinnersGiftUseCase
    extends UseCase<DataWinnersGiftEntity, PaginationParams> {
  final GiftRepository _repo;
  GetWinnersGiftUseCase(this._repo);
  @override
  Future<Either<Failure, DataWinnersGiftEntity>> call(
      PaginationParams params) async {
    return await _repo.getWinnersGift(params);
  }
}
