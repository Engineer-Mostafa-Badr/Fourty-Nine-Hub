import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entity/click_entity.dart';
import '../repositories/my_ads_repo.dart';

class ClickUseCase extends UseCase<ClickEntity, ClickParams> {
  final MyAdsRepo _adsRepo;

  ClickUseCase(this._adsRepo);

  @override
  Future<Either<Failure, ClickEntity>> call(ClickParams params) async {
    return await _adsRepo.click(params);
  }
}

class ClickParams {
  final String clientId;
  final String ownerId;
  final String subcategoryId;

  ClickParams(
      {required this.clientId,
      required this.ownerId,
      required this.subcategoryId});

  Map<String, dynamic> toJson() => {
        "clientId": clientId,
        "ownerId": ownerId,
        "subcategoryId": subcategoryId,
      };
}
