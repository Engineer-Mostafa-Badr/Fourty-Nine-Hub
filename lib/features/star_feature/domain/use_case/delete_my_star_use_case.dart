import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/star_repository.dart';

class DeleteMyStarUseCase extends UseCase<bool, String> {
  final StarRepository _starRepository;

  DeleteMyStarUseCase(this._starRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _starRepository.deleteMyStar(id: params);
  }
}
