import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

import '../../domain/repositories/reider_request_repository.dart';

class RaiseFareCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  int? price;
  RaiseFareCubit({required this.repository}) : super(InitalRiderState());
  update({required String tripId}) {
    if (price != null) {
      repository.riseFare(offer: price.toString(), tripId: tripId);
    }
  }

  increasePrice({required int newPrice}) {
    price = (price ?? 0) + newPrice;
  }

  decreasePrice({required int newPrice}) {
    if ((price ?? 0) > 0) {
      price = (price ?? 0) - newPrice;
    }
  }
}
