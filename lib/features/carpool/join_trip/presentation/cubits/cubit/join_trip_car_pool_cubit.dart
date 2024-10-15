import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/models/join_trip_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/entities/join_trip_entity.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/usecases/join_trip_carpool_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

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
    response.fold(
        (Failure failure) => emit(
              JoinTripCarPoolFailure(message: Labels.errorHappened),
            ), (data) {
      joinTripCarpoolModel = data;
      print(data);
      emit(JoinTripCarPoolSuccess(joinTripCarpoolModel: data));
    });
  }
}
