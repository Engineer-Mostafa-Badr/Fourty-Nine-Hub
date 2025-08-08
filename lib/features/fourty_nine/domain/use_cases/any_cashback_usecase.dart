import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repositories/fourty_nine_repository.dart';

class AnyCashBackUseCase extends UseCase<bool, NoParams> {
  final FourtyNineRepository _repo;

  AnyCashBackUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repo.anyCashBack();
  }
}
