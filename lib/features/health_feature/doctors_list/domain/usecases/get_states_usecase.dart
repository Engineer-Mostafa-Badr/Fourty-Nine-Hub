import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/state_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/doctor_list_repo.dart';

class GetStatesUseCase extends UseCase<List<StateModel>, NoParams> {
  final DoctorListRepo _repo;
  GetStatesUseCase(this._repo);
  @override
  Future<Either<Failure, List<StateModel>>> call(NoParams params) {
    return _repo.getStates();
  }
}