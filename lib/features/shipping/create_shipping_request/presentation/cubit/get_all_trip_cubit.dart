import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class GetAllTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetAllTripCubit({required this.repository}) : super(ShippingState());
  getAllTrips() async {
    emit(LoadingShippingState());
    var response = await repository.getAllTripBySubCategory();
    response.fold(
      (l) {
        // log(l.toString(), name: "lskjdflsdkjflskdjflsdkjf")
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
