import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/use_cases/get_wheel_wallet_use_case.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../core/abstract/use_case.dart';

class WheelWalletCubit extends Cubit<BasicState<WheelWalletEntity>> {
  final GetWheelWalletUseCase _getWheelWalletUseCase;

  WheelWalletCubit(this._getWheelWalletUseCase) : super(const BasicState());

  void getWheelWallet() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getWheelWalletUseCase(const NoParams());
    emit(
      result.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          return state.copyWith(status: StateStatus.error, failure: failure);
        },
        (wheelWallet) =>
            state.copyWith(status: StateStatus.success, data: wheelWallet),
      ),
    );
  }
}
