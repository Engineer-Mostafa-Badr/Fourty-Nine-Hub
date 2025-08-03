import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../RideFeature/domain/entities/ride_brand_entity.dart';
import '../../../../../RideFeature/domain/entities/ride_model_entity.dart';
import '../../../domain/entities/add_new_pick_me_param.dart';
import '../../../domain/use_cases/add_new_pick_me_usecase.dart';
import '../../../../view_all_trip_join/domain/entities/available_trip_join_entity.dart';
import '../../../../view_all_trip_join/domain/entities/delete_my_trip_join_entity.dart';
import '../../../../view_all_trip_join/domain/entities/expected_price_entity.dart';
import '../../../../view_all_trip_join/domain/entities/get_request_count_entity.dart';
import '../../../../view_all_trip_join/domain/entities/my_ads_trip_join_entity.dart';
import '../../../../view_all_trip_join/domain/entities/request_trip_join_entity.dart';
import '../../../../view_all_trip_join/domain/usecases/get_car_brand_use_case.dart';
import '../../../../view_all_trip_join/domain/usecases/get_car_model_use_case.dart';

part 'add_new_pick_me_trip_state.dart';

class AddNewPickMeTripCubit extends Cubit<AddNewPickMeTripState> {
  final AddNewPickMeUsecase addNewPickMeUsecase;
  final GetCarBrandUseCase getCarBrandUseCase;
  final GetCarModelUseCase getCarModelUseCase;

  AddNewPickMeTripCubit( this.addNewPickMeUsecase,
    this.getCarBrandUseCase,
    this.getCarModelUseCase,
  ) : super(AddNewPickMeTripState());

  Future<void> addNewPickMeTrip(
      {required AddNewPickMeParam addNewPickMeParam}) async {
    emit(state.copyWith(status: AddNewPickMeTripStateStatus.loading));
    final response = await addNewPickMeUsecase.call(
      addNewPickMeParam: addNewPickMeParam,
    );
    response.fold(
        (Failure failure) => emit(state.copyWith(status: AddNewPickMeTripStateStatus.failure)),
            (data) {
      print(data);
      emit(state.copyWith(status: AddNewPickMeTripStateStatus.success));
        });
  }



  List<RideBrandEntity> carBrandData = [];


  bool hasMoreCarBrandLoading = true;
  int currentPageCarBrandLoading = 1;
  bool isLoadingMoreCarBrandLoading = false;
  bool isLoadingCarBrandLoading = false;

  void loadInitialCarBrandLoading() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    isLoadingCarBrandLoading = true;
    carBrandData.clear();
    currentPageCarBrandLoading = 1;
    hasMoreCarBrandLoading = true;
    await getCarBrandLoading();
    isLoadingCarBrandLoading = false;
    emit(state.copyWith(status: AddNewPickMeTripStateStatus.success));
  }

  Future<void> getCarBrandLoading() async {
    if (!hasMoreCarBrandLoading || isLoadingMoreCarBrandLoading) {
      return;
    }
    isLoadingMoreCarBrandLoading = true;
    emit(state.copyWith(status: AddNewPickMeTripStateStatus.loading));
    final response = await getCarBrandUseCase(
        CarBrandParams(
            page: currentPageCarBrandLoading, limit: 15));
    response.fold(
          (failure) {
        isLoadingMoreCarBrandLoading = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: AddNewPickMeTripStateStatus.failure));
      },
          (data) {
        carBrandData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreCarBrandLoading = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: AddNewPickMeTripStateStatus.loading));
        } else {
          currentPageCarBrandLoading++;
        }

        isLoadingMoreCarBrandLoading = false;
        emit(state.copyWith(
          rideBrandEntity: data,
        ));
      },
    );
  }
}
