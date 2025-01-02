import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/banner_talent_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/star_repository.dart';

class FetchBannerUseCase
    extends UseCase<BannerTalentEntity, NoParams> {
  final StarRepository _starRepository;

  FetchBannerUseCase(this._starRepository);
  @override
  Future<Either<Failure, BannerTalentEntity>> call(NoParams params) async {
    return await _starRepository.fetchBanner();
  }
}
