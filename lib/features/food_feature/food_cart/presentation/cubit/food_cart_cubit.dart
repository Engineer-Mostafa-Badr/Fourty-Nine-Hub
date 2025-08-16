import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/states/basic_state.dart';
import '../../../../../routes/routes.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';

class FoodCartCubit extends Cubit<BasicState<CartEntity>> {
  final GetCartUseCase _getCartUseCase;
  final PlaceOrderUseCase _placeOrderUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  FoodCartCubit(this._getCartUseCase, this._placeOrderUseCase,
      this._removeFromCartUseCase)
      : super(const BasicState());

  void loadData() async {
    final response = await _getCartUseCase(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      return state.copyWith(failure: l);
    }, (data) => emit(state.copyWith(data: data)));
  }

  void placeOrder(BuildContext context) async {
    if (state.data != null) {
      final response = await _placeOrderUseCase(state.data!.id);
      response.fold((l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(currentContext, getFailureMessage(l, currentContext));
        return Left(l);
      }, (data) {
        context.pushNamed(Routes.REQUESTSHISTORY);
      });
    }
  }
}
