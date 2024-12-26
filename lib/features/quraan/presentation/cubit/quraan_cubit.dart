import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_surah_use_case.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final FetchQuranSurahUseCase _quranSurahUseCase;
  final FetchSurahUseCase _surahUseCase;

  QuranCubit(
    this._quranSurahUseCase,
    this._surahUseCase,
  ) : super(const QuranState());

  List<QuranSurahEntity> quran = [];
  // List<AzkarDetailsEntity> azkarDetails = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadInitialData() async {
    emit(state.copyWith(status: QuranStates.loading));
    quran.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchQuranSurah();
  }
  // void loadAzkarData(String category) async {
  //   emit(state.copyWith(status: AzkarStates.loading));
  //   azkar.clear();
  //   currentPage = 1;
  //   hasMoreData = true;
  //   await fetchDetailsAzkar(category);
  // }

  Future<void> fetchQuranSurah() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _quranSurahUseCase(
      QuranParams(page: currentPage, limit: pageSize),
    );

    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: QuranStates.error)),
      (data) {
        quran.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(quranSurah: quran, status: QuranStates.success));
      },
    );
  }

  // Future<void> fetchQuranSurah() async {
  //   emit(state.copyWith( status: QuranStates.loading));
  //   final response = await _quranSurahUseCase.call(const NoParams());
  //   response.fold((l) {
  //     emit(state.copyWith(failure: l, status: QuranStates.error));
  //   }, (data) {
  //     emit(state.copyWith(quranSurah: data,status: QuranStates.success));
  //   });
  // }

  Future<void> fetchSurah({required int id}) async {
    emit(state.copyWith(status: QuranStates.loading));
    final response = await _surahUseCase.call(id);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: QuranStates.error));
    }, (data) {
      emit(state.copyWith(surah: data, status: QuranStates.success));
    });
  }
}
