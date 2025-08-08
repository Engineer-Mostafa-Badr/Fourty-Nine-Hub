import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/banner.dart';
import '../repositories/fourty_nine_repository.dart';

class GetBannerByIdUseCase {
  final FourtyNineRepository _fourtyNineRepository;

  GetBannerByIdUseCase(this._fourtyNineRepository);
  Future<Either<Failure, Banner>> call({required String id}) {
    return _fourtyNineRepository.getBannerById(id: id);
  }
}
