import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_state.dart';

import '../../domain/useCase/fetch_communication_privacy_use_case.dart';
import '../../domain/useCase/fetch_connection_privacy_use_case.dart';
import '../../domain/useCase/fetch_exclusion_privacy_use_case.dart';
import '../../domain/useCase/fetch_media_privacy_use_case.dart';
import '../../domain/useCase/fetch_personal_privacy_use_case.dart';
import '../../domain/useCase/remove_allowed_use_case.dart';
import '../../domain/useCase/remove_forbidden_use_case.dart';
import '../../domain/useCase/search_users_privacy_use_case.dart';
import '../../domain/useCase/update_communication_privacy_use_case.dart';
import '../../domain/useCase/update_connection_privacy_use_case.dart';
import '../../domain/useCase/update_except_from_privacy_use_case.dart';
import '../../domain/useCase/update_media_privacy_use_case.dart';
import '../../domain/useCase/update_only_with_privacy_use_case.dart';
import '../../domain/useCase/update_personal_privacy_use_case.dart';

class PrivacyCubit extends Cubit<PrivacyState> {
  final FetchPersonalPrivacyUseCase _privacyUseCase;
  final FetchConnectionPrivacyUseCase fetchConnectionPrivacyUseCase;
  final UpdatePersonalPrivacyUseCase updatePersonalPrivacyUseCase;
  final UpdateConnectionPrivacyUseCase updateConnectionPrivacyUseCase;
  final FetchCommunicationPrivacyUseCase fetchCommunicationPrivacyUseCase;
  final UpdateCommunicationPrivacyUseCase updateCommunicationPrivacyUseCase;
  final SearchUsersPrivacyUseCase searchUsersPrivacyUseCase;
  final UpdateOnlyWithPrivacyUseCase updateOnlyWithPrivacyUseCase;
  final UpdateExceptFromPrivacyUseCase updateExceptFromPrivacyUseCase;
  final FetchMediaPrivacyUseCase fetchMediaPrivacyUseCase;
  final UpdateMediaPrivacyUseCase updateMediaPrivacyUseCase;
  final FetchExclusionPrivacyUseCase fetchExclusionPrivacyUseCase;
  final RemoveAllowedUseCase removeAllowedUseCase;
  final RemoveForbiddenUseCase removeForbiddenUseCase;

  PrivacyCubit(this._privacyUseCase, this.fetchConnectionPrivacyUseCase, this.updatePersonalPrivacyUseCase, this.updateConnectionPrivacyUseCase, this.fetchCommunicationPrivacyUseCase, this.updateCommunicationPrivacyUseCase, this.searchUsersPrivacyUseCase, this.updateOnlyWithPrivacyUseCase, this.updateExceptFromPrivacyUseCase, this.fetchMediaPrivacyUseCase, this.updateMediaPrivacyUseCase, this.fetchExclusionPrivacyUseCase, this.removeAllowedUseCase, this.removeForbiddenUseCase)
      : super(const PrivacyState());

  void loadData() async {
    await fetchDataPrivacy();
    await fetchDataConnectionPrivacy();
    await fetchDataCommunicationPrivacy();
    await fetchDataCommunicationPrivacy();
    await fetchDataMediaPrivacy();
  }
  Future<void> fetchExclusionData({required String feature}) async {
    emit(state.copyWith(status: PrivacyStates.loading));

    final response = await fetchExclusionPrivacyUseCase.call(ExclusionParams(feature: feature));

    response.fold(
          (failure) {
        print("ExclusionEntity: error");
        emit(state.copyWith(failure: failure, status: PrivacyStates.error));
      },
          (exclusionEntity) {
        print("ExclusionEntity: ${exclusionEntity.data}");  // Check data before emission
        emit(state.copyWith(exclusionEntity: exclusionEntity, status: PrivacyStates.success));
      },
    );
  }


  // Future<void> fetchDataExclusionPrivacy({required ExclusionParams params}) async {
  //   emit(state.copyWith(status: PrivacyStates.loading));
  //   final response = await fetchExclusionPrivacyUseCase.call(params);
  //   response.fold((l) {
  //     emit(state.copyWith(failure: l, status: PrivacyStates.error));
  //   }, (data) {
  //     emit(state.copyWith(exclusionEntity: data, status: PrivacyStates.success));
  //   });
  // }
  Future<void> removeForbiddenData({required RemoveAllowedParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await removeForbiddenUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(removeForbiddenDataEntity: data));
    });
  }

  Future<void> removeAllowedData({required RemoveAllowedParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await removeAllowedUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(removeDataEntity: data));
    });
  }

  Future<void> updateDataMediaPrivacy({required UpdateMediaPrivacyParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await updateMediaPrivacyUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(updatePersonalPrivacyDataEntity: data));
      loadData();
    });
  }


  Future<void> updateOnlyWithPrivacy({required UpdateOnlyWithPrivacyParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await updateOnlyWithPrivacyUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(onlyWithEntity: data));
      // loadData();
    });
  }

  Future<void> updateExceptFromPrivacy({required UpdateExceptFromPrivacyParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await updateExceptFromPrivacyUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(exceptFromEntity: data));
      // loadData();
    });
  }


  Future<void> searchRestaurant(String searchKeyword) async {
    emit(state.copyWith(status: PrivacyStates.loading, isSearching: true));

    final response = await searchUsersPrivacyUseCase(
      SearchUserPrivacyParams(searchKeyWord: searchKeyword),
    );

    response.fold(
          (failure) {
        emit(state.copyWith(
            failure: failure, status: PrivacyStates.error, isSearching: false));
      },
          (data) {
        emit(state.copyWith(
          searchUsers: data,
          status: PrivacyStates.success,
          isSearching: true,
        ));
      },
    );
  }
  Future<void> fetchDataMediaPrivacy() async {
    emit(state.copyWith(status: PrivacyStates.loading));
    final response = await fetchMediaPrivacyUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(mediaPrivacyEntity: data, status: PrivacyStates.success));
    });
  }
  Future<void> fetchDataCommunicationPrivacy() async {
    emit(state.copyWith(status: PrivacyStates.loading));
    final response = await fetchCommunicationPrivacyUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(communicationPrivacyEntity: data, status: PrivacyStates.success));
    });
  }
  Future<void> updateDataCommunicationPrivacy({required UpdateCommunicationPrivacyParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await updateCommunicationPrivacyUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(updatePersonalPrivacyDataEntity: data));
      loadData();
    });
  }



  Future<void> fetchDataConnectionPrivacy() async {
    emit(state.copyWith(status: PrivacyStates.loading));
    final response = await fetchConnectionPrivacyUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(connectionPrivacyEntity: data, status: PrivacyStates.success));
    });
  }
  Future<void> updateDataConnectionPrivacy({required UpdateConnectionPrivacyParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await updateConnectionPrivacyUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(updatePersonalPrivacyDataEntity: data));
      loadData();
    });
  }






  Future<void> fetchDataPrivacy() async {
    emit(state.copyWith(status: PrivacyStates.loading));
    final response = await _privacyUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(personalPrivacyEntity: data, status: PrivacyStates.success));
    });
  }
  Future<void> updateDataPersonalPrivacy({required UpdatePersonalPrivacyParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await updatePersonalPrivacyUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(updatePersonalPrivacyDataEntity: data));
      loadData();
    });
  }

}
