import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/city_model.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/doctor_list_repo.dart';

class GetFakeCitiesUseCase extends UseCase<List<CityModel>, int> {
  final DoctorListRepo _repo;
  GetFakeCitiesUseCase(this._repo);
  @override
  Future<Either<Failure, List<CityModel>>> call(int params) {
    return _repo.getCities(stateId: params);
  }
}