import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/secrets/controller/secrets_state.dart';
import 'package:fourtyninehub/secrets/domain/use_cases/get_all_secrets_use_case.dart';

class SecretsCubit extends Cubit<SecretsState> {
  SecretsCubit(this._allSecretsUseCase) : super(const SecretsState());
  final GetAllSecretsUseCase _allSecretsUseCase;

  getAllSecrets() async {
    // emit(state.copyWith(status: SecretsStateStatus.loading));
    // print('Loading');
    // final response = await _allSecretsUseCase(const NoParams());
    // response.fold((l) {
    //   print(l);
    //   emit(state.copyWith(status: SecretsStateStatus.failure, failure: l));
    // }, (r) {
    //   print('Success ${r.googleApiKey}');
    //   emit(state.copyWith(status: SecretsStateStatus.success, secrets: r));
    // });
  }
}
