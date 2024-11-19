import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import '../../data/models/near_by_model.dart';
import '../../data/models/tinder_person_model.dart';
import '../../data/repo/tinder_repo.dart';
import 'tinder_state.dart';

class TinderViewCubit extends Cubit<TinderViewState> {
  final TinderRepository tinderRepository;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  final bool _hasMoreData = true;
  String? _currentGender;
  final GetMainCategoryDetailsUseCase getMainCategoryDetailsUseCase;

  TinderViewCubit(
      {required this.tinderRepository,
      required this.getMainCategoryDetailsUseCase})
      : super(TinderViewState());

  Future<void> fetchUserData({
    required String gender,
    bool isLoadMore = false,
  }) async {
    // if (_isLoadingMore || _hasMoreData) {
    //   print('if (_isLoadingMore || !_hasMoreData) {');
    //   return;
    // }
    emit(state.copyWith(userDataState: TinderStates.initial));
    // Check if the gender has changed
    if (state.gender != gender) {
      _currentPage = 1;
      // _hasMoreData = true;
      emit(state.copyWith(userData: [], gender: gender)); // Clear existing data
    }

    final page = isLoadMore ? _currentPage + 1 : 1;
    _isLoadingMore = true;

    final userData = await tinderRepository.fetchUserData(gender, page);

    if (userData != null) {
      if (userData.isEmpty) {
        // _hasMoreData = false;
      } else {
        _currentPage = page;
        final List<UserData> updatedUserData = isLoadMore
            ? (List.from(state.userData!)..addAll(userData))
            : userData;
        log("$gender/***************************************************************************************************************************************************************");

        emit(state.copyWith(
            userData: updatedUserData,
            userDataState: TinderStates.success,
            gender: state.gender));
      }
    } else {
      emit(state.copyWith(userDataState: TinderStates.failure));
    }

    _isLoadingMore = false;
  }

  Future<void> loadMoreUserData(String gender) async {
    log("*************************************************************************************************************************************************************** "
        "from loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData ");
    await fetchUserData(gender: state.gender!, isLoadMore: true);
  }

  Future<void> fetchMainCategoryById(BuildContext context, String id) async {
    emit(state.copyWith(
        mainCategoryResponseState: TinderStates.loading,
        status: TinderStates.loading));
    final mainCategoryResponse = await getMainCategoryDetailsUseCase(id);
    // log('main categoty response ${mainCategoryResponse?.data.mainCategory.nameEn}');

    mainCategoryResponse.fold((l) {
      log('there is a failure ${getFailureMessage(l, context)}');

      emit(state.copyWith(
        mainCategoryResponseState: TinderStates.failure,
        status: TinderStates.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        mainCategoryResponseState: TinderStates.success,
        mainCategoryEntity: r,
        status: TinderStates.success,
      ));
    });

    // if (mainCategoryResponse != null) {
    //   print(mainCategoryResponse.data.mainCategory.nameEn);
    //
    //   emit(state.copyWith(
    //       mainCategoryResponseState: DataState.success,
    //       mainCategoryResponse: mainCategoryResponse));
    //   // log('main categoty response ${mainCategoryResponse.data.mainCategory.nameEn}');
    // } else {
    //   emit(state.copyWith(mainCategoryResponseState: DataState.failure));
    // }
  }

  Future<bool> startNormalChat({
    required String receiverId,
    required String subCategoryId,
  }) async {
    emit(state.copyWith(normalChatResponseState: TinderStates.initial));
    final normalChatModel =
        await tinderRepository.startNormalChat(receiverId, subCategoryId);
    if (normalChatModel != null) {
      emit(state.copyWith(
          normalChatResponse: normalChatModel,
          normalChatResponseState: TinderStates.success));
      return true;
    } else {
      emit(state.copyWith(normalChatResponseState: TinderStates.failure));
      return false;
    }
  }

  Future<bool> startAnonymousChat({
    required String receiverId,
  }) async {
    emit(state.copyWith(anonymousChatResponseState: TinderStates.initial));
    final anonymousChatModel =
        await tinderRepository.startAnonymousChat(receiverId);
    if (anonymousChatModel != null) {
      emit(state.copyWith(
          anonymousChatResponse: anonymousChatModel,
          anonymousChatResponseState: TinderStates.success));
      return true;
    } else {
      emit(state.copyWith(anonymousChatResponseState: TinderStates.failure));
      return false;
    }
  }

  Future<void> fetchUserProfile({required String userId}) async {
    emit(state.copyWith(profileUserState: TinderStates.initial));
    final userModel = await tinderRepository.fetchUserProfile(userId);
    if (userModel != null) {
      emit(state.copyWith(
          profileUserState: TinderStates.success,
          profileUserData: userModel.data));
    } else {
      emit(state.copyWith(profileUserState: TinderStates.failure));
    }
  }

  Future<void> fetchFavorites() async {
    emit(state.copyWith(getFavCategoryListState: TinderStates.initial));
    final apiResponse = await tinderRepository.fetchFavorites();
    if (apiResponse != null) {
      emit(state.copyWith(
          getFavCategoryListState: TinderStates.success,
          getFavCategoryList: apiResponse));
    } else {
      emit(state.copyWith(getFavCategoryListState: TinderStates.failure));
    }
  }

  Future<void> fetchFavoritesCategory() async {
    emit(state.copyWith(getFavCategoryListState: TinderStates.initial));
    final apiResponse = await tinderRepository.fetchFavoritesCategory();
    if (apiResponse != null) {
      emit(state.copyWith(
          getFavCategoryListState: TinderStates.success,
          FavoriteCategoryList: apiResponse));
    } else {
      emit(state.copyWith(getFavCategoryListState: TinderStates.failure));
    }
  }

