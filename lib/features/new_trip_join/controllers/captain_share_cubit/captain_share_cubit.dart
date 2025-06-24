import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_route_use_case.dart';
import 'package:go_router/go_router.dart';

part 'captain_share_state.dart';

class CaptainShareCubit extends Cubit<CaptainShareState> {
  final CreatePricePerSeatUseCase createPricePerSeatUseCase;
  final CreateRouteUseCase createRouteUseCase;
  CaptainShareCubit(this.createPricePerSeatUseCase,this.createRouteUseCase)
      : super(const CaptainShareState());

  Future<void> createOffer(
      {required CreatePricePerSeatParams params, required BuildContext context}) async {
    showLoadingDialog(context);
    final response = await createPricePerSeatUseCase(params);
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      // errorName == 'DebtError'
      //     ? showDebtDialog(context, subCategoryId)
      //     : errorName == 'SubscribeError'
      //     ? showSubscribeDialog(context, subCategoryId)
      //     : showErrorMessage(context, getFailureMessage(l, context));
      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      context.pop();
      emit(state.copyWith(status: CaptainShareStates.success,pricePerSeat:data));
    });
  }

  Future<void> createRoute(
      {required CreatePricePerSeatParams params, required BuildContext context}) async {
    showLoadingDialog(context);
    final response = await createRouteUseCase(params);
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      errorName == 'DebtError'
          ? showDebtDialog(context, 'subCategoryId')
          : errorName == 'SubscribeError'
          ? showSubscribeDialog(context, 'subCategoryId')
          : showErrorMessage(context, getFailureMessage(l, context));
      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      context.pop();
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }
}
