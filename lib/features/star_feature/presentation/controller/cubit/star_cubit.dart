import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_winner_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/delete_my_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_banner_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_myl_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_winner_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/upload_my_star_use_case.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/cubit/star_state.dart';

class StarCubit extends Cubit<StarState> {
  final FetchAllStarUseCase _allStarUseCase;
  final FetchMylStarUseCase _fetchMylStarUseCase;
  final FetchWinnerStarUseCase _fetchWinnerStarUseCase;
  final UploadMyStarUseCase _uploadMyStarUseCase;
  final DeleteMyStarUseCase _deleteMyTalentUseCase;
  final FetchBannerUseCase _bannerUseCase;

  StarCubit(
      this._allStarUseCase,
      this._fetchMylStarUseCase,
      this._uploadMyStarUseCase,
      this._deleteMyTalentUseCase,
      this._fetchWinnerStarUseCase,
      this._bannerUseCase)
      : super(StarState());

  // TextEditingController starController = TextEditingController();

  List<StarEntity> star = [];
  List<StarWinnerEntity> winner = [];
  // List<AzkarDetailsEntity> azkarDetails = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadInitialData() async {
    emit(state.copyWith(status: StarStates.loading));
    star.clear();
    currentPage = 1;
    hasMoreData = true;
    await getAllTalent(refresh: true);
  }

  List<StarEntity> allTalents = [];
  bool loadAllTalents = false;
  Future loadAllTalentsData() async {
    loadAllTalents=true;
    allTalents.clear();
    allTalentsPage = 1;
    hasMoreAllTalentsData = true;
    emit(state.copyWith(status: StarStates.loading));
    await getAllTalents();
    await Future.wait([
      getAllTalents(),
      fetchBanner()
    ]);
    loadAllTalents=false;
    emit(state.copyWith(status: StarStates.success));
  }
  bool isLoadingAllTalentsMore = false;
  bool hasMoreAllTalentsData = true;
  int allTalentsPage = 1;
  Future<void> getAllTalents() async {
    print(hasMoreAllTalentsData);
    print(isLoadingAllTalentsMore);
    if (!hasMoreAllTalentsData || isLoadingAllTalentsMore) return;
    isLoadingAllTalentsMore = true;
    emit(state.copyWith(status: StarStates.loading));
    final response = await _allStarUseCase(
      StarPaginationParams(page: currentPage, limit: pageSize),
    );
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StarStates.error)),
            (data) async {
          allTalents.addAll(data);
          if (data.length < pageSize) {
            hasMoreAllTalentsData = false;
          } else {
            allTalentsPage++;
          }
          isLoadingAllTalentsMore = false;
          emit(state.copyWith(status: StarStates.initial));
        });
  }

  List<StarEntity> myTalents = [];
  bool loadMyTalents = false;
  Future loadMyTalentsData() async {
    loadMyTalents=true;
    myTalents.clear();
    myTalentsPage = 1;
    hasMoreMyTalentsData = true;
    emit(state.copyWith(status: StarStates.loading));
    await getMyTalents();
    loadMyTalents=false;
    emit(state.copyWith(status: StarStates.success));
  }
  bool isLoadingMyTalentsMore = false;
  bool hasMoreMyTalentsData = true;
  int myTalentsPage = 1;
  Future<void> getMyTalents() async {
    if (!hasMoreMyTalentsData || isLoadingMyTalentsMore) return;
    isLoadingMyTalentsMore = true;
    emit(state.copyWith(status: StarStates.loading));
    final response = await _fetchMylStarUseCase.call(const NoParams());

    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StarStates.error)),
            (data) async {
          myTalents.addAll(data);
          if (data.length < pageSize) {
            hasMoreMyTalentsData = false;
          } else {
            myTalentsPage++;
          }
          isLoadingMyTalentsMore = false;
          emit(state.copyWith(status: StarStates.success));
        });
  }

  void loadInitialDataWinner() async {
    emit(state.copyWith(status: StarStates.loading));
    winner.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchWinnerStar();
  }

  Future<void> getAllTalent({bool refresh = false}) async {
    if (refresh) {
      star.clear();
      currentPage = 1;
      hasMoreData = true;
      isLoadingMore = false;
    }

    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _allStarUseCase(
      StarPaginationParams(page: currentPage, limit: pageSize),
    );

    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StarStates.error)),
      (data) {
        if (refresh) {
          star = data;
        } else {
          star.addAll(data);
        }

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(star: star, status: StarStates.success));
      },
    );
  }

  Future<void> fetchWinnerStar() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _fetchWinnerStarUseCase(
      StarPaginationParams(page: currentPage, limit: pageSize),
    );

    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StarStates.error)),
      (data) {
        winner.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(winner: winner, status: StarStates.success));
      },
    );
  }

  // final PagingController<int, StarEntity> starPagingController =
  //     PagingController(firstPageKey: 1);

  // Future<List<StarEntity>> getPaginatedMyStar(int page) async {
  //   emit(state.copyWith(status: StarStates.loading));
  //   List<StarEntity> main = [];
  //   final response = await _fetchMylStarUseCase.call(const NoParams());
  //
  //   response.fold((l) {
  //     print('Errrrrrrror :$l');
  //     emit(state.copyWith(failure: l, status: StarStates.error));
  //   }, (data) {
  //     final isLastPage = data.length < pageSize;
  //     if (page == 1) {
  //       print("page == 1 $page");
  //       starPagingController.itemList = [];
  //     }
  //     if (isLastPage) {
  //       print("isLastPage = $isLastPage");
  //       starPagingController.appendLastPage(data);
  //     } else {
  //       print("isNotLastPage = $isLastPage");
  //       final nextPageKey = page + 1;
  //       starPagingController.appendPage(data, nextPageKey);
  //     }
  //     print('Sussecc :$data');
  //     main = data;
  //     emit(state.copyWith(star: data, status: StarStates.success));
  //   });
  //   return main;
  // }

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
          status: StarStates.uploadSuccess,
          

        ));
      },
    );
  }

  Future<void> fetchBanner() async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _bannerUseCase(const NoParams());

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StarStates.error));
      },
      (data) {
        emit(state.copyWith(
          banner: data,
          status: StarStates.success,
        ));
      },
    );
  }

  Future<void> deleteMyTalent({
    required String id,
  }) async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _deleteMyTalentUseCase(id);

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

  List<String>? selectedVideo;

  uploadVideo({bool isGallery = true,required BuildContext context}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadVideo(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("file name ${data.file}");
          print("mediaId: ${data.mediaId}");
          selectedVideo?.add(data.mediaId);
          final video = state.video ?? [];

          video.add(data);
          selectedVideo = video.map((e) => e.mediaId).toList();
          print("selectedvideo${selectedVideo?.length}");
          print(video.length);
          emit(state.copyWith(
              video: video,
              // backColor: '#FFFFFFFF',
              status: StarStates.success));
        }, context: context);
    print("length${state.video?.length}");
  }

  void clearSelectedVideos() {
    selectedVideo = [];
    emit(state.copyWith(video: []));
  }
}
