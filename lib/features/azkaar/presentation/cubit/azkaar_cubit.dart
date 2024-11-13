import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_details_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_details_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  final FetchAzkarUseCase _azkarUseCase;
  final FetchDetailsAzkarUseCase _detailsAzkarUseCase;

  AzkarCubit(
      this._azkarUseCase, this._detailsAzkarUseCase,
      ) : super(const AzkarState());


  List<AzkarEntity> azkar = [];
  List<AzkarDetailsEntity> azkarDetails = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;


  void loadInitialData() async {
    emit(state.copyWith(status: AzkarStates.loading));
    azkar.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchAzkar();
  }
  void loadAzkarData(String category) async {
    emit(state.copyWith(status: AzkarStates.loading));
    azkar.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchDetailsAzkar(category);
  }

  Future<void> fetchAzkar() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _azkarUseCase(
      AzkarParams(page: currentPage, limit: pageSize),
    );

    response.fold(
          (failure) => emit(state.copyWith(failure: failure, status: AzkarStates.error)),
          (data) {
        azkar.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(akar: azkar,status: AzkarStates.success));
      },
    );
  }


  Future<void> fetchDetailsAzkar(String category) async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _detailsAzkarUseCase(
      AzkarDetailsParams(category: category, page: currentPage, limit: pageSize),
    );

    response.fold(
          (failure) => emit(state.copyWith(failure: failure, status: AzkarStates.error)),
          (data) {
        azkarDetails.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(azkarDetail: azkarDetails,status: AzkarStates.success));
      },
    );
  }

}
