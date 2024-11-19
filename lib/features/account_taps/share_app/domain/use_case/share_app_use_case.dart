import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/entity/share_app_entity.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/repository/share_app_repository.dart';

class ShareAppUseCase extends UseCase<ShareAppEntity,NoParams>{
  final ShareAppRepository _repository;

  ShareAppUseCase(this._repository);

  @override
  Future<Either<Failure, ShareAppEntity>> call(NoParams params)async {
    return await _repository.shareApp();
  }
}