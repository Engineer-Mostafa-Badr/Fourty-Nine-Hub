import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/gender_type.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/repositories/book_doctor_appointment_repo.dart';

class BookRegularAppointmentUseCase
    extends UseCase<bool, BookAppointmentParams> {
  final BookAppointmentRepo repo;

  BookRegularAppointmentUseCase(this.repo);
  @override
  Future<Either<Failure, bool>> call(params) {
    return repo.bookRegularAppointment(params);
  }
}

class BookAppointmentParams {
  String phone = '';
  String notes = '';
  String address = '';
  String appointmentId = '';
  String subCategoryId = '';
  GenderType gender = GenderType.Male;

  set age(String age) {}

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      if (address.isNotEmpty) 'address': address,
      'additionalNotes': notes,
      'gender': gender.name.toLowerCase(),
    };
  }
}
