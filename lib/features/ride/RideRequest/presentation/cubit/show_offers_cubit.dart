import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class ShowOffersCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  OverlayEntry? overlayEntry;
  ShowOffersCubit({required this.repository}) : super(RiderInitial());
  showOffers() {
    repository.tripSoketOn(
      (data) {
        log('slkdjflskdfjlskdjflskdjf');
        emit(SuccessGetOfferDataState(data: data));
      },
    );
  }
}
