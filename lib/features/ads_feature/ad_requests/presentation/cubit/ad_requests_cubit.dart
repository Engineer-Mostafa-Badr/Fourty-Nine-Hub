import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/usecases/get_ad_requests_usecase.dart';

part 'ad_requests_state.dart';

class AdRequestsCubit extends Cubit<AdRequestsState> {
  final GetAdRequestsUseCase _getAdRequestsUseCase;

  TextEditingController searchController = TextEditingController();
  List<AdRequestEntity> adRequests = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  AdRequestsCubit(this._getAdRequestsUseCase) : super(const AdRequestsState());

  void loadInitialData(String id, String search) async {
    adRequests.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchAdRequests(id, search);
  }

  Future<void> fetchAdRequests(String id, String search) async {
    if (!hasMoreData || isLoadingMore) return;

    emit(state.copyWith(status: AdRequestsStates.loading));
    isLoadingMore = true;

    final response = await _getAdRequestsUseCase(
      GetAdRequestsParams(
          id: id, page: currentPage, limit: pageSize, username: search),
    );

    response.fold(
      (failure) => emit(
          state.copyWith(failure: failure, status: AdRequestsStates.error)),
      (data) {
        adRequests.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: AdRequestsStates.success));
      },
    );
  }
}
