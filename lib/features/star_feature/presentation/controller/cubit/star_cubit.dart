import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_myl_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class StarCubit extends Cubit<StarState> {
  final FetchAllStarUseCase _allStarUseCase;
  final FetchMylStarUseCase _fetchMylStarUseCase;
  final UploadMyStarUseCase _uploadMyStarUseCase;

  StarCubit(this._allStarUseCase, this._fetchMylStarUseCase,
      this._uploadMyStarUseCase)
      : super(StarState());

  TextEditingController starController = TextEditingController();

  void onRefresh() async {
    starPagingController.refresh();
   // StarPagingUserController.refresh();
  }

  void loadData() async {
    //   await getFeed(1);
    getPaginatedStar(1);
    getPaginatedMyStar(1);
    //getPaginatedUserStar(1);
    starPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedStar(pageKey);
    });
    starPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedMyStar(pageKey);
    });
    // StarPagingUserController.addPageRequestListener((pageKey) {
    //   print("initStatePageKey : $pageKey");
    //   getPaginatedUserStar(params, pageKey);
    // });
  }


  final PagingController<int, StarEntity> starPagingController =
      PagingController(firstPageKey: 1);
  final int pageSize = 10;

  Future<List<StarEntity>> getPaginatedStar(int page) async {
    emit(state.copyWith(status: StarStates.loading));
    List<StarEntity> main = [];
    final response = await _allStarUseCase.call(const NoParams());

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: StarStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        starPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        starPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        starPagingController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      main = data;
      emit(state.copyWith(star: data, status: StarStates.success));
    });
    return main;
  }


  Future<List<StarEntity>> getPaginatedMyStar(int page) async {
    emit(state.copyWith(status: StarStates.loading));
    List<StarEntity> main = [];
    final response = await _fetchMylStarUseCase.call(const NoParams());

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: StarStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        starPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        starPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        starPagingController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      main = data;
      emit(state.copyWith(star: data, status: StarStates.success));
    });
    return main;
  }


  Future<void> uploadStar({
    required StarParams params,
  }) async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _uploadMyStarUseCase(params);

    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: StarStates.error));
      },
          (data) {
        emit(state.copyWith(
          status: StarStates.success,
        ));
      },
    );
  }
}
