import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/add_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/anonymous_chat_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/normal_chat_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/last_seen_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/user_data_tinder_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../../../fourty_nine/domain/entities/main_category_entity.dart';
import '../../data/models/gift_model.dart';

enum TinderStates { initial, loading, failure, success }

extension DataStateExtension on TinderViewState {
  bool get isInitial => status == TinderStates.initial;

  bool get isSuccess => status == TinderStates.success;

  bool get isFailure => status == TinderStates.failure;

  bool get isLoading => status == TinderStates.loading;
}

class TinderViewState {
  final TinderStates status;
  final Failure? failure;
  final List<UserDataTinderEntity>? userData0;
  final TinderStates? userDataState0;
  final int? currentPage;

  final String? gender; // Made nullable

  final List<UserDataTinderEntity>? userData;
  final TinderStates? userDataState;

  final ProfileUserData? profileUserData;
  final TinderStates? profileUserState;

  final MainCategoryEntity? mainCategoryResponse;
  final TinderStates? mainCategoryResponseState;

  final NormalChatResponse? normalChatResponse;
  final TinderStates? normalChatResponseState;

  final AnonymousChatResponse? anonymousChatResponse;
  final TinderStates? anonymousChatResponseState;

  final List<SubCategoryEntity>? subCategoryData;
  final TinderStates? subCategoryDataState;

  final TinderStates? uploadImageState;

  final SubFavoritesResponse? getFavCategoryModel;
  final CategoryFavoritesResponse? getFavoriteCategoryModel;
  final TinderStates? getFavCategoryModelState;

  final AddCategoryModel? addCategoryModel;
  final TinderStates? addCategoryModelState;

  final List<GiftData>? gifts;
  final TinderStates? giftsState;

  final Offset? position;
  final TinderStates? positionState;

  final String? sendGiftErrorData;
  final TinderStates? sendGiftErrorDataState;

  final Offset? startDragOffset;
  final TinderStates? startDragOffsetState;

  final double? rotation;
  final TinderStates? rotationState;

  final int? currentIndex;
  final TinderStates? currentIndexState;

  final int? currentStoryIndex;
  final TinderStates? currentStoryIndexState;

  final NearByModel? isUserNearby;
  final TinderStates? isUserNearbyState;

  final LastSeenEntity? lastSeenModel;
  final TinderStates? lastSeenModelState;

  TinderViewState({
    this.status = TinderStates.initial,
    this.failure,
    this.gender = 'female',
    this.mainCategoryResponse,
    this.mainCategoryResponseState = TinderStates.initial,
    this.anonymousChatResponse,
    this.anonymousChatResponseState = TinderStates.initial,
    this.normalChatResponse,
    this.normalChatResponseState = TinderStates.initial,
    this.userData0,
    this.userDataState0 = TinderStates.initial,
    this.currentPage = 0,
    this.uploadImageState = TinderStates.initial,
    this.profileUserData,
    this.profileUserState =  TinderStates.initial,
    this.addCategoryModel,
    this.addCategoryModelState = TinderStates.initial,
    this.userData = const [],
    this.userDataState = TinderStates.initial,
    this.subCategoryData = const [],
    this.subCategoryDataState = TinderStates.initial,
    this.gifts =  const [],
    this.giftsState = TinderStates.initial,
    this.position = Offset.zero,
    this.positionState = TinderStates.initial,
    this.sendGiftErrorData = '',
    this.sendGiftErrorDataState = TinderStates.initial,
    this.startDragOffset = Offset.zero,
    this.startDragOffsetState = TinderStates.initial,
    this.rotation = 0,
    this.rotationState = TinderStates.initial,
    this.currentIndex = 0,
    this.currentIndexState = TinderStates.initial,
    this.currentStoryIndex = 0,
    this.currentStoryIndexState = TinderStates.initial,
    this.isUserNearby,
    this.isUserNearbyState = TinderStates.initial,
    this.lastSeenModel ,
    this.lastSeenModelState,
    this.getFavCategoryModel,
    this.getFavoriteCategoryModel,
    this.getFavCategoryModelState,
  });

