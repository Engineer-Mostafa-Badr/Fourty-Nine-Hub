import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/repositories/fourty_nine_repository.dart';

class GetBannerByIdUseCase {
  final FourtyNineRepository _fourtyNineRepository;

  GetBannerByIdUseCase(this._fourtyNineRepository);
  Future<Either<Failure, Banner>> call({required String id}) {
    return _fourtyNineRepository.getBannerById(id: id);
  }
}
