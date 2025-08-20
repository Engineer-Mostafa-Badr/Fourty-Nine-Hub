import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/models/join_trip_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/entities/join_trip_entity.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/usecases/join_trip_carpool_usecase.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'join_trip_car_pool_state.dart';

class JoinTripCarPoolCubit extends Cubit<JoinTripCarPoolState> {
  final JoinTripCarpoolUsecase joinTripCarpoolUsecase;
  JoinTripCarpoolModel? joinTripCarpoolModel;

  JoinTripCarPoolCubit({
    required this.joinTripCarpoolUsecase,
  }) : super(JoinTripCarPoolInitial());

  Future<void> joinTripCarPool(
      {required JoinTripCarPoolParam joinTripCarPoolParam}) async {
    emit(JoinTripCarPoolLoading());
    final response = await joinTripCarpoolUsecase.call(
        joinTripCarPoolParam: joinTripCarPoolParam);

    response.fold((Failure failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(JoinTripCarPoolFailure(message: "you cant join this trip"));
    }, (data) {
      joinTripCarpoolModel = data;
      print("Success");
      emit(JoinTripCarPoolSuccess(joinTripCarpoolModel: data));
    });
  }
}
