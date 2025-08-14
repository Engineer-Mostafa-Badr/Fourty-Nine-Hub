import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_details_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_details_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/search_azkar_usecase.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_state.dart';
import 'package:fourtyninehub/routes/pages.dart';

class AzkarCubit extends Cubit<AzkarState> {
  final FetchAzkarUseCase _azkarUseCase;
  final FetchDetailsAzkarUseCase _detailsAzkarUseCase;
  final SearchAzkarUseCase _searchAzkarUseCase;

  List<AzkarEntity> azkar = [];

  List<AzkarDetailsEntity> azkarDetails = [];
  List<AzkarEntity> azkarSearch = [];
  TextEditingController searchController = TextEditingController();
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 100;
  AzkarCubit(
    this._azkarUseCase,
    this._detailsAzkarUseCase,
    this._searchAzkarUseCase,
  ) : super(const AzkarState());

  Future<void> cleanSearchAzkar() async {
    emit(state.copyWith(azkarSearch: [], status: AzkarStates.success));
  }

  Future<void> fetchAzkar() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _azkarUseCase(
      AzkarParams(page: currentPage, limit: pageSize),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: AzkarStates.error));
      },
      (data) {
        azkar.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(akar: azkar, status: AzkarStates.success));
      },
    );
  }

  Future<void> fetchDetailsAzkar(String category) async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _detailsAzkarUseCase(
      AzkarDetailsParams(
          category: category, page: currentPage, limit: pageSize),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: AzkarStates.error));
      },
      (data) {
        azkarDetails.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            azkarDetail: azkarDetails, status: AzkarStates.success));
      },
    );
  }

  void loadAzkarData(String category) async {
    emit(state.copyWith(status: AzkarStates.loading));
    azkar.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchDetailsAzkar(category);
  }

  void loadInitialData() async {
    emit(state.copyWith(status: AzkarStates.loading));
    azkar.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchAzkar();
  }

  Future<void> searchAzkar({required String search}) async {
    azkarSearch.clear();

    azkarSearch.addAll(azkar);

    azkarSearch.retainWhere((element) => element.name.contains(search));
    emit(state.copyWith(azkarSearch: azkarSearch, status: AzkarStates.success));

    // final response = await _searchAzkarUseCase(
    //   SearchAzkarParams(page: 1, limit: 100, search: search),
    // );

    // response.fold(
    //   (failure) =>
    //       emit(state.copyWith(failure: failure, status: AzkarStates.error)),
    //   (data) {
    //     print("Test Azkar Search");
    //     azkarSearch.clear();
    //     azkarSearch.addAll(data);
    //     emit(state.copyWith(
    //         azkarSearch: azkarSearch, status: AzkarStates.success));
    //   },
    // );
  }

  Future<void> searchAzkar2({required String search}) async {
    if (state.akar == null) return;
    emit(state.copyWith(
      azkarSearch: state.akar!
          .where((element) =>
              element.name.toLowerCase().contains(search.toLowerCase()))
          .toList(),
    ));
  }
}
