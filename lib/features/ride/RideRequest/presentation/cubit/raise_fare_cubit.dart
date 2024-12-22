import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

import '../../domain/repositories/reider_request_repository.dart';

class RaiseFareCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  double? price;
  double? currentPrice;
  bool active = false;
  RaiseFareCubit({required this.repository}) : super(InitalRiderState());
  update({required String tripId}) {
    log(price.toString());
    if (price != null) {
      repository.riseFare(offer: price.toString(), tripId: tripId);
      active = false;
      currentPrice = price;
    }
  }

  increasePrice({required double tripPrice}) {
    currentPrice ??= tripPrice;
    price = (price ?? tripPrice) + 3;
    active = true;
    log(price.toString(), name: "Price");
  }

  decreasePrice() {
    if (active) {
      if (price == currentPrice) {
        active = false;
      } else {
        if (price != null) {
          price = price! - 3;
        }
        if (price == currentPrice) {
          active = false;
        }
      }
    }
  }
}
