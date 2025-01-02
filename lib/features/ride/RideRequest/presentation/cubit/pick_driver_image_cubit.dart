import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class PickDriverImageCubit extends Cubit<RiderState> {
  PickDriverImageCubit() : super(RiderInitial());

  pick({required File image}) {
    emit(SuccessPickDriverImageState(image: image));
  }
}
