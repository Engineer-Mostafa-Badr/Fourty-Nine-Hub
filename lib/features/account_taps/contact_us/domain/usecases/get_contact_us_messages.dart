import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/contact_us_entity.dart';
import '../repositories/contact_us_repo.dart';

class GetContactUsMessages extends UseCase<List<ContactUsEntity>, NoParams> {
  final ContactUsRepo _repo;
  GetContactUsMessages(this._repo);
  @override
  Future<Either<Failure, List<ContactUsEntity>>> call(NoParams params) async {
    return await _repo.getContactUsMessages();
  }
}
