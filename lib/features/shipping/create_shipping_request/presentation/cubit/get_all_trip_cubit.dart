import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/all_trip_model/all_trip_model.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';

class GetAllTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetAllTripCubit({required this.repository}) : super(ShippingState());
  getAllTrips() async {
    emit(LoadingShippingState());
    var response = await repository.getAllTripBySubCategory();
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        List<AllTripModel> allTripList = (r['data'] as List)
            .map(
              (e) => AllTripModel.fromJson(e),
            )
            .toList();
        emit(SuccessGetAllTripState(allTripList: allTripList));
      },
    );
  }
}
