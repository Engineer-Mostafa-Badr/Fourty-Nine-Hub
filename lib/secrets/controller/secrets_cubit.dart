import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../domain/use_cases/get_all_secrets_use_case.dart';
import 'secrets_state.dart';

class SecretsCubit extends Cubit<SecretsState> {
  final GetAllSecretsUseCase _allSecretsUseCase;
  SecretsCubit(this._allSecretsUseCase) : super(const SecretsState());

  // getAllSecrets() async {
  //   // emit(state.copyWith(status: SecretsStateStatus.loading));
  //   // print('Loading');
  //   // final response = await _allSecretsUseCase(const NoParams());
  //   // response.fold((l) {
  //   //   print(l);
  //   //   emit(state.copyWith(status: SecretsStateStatus.failure, failure: l));
  //   // }, (r) {
  //   //   print('Success ${r.googleApiKey}');
  //   //   emit(state.copyWith(status: SecretsStateStatus.success, secrets: r));
  //   // });
  // }

  Future<void> getAllSecrets() async {
    emit(state.copyWith(status: SecretsStateStatus.loading));
    print('Loading secrets...');

    final response = await _allSecretsUseCase(const NoParams());

    response.fold((failure) {
      print('Error loading secrets: $failure');
      emit(
          state.copyWith(status: SecretsStateStatus.failure, failure: failure));
    }, (secrets) {
      print('Success loading secrets - Zego App ID: ${secrets.zegoAppId}');
      emit(
          state.copyWith(status: SecretsStateStatus.success, secrets: secrets));
    });
  }
}
