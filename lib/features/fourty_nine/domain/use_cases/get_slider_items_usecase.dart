import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/slider_item_entity.dart';

import '../repositories/fourty_nine_repository.dart';

class GetSliderItemsUseCase extends UseCase<List<SliderItemEntity>, NoParams> {
  final FourtyNineRepository _fourtyNineRepository;

  GetSliderItemsUseCase(this._fourtyNineRepository);

  @override
  Future<Either<Failure, List<SliderItemEntity>>> call(
    NoParams params,
  ) {
    print("Slider UseCase");
    return _fourtyNineRepository.getSliderItems();
  }
}
