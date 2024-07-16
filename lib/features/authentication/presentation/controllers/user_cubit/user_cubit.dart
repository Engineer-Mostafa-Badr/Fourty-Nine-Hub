import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/attach_token_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/save_tokens_use_case.dart';

import '../../../domain/use_cases/get_user_use_case.dart';

class UserCubit extends Cubit<BasicState<UserEntity>> {
  final GetUserUseCase _getUserUseCase;
  final GetTokensUseCase _getTokensUseCase;
  final SaveTokensUseCase _saveTokensUseCase;
  final AttachTokenUseCase _attachTokenUseCase;

  bool _isTokenAttached = false;

  UserCubit(
    this._getUserUseCase,
    this._getTokensUseCase,
    this._attachTokenUseCase,
    this._saveTokensUseCase,
  ) : super(const BasicState());

  bool get isLoggedIn => state.data != null;

  Future<void> getUser() async {
    if (!_isTokenAttached) return;
    final result = await _getUserUseCase(const NoParams());
    emit(
      result.fold(
        (failure) {
          return state.copyWith(
            status: StateStatus.error,
            failure: failure,
          );
        },
        (user) {
          return state.copyWith(status: StateStatus.success, data: user);
        },
      ),
    );
  }

  void attachToken() async {
    final result = await _getTokensUseCase(const NoParams());
    result.fold(
      (_) {},
      (tokens) {
        _attachTokenUseCase(tokens);
        _isTokenAttached = true;
        getUser();
      },
    );
  }

  void logout() {
    _attachTokenUseCase(null);
    _saveTokensUseCase(null);
    _isTokenAttached = false;
    emit(const BasicState());
  }
}
