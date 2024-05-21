import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';

import '../../../domain/use_cases/get_user_use_case.dart';

class UserCubit extends Cubit<BasicState<UserEntity>> {
  final GetUserUseCase _getUserUseCase;

  UserCubit(this._getUserUseCase) : super(const BasicState());

  bool get isLoggedIn => state.data != null;

  Future<void> getUser() async {
    final result = await _getUserUseCase(const NoParams());
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: StateStatus.error,
          failure: failure,
        ),
        (user) => state.copyWith(status: StateStatus.success, data: user),
      ),
    );
  }
}
