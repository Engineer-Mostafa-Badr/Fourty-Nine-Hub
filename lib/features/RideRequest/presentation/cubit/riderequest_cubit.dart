import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/ride_request_model.dart';

import '../../domain/usecases/request/get_near_by_places_usecase.dart';

part 'riderequest_state.dart';

class RiderequestCubit extends Cubit<RiderequestState> {
  final fromAddressTextController = TextEditingController();
  final toAddressTextController = TextEditingController();
  final GetNearByPlacesUseCase _nearByPlacesUseCase;

  RiderequestCubit(this._nearByPlacesUseCase) : super(const RiderequestState());
}
