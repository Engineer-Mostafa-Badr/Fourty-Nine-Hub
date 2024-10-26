import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_surah_use_case.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class QuranCubit extends Cubit<QuranState> {
  final FetchQuranSurahUseCase _quranSurahUseCase;
  final FetchSurahUseCase _surahUseCase;

  QuranCubit(
      this._quranSurahUseCase,
      this._surahUseCase,
      ) : super(const QuranState());



  void onRefresh() async {
    quranSurahPagingController.refresh();
  }
  void loadData() async {
    //   await getFeed(1);
    fetchQuranSurah(1);
    quranSurahPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      fetchQuranSurah(pageKey);
    });
  }

  final PagingController<int, QuranSurahEntity> quranSurahPagingController =
  PagingController(firstPageKey: 1);
  final int pageSize = 10;

  Future<List<QuranSurahEntity>> fetchQuranSurah(int page) async {
    emit(state.copyWith( status: QuranStates.loading));
    List<QuranSurahEntity> main = [];
    final response = await _quranSurahUseCase.call(QuranParams(params: PaginationParams(page: page,limit: pageSize)));

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: QuranStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        quranSurahPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        quranSurahPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        quranSurahPagingController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      main = data;
      emit(state.copyWith(quranSurah: data,status: QuranStates.success));

    });
    return main;
  }

  Future<void> fetchSurah({required int id}) async {
    emit(state.copyWith( status: QuranStates.loading));
    final response = await _surahUseCase.call(id);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: QuranStates.error));
    }, (data) {
      emit(state.copyWith(surah: data));
    });
  }
}
