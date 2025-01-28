import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/authentication_ride_cubit.dart';

class CheckPartActiveCubit extends Cubit<AuthenticationRideState> {
  CheckPartActiveCubit() : super(AuthenticationRideInitial());
  check() async {
    PartsSocketModel? model = await CacheManager.getSocketPartModel();
    log(model?.toJson().toString()??"lksjdflskdjflsdkjf", name: "ldldldldldldldldldl");
    emit(
        SuccessGetPartRideSocketModelState(model: model ?? PartsSocketModel()));
  }
}
