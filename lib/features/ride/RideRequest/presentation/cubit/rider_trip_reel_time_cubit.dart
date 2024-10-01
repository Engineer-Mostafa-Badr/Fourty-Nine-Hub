import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class RiderTripReelTimeCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  SubCategoryEntity? subCategory;
  RiderTripReelTimeCubit({required this.repository}) : super(RiderInitial());
  selectCateogry(SubCategoryEntity value) {
    if (value.id == "62c8ba9f8e28a58a3edf57eb" ||
        value.id == "62ea012a69ea29c91dfc3917" ||
        value.id == "6698736fdaa111da2d775627" ||
        value.id == "62c8baa28e28a58a3edf57f1" ||
        value.id == "62c8baa38e28a58a3edf57f3" ||
        value.id == "62c8ba9e8e28a58a3edf57e9") {
      emit(ViewPickTripDataState());
      subCategory = value;
    } else {
      emit(NotViewPickTripDataState());
      subCategory = value;
    }
  }

  getTripInformation() {}
}
