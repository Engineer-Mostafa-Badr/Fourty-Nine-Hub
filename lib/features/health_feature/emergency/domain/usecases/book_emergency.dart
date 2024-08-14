import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/repositories/emergency_repo.dart';

class BookHealthEmergencyUseCase
    extends UseCase<bool, BookHealthEmergencyParams> {
  final HealthEmergencyRepo _repo;
  BookHealthEmergencyUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(BookHealthEmergencyParams params) {
    return _repo.bookEmergency(params);
  }
}

class BookHealthEmergencyParams {
  String subCategoryId = '';
  String name = '';
  String address = '';
  String phone = '';
  BookHealthEmergencyParams();

  Map<String, dynamic> toJson() => {
        "subCategoryId": subCategoryId,
        "name": name,
        "address": address,
        "phone": phone,
      };
}
