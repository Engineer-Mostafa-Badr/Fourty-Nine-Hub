import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';

import '../repositories/fourty_nine_repository.dart';

class GetSliderItemsUseCase extends UseCase<List<SliderItemEntity>, NoParams> {
  final FourtyNineRepository _fourtyNineRepository;

  GetSliderItemsUseCase(this._fourtyNineRepository);

  @override
  Future<Either<Failure, List<SliderItemEntity>>> call(
    NoParams params,
  ) {
    return _fourtyNineRepository.getSliderItems();
  }
}
