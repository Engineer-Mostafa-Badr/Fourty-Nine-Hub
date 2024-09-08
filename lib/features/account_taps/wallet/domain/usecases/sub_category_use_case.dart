import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import '../repositories/wallet_repo.dart';
import 'main_category_use_case.dart';

class SubCategoryUseCase extends UseCase<List<MainCategoryWalletEntity>,MainCategoryParams>{
  final WalletRepo _walletRepo;

  SubCategoryUseCase(this._walletRepo);

  @override
  Future<Either<Failure, List<MainCategoryWalletEntity>>> call(MainCategoryParams params)async {
    return await _walletRepo.fetchSubCategory(params);
  }

}
