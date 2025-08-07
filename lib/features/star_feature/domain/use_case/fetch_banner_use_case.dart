import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/banner_talent_entity.dart';
import '../repository/star_repository.dart';

class FetchBannerUseCase extends UseCase<BannerTalentEntity, NoParams> {
  final StarRepository _starRepository;

  FetchBannerUseCase(this._starRepository);
  @override
  Future<Either<Failure, BannerTalentEntity>> call(NoParams params) async {
    return await _starRepository.fetchBanner();
  }
}
