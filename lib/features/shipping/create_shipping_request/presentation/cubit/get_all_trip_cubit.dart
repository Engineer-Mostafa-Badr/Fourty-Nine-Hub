import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/all_trip_model/all_trip_model.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetAllTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetAllTripCubit({required this.repository}) : super(ShippingState());
  getAllTrips() async {
    emit(LoadingShippingState());
    var response = await repository.getAllTripBySubCategory();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
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
