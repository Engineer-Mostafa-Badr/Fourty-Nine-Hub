import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/authentication_ride_cubit.dart';

class CheckPartActiveCubit extends Cubit<AuthenticationRideState> {
  CheckPartActiveCubit() : super(AuthenticationRideInitial());
  check({required PartsSocketModel model}) {
    emit(SuccessGetPartRideSocketModelState(model: model));
  }
}
