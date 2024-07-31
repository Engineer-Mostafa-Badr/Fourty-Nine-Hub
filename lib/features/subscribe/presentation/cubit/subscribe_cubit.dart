import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../domain/usecases/check_if_user_subscribed_usecase.dart';
import '../../domain/usecases/get_subscribtion_plans_usecase.dart';
import '../../domain/usecases/subscribe_usecase.dart';
import '../widgets/subscribtion_plans.dart';



class SubscribeCubit extends Cubit<BasicState<bool>> {
  final CheckIfUserSubscribedUseCase _checkIfUserSubscribedUseCase;
  final GetSubscribtionPlansUseCase _getSubscribtionPlansUseCase;
  final SubscribeUseCase _subscribeUseCase;
  SubscribeCubit(this._checkIfUserSubscribedUseCase,
      this._getSubscribtionPlansUseCase, this._subscribeUseCase)
      : super(const BasicState());

  void checkIfUserSubscribed(
      {required BuildContext context,
      required Function onSubscribed,
      required String subCategoryId}) async {
    final response = await _checkIfUserSubscribedUseCase(subCategoryId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      if (data) {
        onSubscribed();
      } else {
        final plansResponse = await _getSubscribtionPlansUseCase(subCategoryId);
        plansResponse.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (plans) {
          bottomSheet(
              context: context,
              widget: SubscribtionPlansWidget(
                subscribePlans: plans,
              ));
        });
      }
    });
  }
}
