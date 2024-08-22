import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_brand_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/usecases/fetch_car_brand.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'fetch_car_brands_state.dart';

class FetchCarBrandsCubit extends Cubit<FetchCarBrandsState> {
  final FetchCarBrandUseCase fetchCarBrandUseCase;
  List<CarBrandEntity?> carBrandsList = [];
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
        carBrandsList = brands;
        emit(
          FetchCarBrandsSuccess(brands),
        );
      },
    );
  }
}
