
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/data/models/contact_us_model.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/contact_us_repo.dart';


class CreateContactUsUseCase extends UseCase<bool, ContactUsModel> {
  final ContactUsRepo _repo;
  CreateContactUsUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(ContactUsModel params) async {
    return await _repo.createContactUs(item: params);
  }
}
