import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class FavoriteShippingCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  FavoriteShippingCubit({required this.repository}) : super(ShippingInitial());
  favorite(String id) async {
    var response = await repository.favorite(id: id);
    response.fold(
      (l) {
        log(l.toString(), name: "lkslksjdflksjdflskjdf");
      },
      (r) {
        emit(SuccessFavorite());
      },
    );
  }
}