  Future<void> addFavoriteCategory({String? categoryId}) async {
    emit(state.copyWith(addCategoryModelState: TinderStates.initial));
    final isSuccess = await tinderRepository.addFavoriteCategory(categoryId!);
    if (isSuccess) {
      emit(state.copyWith(addCategoryModelState: TinderStates.success));
    } else {
      emit(state.copyWith(addCategoryModelState: TinderStates.failure));
    }
  }

  Future<bool> fetchLastSeen({
    required String userId,
  }) async {
    emit(state.copyWith(
      lastSeenModelState: TinderStates.initial,
    ));

    final lastSeenModel = await tinderRepository.fetchLastSeen(userId);
    if (lastSeenModel != null) {
      emit(state.copyWith(
          lastSeenModel: lastSeenModel,
          lastSeenModelState: TinderStates.success));
      return true;
      // print(lastSeenModel.data!.status.toString() +
      //     "sssssssssssssssssssssssssssssssss");
    } else {
      print("sssssssssssssssssssssssssssssssss");
      emit(state.copyWith(lastSeenModelState: TinderStates.failure));
      return false;
    }
  }

  Future<dynamic> sendGift({
    required String receiverId,
    required String giftId,
    required String subCategoryId,
  }) async {
    emit(state.copyWith(sendGiftErrorDataState: TinderStates.initial));
    final response =
        await tinderRepository.sendGift(receiverId, giftId, subCategoryId);
    if (response != null) {
      log("$response--------------------------------------");
      emit(state.copyWith(sendGiftErrorDataState: TinderStates.success));
      return response;
    } else {
      emit(state.copyWith(sendGiftErrorDataState: TinderStates.failure));
    }
    return '';
  }

  Future<void> fetchGifts() async {
    emit(state.copyWith(giftsState: TinderStates.initial));
    final giftData = await tinderRepository.fetchGifts();
    log("${giftData}dsssssssssssssssssaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    if (giftData != null) {
      emit(state.copyWith(gifts: giftData, giftsState: TinderStates.success));
    } else {
      emit(state.copyWith(giftsState: TinderStates.failure));
    }
  }

  Future<void> checkUserNearby({
    required String cardUserId,
  }) async {
    emit(state.copyWith(isUserNearbyState: TinderStates.initial));
    final nearByModel = await tinderRepository.checkUserNearby(cardUserId);
    if (nearByModel != null) {
      emit(state.copyWith(
          isUserNearby: nearByModel, isUserNearbyState: TinderStates.success));
    } else {
      emit(state.copyWith(
          isUserNearbyState: TinderStates.failure,
          isUserNearby: NearByModel()));
    }
  }

  Future<void> fetchSubCategoryData() async {
    emit(state.copyWith(subCategoryDataState: TinderStates.initial));
    final subCategoryData = await tinderRepository.fetchSubCategoryData();
    if (subCategoryData != null) {
      // fetchMainCategoryById('62c8b5b09332225799fe335e');
      emit(state.copyWith(
          subCategoryData: subCategoryData,
          subCategoryDataState: TinderStates.success));
    } else {
      emit(state.copyWith(subCategoryDataState: TinderStates.failure));
    }
  }

  // Future<void> fetchUserData({
  //   required String gender,
  // }) async {
  //   emit(state.copyWith(userDataState: DataState.initial, userData: []));
  //   final userData = await tinderRepository.fetchUserData(gender);
  //   if (userData != null) {
  //     log(userData.first.email.toString() +
  //         '000000000000000000000000000000000000000');
  //     emit(
  //         state.copyWith(userData: userData, userDataState: DataState.success));
  //   } else {
  //     emit(state.copyWith(userDataState: DataState.failure, userData: []));
  //   }
  // }

  Future<void> uploadPictures({
    required List<String> pictures,
  }) async {
    emit(state.copyWith(uploadImageState: TinderStates.initial));
    await tinderRepository.uploadPictures(pictures);
    emit(state.copyWith(uploadImageState: TinderStates.success));
  }

  // Pan and Story handling methods
  void updatePanStart(Offset startDragOffset) {
    emit(state.copyWith(startDragOffset: startDragOffset));
  }

  void updatePanUpdate(Offset position, double rotation) {
    emit(state.copyWith(position: position, rotation: rotation));
  }

  void resetPan() {
    emit(state.copyWith(position: Offset.zero, rotation: 0));
  }

  void swipeAway() {
    emit(state.copyWith(
      position: Offset(state.position!.dx * 50, state.position!.dy * 50),
    ));
    Future.delayed(const Duration(milliseconds: 300), () {
      emit(state.copyWith(
        currentIndex: (state.currentIndex! + 1) % state.userData!.length,
        currentStoryIndex: 0,
        position: Offset.zero,
        rotation: 0,
      ));
    });
  }

  void nextStory() {
    if (state.currentStoryIndex! <
        state.userData![state.currentIndex!].pictures.length - 1) {
      emit(state.copyWith(currentStoryIndex: state.currentStoryIndex! + 1));
    }
  }

  void previousStory() {
    if (state.currentStoryIndex! > 0) {
      emit(state.copyWith(currentStoryIndex: state.currentStoryIndex! - 1));
    }
  }

  void updateCurrentIndex(int newIndex) {
    emit(state.copyWith(currentIndex: newIndex));
  }

  void resetStoryIndex() {
    emit(state.copyWith(currentStoryIndex: 0));
  }
}
