import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/car_brand_entity.dart';
import '../../../domain/usecases/fetch_car_brand_usecase.dart';
import '../../../../../../res/strings/labels.dart';

part 'fetch_car_brands_state.dart';

class FetchCarBrandsCubit extends Cubit<FetchCarBrandsState> {
  final FetchCarBrandUseCase fetchCarBrandUseCase;
  List<CarBrandEntity?> carBrandsList = [];
  String? brand;
  FetchCarBrandsCubit({
    required this.fetchCarBrandUseCase,
  }) : super(FetchCarBrandsInitial());
  Future<void> fetchCarBrand({required String search}) async {
    emit(FetchCarBrandsLoading());
    final response = await fetchCarBrandUseCase.call(search: search);
    response.fold(
      (Failure failure) => emit(
        FetchCarBrandsFailed(Labels.errorHappened),
      ),
      (List<CarBrandEntity> brands) {
        carBrandsList = [];
        carBrandsList = brands;
        emit(
          FetchCarBrandsSuccess(brands),
        );
      },
    );
  }
}
