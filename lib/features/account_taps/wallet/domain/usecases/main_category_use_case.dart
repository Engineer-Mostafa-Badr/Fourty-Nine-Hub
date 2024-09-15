import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../repositories/wallet_repo.dart';

class MainCategoryUseCase
    extends UseCase<List<MainCategoryWalletEntity>, MainCategoryParams> {
  final WalletRepo _walletRepo;

  MainCategoryUseCase(this._walletRepo);

  @override
  Future<Either<Failure, List<MainCategoryWalletEntity>>> call(
      MainCategoryParams params) async {
    return await _walletRepo.fetchMainCategory(params);
  }
}

class MainCategoryParams {
  String? id;
  PaginationParams paginationParams;

  MainCategoryParams({required this.paginationParams, this.id});
}
