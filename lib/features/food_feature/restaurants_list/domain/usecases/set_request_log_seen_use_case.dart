import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/set_request_seen_entity.dart';
import '../repositories/restaurant_list_repo.dart';


class SetRequestLogSeenUseCase extends UseCase<SetRequestSeenEntity , SetRequestLogSeenParams> {
  final RestaurantListRepo _repo;


  SetRequestLogSeenUseCase(this._repo);
  @override
  Future<Either<Failure, SetRequestSeenEntity >> call(SetRequestLogSeenParams params) async {
    return await _repo.setLogSeen(params: params);
  }

}
class SetRequestLogSeenParams {
  final String requestId;

  SetRequestLogSeenParams({
    required this.requestId,

  });


}


