import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/entities/all_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/repositories/book_doctor_appointment_repo.dart';

class AllAppointmentUseCase
    extends UseCase<List<AllAppointmentEntity>, PaginationParams> {
  final BookAppointmentRepo repo;

  AllAppointmentUseCase(this.repo);
  @override
  Future<Either<Failure, List<AllAppointmentEntity>>> call(params) {
    return repo.allAppointment(params);
  }
}