  // Method to update the state
  TinderViewState copyWith({
    TinderStates? status,
    Failure? failure,
    String? gender,
    List<UserDataTinderEntity>? userData0,
    TinderStates? userDataState0,
    int? currentPage,
    List<UserDataTinderEntity>? userData,
    TinderStates? userDataState,
    List<SubCategoryEntity>? subCategoryData,
    TinderStates? subCategoryDataState,
    List<GiftData>? gifts,
    TinderStates? giftsState,
    Offset? position,
    TinderStates? positionState,
    String? sendGiftErrorData,
    TinderStates? sendGiftErrorDataState,
    Offset? startDragOffset,
    TinderStates? startDragOffsetState,
    double? rotation,
    TinderStates? rotationState,
    int? currentIndex,
    TinderStates? currentIndexState,
    int? currentStoryIndex,
    TinderStates? currentStoryIndexState,
    NearByModel? isUserNearby,
    TinderStates? isUserNearbyState,
    LastSeenEntity? lastSeenModel,
    TinderStates? lastSeenModelState,
    MainCategoryEntity? mainCategoryEntity,
    TinderStates? mainCategoryResponseState,
    AnonymousChatResponse? anonymousChatResponse,
    TinderStates? anonymousChatResponseState,
    NormalChatResponse? normalChatResponse,
    TinderStates? normalChatResponseState,
    ProfileUserData? profileUserData,
    TinderStates? profileUserState,
    AddCategoryModel? addCategoryModel,
    TinderStates? addCategoryModelState,
    SubFavoritesResponse? getFavCategoryList,
    CategoryFavoritesResponse? FavoriteCategoryList,
    TinderStates? getFavCategoryListState,
    TinderStates? uploadImageState,
  }) {
    return TinderViewState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      gender: gender ?? this.gender,
      userData0: userData0 ?? this.userData0,
      userDataState0: userDataState0 ?? this.userDataState0,
      currentPage: currentPage ?? this.currentPage,
      userData: userData ?? this.userData,
      userDataState: userDataState ?? this.userDataState,
      subCategoryData: subCategoryData ?? this.subCategoryData,
      subCategoryDataState: subCategoryDataState ?? this.subCategoryDataState,
      gifts: gifts ?? this.gifts,
      giftsState: giftsState ?? this.giftsState,
      position: position ?? this.position,
      positionState: positionState ?? this.positionState,
      sendGiftErrorData: sendGiftErrorData ?? this.sendGiftErrorData,
      sendGiftErrorDataState:
          sendGiftErrorDataState ?? this.sendGiftErrorDataState,
      startDragOffset: startDragOffset ?? this.startDragOffset,
      startDragOffsetState: startDragOffsetState ?? this.startDragOffsetState,
      rotation: rotation ?? this.rotation,
      rotationState: rotationState ?? this.rotationState,
      currentIndex: currentIndex ?? this.currentIndex,
      currentIndexState: currentIndexState ?? this.currentIndexState,
      currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
      currentStoryIndexState:
          currentStoryIndexState ?? this.currentStoryIndexState,
      isUserNearby: isUserNearby ?? this.isUserNearby,
      isUserNearbyState: isUserNearbyState ?? this.isUserNearbyState,
      lastSeenModel: lastSeenModel ?? this.lastSeenModel,
      lastSeenModelState: lastSeenModelState ?? this.lastSeenModelState,
      getFavCategoryModel: getFavCategoryList ?? getFavCategoryModel,
      getFavoriteCategoryModel:
          FavoriteCategoryList ?? getFavoriteCategoryModel,
      getFavCategoryModelState:
          getFavCategoryListState ?? getFavCategoryModelState,
      addCategoryModel: addCategoryModel ?? this.addCategoryModel,
      addCategoryModelState:
          addCategoryModelState ?? this.addCategoryModelState,
      profileUserData: profileUserData ?? this.profileUserData,
      profileUserState: profileUserState ?? this.profileUserState,
      uploadImageState: uploadImageState ?? this.uploadImageState,
      normalChatResponse: normalChatResponse ?? this.normalChatResponse,
      normalChatResponseState:
          normalChatResponseState ?? this.normalChatResponseState,
      anonymousChatResponseState:
          anonymousChatResponseState ?? this.anonymousChatResponseState,
      anonymousChatResponse:
          anonymousChatResponse ?? this.anonymousChatResponse,
      mainCategoryResponse: mainCategoryEntity ?? this.mainCategoryResponse,
      mainCategoryResponseState:
          mainCategoryResponseState ?? this.mainCategoryResponseState,
    );
  }
}
