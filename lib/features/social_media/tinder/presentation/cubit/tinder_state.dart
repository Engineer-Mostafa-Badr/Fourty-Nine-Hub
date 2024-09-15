import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/add_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/anonymous_chat_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/main_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/normal_chat_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';

import '../../data/models/gift_model.dart';

enum DataState { initial, failure, success }

class TinderViewState {
  final List<UserData>? userData0;
  final DataState? userDataState0;
  final int? currentPage;

  final String gender; // Add gender to the state

  final List<UserData> userData;
  final DataState userDataState;

  final ProfileUserData? profileUserData;
  final DataState profileUserState;

  final MainCategoryResponse? mainCategoryResponse;
  final DataState mainCategoryResponseState;

  final NormalChatResponse? normalChatResponse;
  final DataState normalChatResponseState;

  final AnonymousChatResponse? anonymousChatResponse;
  final DataState anonymousChatResponseState;

  final List<SubCategoryData> subCategoryData;
  final DataState subCategoryDataState;

  final DataState uploadImageState;

  final SubFavoritesResponse? getFavCategoryModel;
  final CategoryFavoritesResponse? getFavoriteCategoryModel;
  final DataState getFavCategoryModelState;

  // final FavoritesResponse favoritesResponse;
  // final DataState favoritesResponseState;

  final AddCategoryModel addCategoryModel;
  final DataState addCategoryModelState;

  final List<GiftData> gifts;
  final DataState giftsState;

  final Offset position;
  final DataState positionState;

  final String? sendGiftErrorData;

  // final SendGiftErrorData? sendGiftErrorData;
  final DataState sendGiftErrorDataState;

  final Offset startDragOffset;
  final DataState startDragOffsetState;

  final double rotation;
  final DataState rotationState;

  final int currentIndex;
  final DataState currentIndexState;

  final int currentStoryIndex;
  final DataState currentStoryIndexState;

  final NearByModel? isUserNearby;
  final DataState isUserNearbyState;

  final LastSeenModel? lastSeenModel;
  final DataState lastSeenModelState;

  TinderViewState({
    required this.gender,
    required this.mainCategoryResponse,
    required this.mainCategoryResponseState,
    required this.anonymousChatResponse,
    required this.anonymousChatResponseState,
    required this.normalChatResponse,
    required this.normalChatResponseState,
    required this.userData0,
    required this.userDataState0,
    this.currentPage = 1,
    required this.uploadImageState,
    required this.profileUserData,
    required this.profileUserState,
    required this.addCategoryModel,
    required this.addCategoryModelState,
    required this.userData,
    required this.userDataState,
    required this.subCategoryData,
    required this.subCategoryDataState,
    required this.gifts,
    required this.giftsState,
    required this.position,
    required this.positionState,
    required this.sendGiftErrorData,
    required this.sendGiftErrorDataState,
    required this.startDragOffset,
    required this.startDragOffsetState,
    required this.rotation,
    required this.rotationState,
    required this.currentIndex,
    required this.currentIndexState,
    required this.currentStoryIndex,
    required this.currentStoryIndexState,
    required this.isUserNearby,
    required this.isUserNearbyState,
    required this.lastSeenModel,
    required this.lastSeenModelState,
    required this.getFavCategoryModel,
    required this.getFavoriteCategoryModel,
    required this.getFavCategoryModelState,
  });

  // Factory method to create an initial state
  factory TinderViewState.initial() {
    return TinderViewState(
      userData: [],
      gender: 'female', // Default gender
      userDataState: DataState.initial,
      subCategoryData: [],
      subCategoryDataState: DataState.initial,
      gifts: [],
      giftsState: DataState.initial,
      position: Offset.zero,
      positionState: DataState.initial,
      sendGiftErrorData: '',
      sendGiftErrorDataState: DataState.initial,
      startDragOffset: Offset.zero,
      startDragOffsetState: DataState.initial,
      rotation: 0,
      rotationState: DataState.initial,
      currentIndex: 0,
      currentIndexState: DataState.initial,
      currentStoryIndex: 0,
      currentStoryIndexState: DataState.initial,
      isUserNearby: NearByModel(),
      isUserNearbyState: DataState.initial,
      lastSeenModel: LastSeenModel(),
      lastSeenModelState: DataState.initial,
      getFavCategoryModel: null,
      getFavoriteCategoryModel: null,
      getFavCategoryModelState: DataState.initial,
      addCategoryModel: AddCategoryModel(),
      addCategoryModelState: DataState.initial,
      profileUserData: null,
      profileUserState: DataState.initial,
      uploadImageState: DataState.initial,
      userData0: [],
      userDataState0: DataState.initial,
      normalChatResponse: null,
      normalChatResponseState: DataState.initial,
      anonymousChatResponse: null,
      anonymousChatResponseState: DataState.initial,
      mainCategoryResponse: null,
      mainCategoryResponseState: DataState.initial,
    );
  }

  // Method to update the state
  TinderViewState copyWith({
    MainCategoryResponse? mainCategoryResponse,
    DataState? mainCategoryResponseState,
    AnonymousChatResponse? anonymousChatResponse,
    DataState? anonymousChatResponseState,
    NormalChatResponse? normalChatResponse,
    DataState? normalChatResponseState,
    List<UserData>? userData0,
    DataState? userDataState0,
    int? currentPage,
    String? gender,
    ProfileUserData? profileUserData,
    DataState? profileUserState,
    SubFavoritesResponse? getFavCategoryList,
    CategoryFavoritesResponse? FavoriteCategoryList,
    DataState? getFavCategoryListState,
    AddCategoryModel? addCategoryModel,
    DataState? addCategoryModelState,
    List<UserData>? userData,
    DataState? userDataState,
    List<SubCategoryData>? subCategoryData,
    DataState? subCategoryDataState,
    // GetFavCategoryModel? favoritesResponse,
    DataState? favoritesResponseState,
    List<GiftData>? gifts,
    DataState? giftsState,
    Offset? position,
    DataState? positionState,
    String? sendGiftErrorData,
    // SendGiftErrorData? sendGiftErrorData,
    DataState? sendGiftErrorDataState,
    Offset? startDragOffset,
    DataState? startDragOffsetState,
    double? rotation,
    DataState? rotationState,
    int? currentIndex,
    DataState? currentIndexState,
    int? currentStoryIndex,
    DataState? currentStoryIndexState,
    NearByModel? isUserNearby,
    DataState? uploadImageState,
    DataState? isUserNearbyState,
    LastSeenModel? lastSeenModel,
    DataState? lastSeenModelState,
  }) {
    return TinderViewState(
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
      uploadImageState: this.uploadImageState,
      normalChatResponse: normalChatResponse ?? this.normalChatResponse,
      normalChatResponseState:
          normalChatResponseState ?? this.normalChatResponseState,
      anonymousChatResponseState:
          anonymousChatResponseState ?? this.anonymousChatResponseState,
      anonymousChatResponse:
          anonymousChatResponse ?? this.anonymousChatResponse,
      mainCategoryResponse: mainCategoryResponse ?? this.mainCategoryResponse,
      mainCategoryResponseState:
          mainCategoryResponseState ?? this.mainCategoryResponseState,
    );
  }
}
