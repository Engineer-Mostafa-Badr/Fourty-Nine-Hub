import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

import '../../domain/repositories/reider_request_repository.dart';

class RaiseFareCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  int? price;
  int? currentPrice;
  bool canChangePrice = false;
  RaiseFareCubit({required this.repository}) : super(InitalRiderState());
  update({required String tripId, required double tripPrice}) {
    if (price != null) {
      repository.riseFare(
          offer: (price! + tripPrice).toString(), tripId: tripId);
      canChangePrice = false;
      price = null;
    }
  }

  increasePrice({required int newPrice}) {
    currentPrice = (currentPrice ?? 0) + newPrice;
    price = (price ?? 0) + newPrice;
  }

  decreasePrice({required int newPrice}) {
    if (currentPrice != null) {
      if ((price ?? 0) > 0) {
        price = (price ?? 0) - newPrice;
        currentPrice = (currentPrice ?? 0) - newPrice;
      } else {
        log(price.toString(), name: "Price");
        price = null;
      }
    }
  }
}
