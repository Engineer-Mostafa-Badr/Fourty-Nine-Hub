import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class FavoriteShippingCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  FavoriteShippingCubit({required this.repository}) : super(ShippingInitial());
  favorite(String id) async {
    var response = await repository.favorite(id: id);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        log(l.toString(), name: "lkslksjdflksjdflskjdf");
      },
      (r) {
        emit(SuccessFavorite());
      },
    );
  }
}
