import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../repositories/cache_out/payment_cache_out_repository.dart';

class RequestYellowCardUseCase extends UseCase<bool, RequestYellowCardParams> {
  final PaymentCacheOutRepository _repo;

  RequestYellowCardUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(RequestYellowCardParams params) async {
    return await _repo.requestYellowCard(params);
  }
}

class RequestYellowCardParams {
  final String nationalIdBack;
  final String nationalIdFront;
  final String fullName;
  final String phoneNumber;
  final String nationalIdNumber;

  RequestYellowCardParams(
      {required this.nationalIdBack,
      required this.nationalIdFront,
      required this.fullName,
      required this.phoneNumber,
      required this.nationalIdNumber});

  Map<String, dynamic> toJson() => {
        "nationalIdBack": nationalIdBack,
        'nationalIdFront': nationalIdFront,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'nationalIdNumber': nationalIdNumber,
      };
}
