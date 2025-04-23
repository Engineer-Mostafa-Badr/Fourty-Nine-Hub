import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/click_entity.dart';


class ClickUseCase extends UseCase<ClickEntity, ClickParams> {
  final RideRepository repository;

  ClickUseCase(this.repository);

  @override
  Future<Either<Failure, ClickEntity>> call(ClickParams params) async {
    return await repository.click(params);
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
