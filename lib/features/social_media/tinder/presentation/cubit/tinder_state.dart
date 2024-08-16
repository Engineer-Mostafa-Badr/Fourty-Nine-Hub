import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/add_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';

import '../../data/models/gift_model.dart';

// class TinderViewState {
//   final List<UserData> userData;
//   final List<SubCategoryData> subCategoryData;
//   final Offset position;
//   final Offset startDragOffset;
//   final double rotation;
//   final int currentIndex;
//   final int currentStoryIndex;
//   final bool isUserNearby;  // Add this to keep track of the user's nearby status
//
//   TinderViewState({
//     required this.userData,
//     required this.subCategoryData,
//     required this.position,
//     required this.startDragOffset,
//     required this.rotation,
//     required this.currentIndex,
//     required this.currentStoryIndex,
//     required this.isUserNearby,
//   });
//
//   factory TinderViewState.initial() {
//     return TinderViewState(
//       userData: [],
//       subCategoryData: [],
//       position: Offset.zero,
//       startDragOffset: Offset.zero,
//       rotation: 0,
//       currentIndex: 0,
//       currentStoryIndex: 0,
//       isUserNearby: false,  // Initialize as false
//     );
//   }
//
//   TinderViewState updated({
//     List<UserData>? userData,
//     List<SubCategoryData>? subCategoryData,
//     Offset? position,
//     Offset? startDragOffset,
//     double? rotation,
//     int? currentIndex,
//     int? currentStoryIndex,
//     bool? isUserNearby,  // Add this parameter to update the nearby status
//   }) {
//     return TinderViewState(
//       userData: userData ?? this.userData,
//       subCategoryData: subCategoryData ?? this.subCategoryData,
//       position: position ?? this.position,
//       startDragOffset: startDragOffset ?? this.startDragOffset,
//       rotation: rotation ?? this.rotation,
//       currentIndex: currentIndex ?? this.currentIndex,
//       currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
//       isUserNearby: isUserNearby ?? this.isUserNearby,  // Update the nearby status
//     );
//   }
//
// }

// class TinderViewState {
//   final List<UserData> userData;
//   final List<SubCategoryData> subCategoryData;
//   final List<GiftData> gifts; // Add gifts data here
//   final Offset position;
//   final SendGiftErrorData? sendGiftErrorData;
//   final Offset startDragOffset;
//   final double rotation;
//   final int currentIndex;
//   final int currentStoryIndex;
//   final bool isUserNearby;
//   final LastSeenModel? lastSeenModel;
//
//   TinderViewState({
//     required this.userData,
//     required this.lastSeenModel,
//     required this.subCategoryData,
//     required this.gifts, // Initialize gifts here
//     required this.position,
//     required this.sendGiftErrorData,
//     required this.startDragOffset,
//     required this.rotation,
//     required this.currentIndex,
//     required this.currentStoryIndex,
//     required this.isUserNearby,
//   });
//
//   factory TinderViewState.initial() {
//     return TinderViewState(
//       userData: [],
//       subCategoryData: [],
//       gifts: [],
//       // Initialize with an empty list
//       position: Offset.zero,
//       startDragOffset: Offset.zero,
//       rotation: 0,
//       currentIndex: 0,
//       currentStoryIndex: 0,
//       isUserNearby: false,
//       sendGiftErrorData: SendGiftErrorData(),
//       lastSeenModel: LastSeenModel(),
//     );
//   }
//
//   TinderViewState updated({
//     LastSeenModel? lastSeenModel,
//     List<UserData>? userData,
//     List<SubCategoryData>? subCategoryData,
//     List<GiftData>? gifts, // Add gifts parameter
//     Offset? position,
//     SendGiftErrorData? giftErrorData,
//     Offset? startDragOffset,
//     double? rotation,
//     int? currentIndex,
//     int? currentStoryIndex,
//     bool? isUserNearby,
//   }) {
//     return TinderViewState(
//       userData: userData ?? this.userData,
//       subCategoryData: subCategoryData ?? this.subCategoryData,
//       gifts: gifts ?? this.gifts,
//       // Update gifts data
//       position: position ?? this.position,
//       startDragOffset: startDragOffset ?? this.startDragOffset,
//       rotation: rotation ?? this.rotation,
//       currentIndex: currentIndex ?? this.currentIndex,
//       currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
//       isUserNearby: isUserNearby ?? this.isUserNearby,
//       sendGiftErrorData: giftErrorData ?? this.sendGiftErrorData,
//       lastSeenModel: lastSeenModel,
//     );
//   }
// }
//-------------------------------------
// // Enum for userData
// enum UserDataState { initial, failure, success }
//
// // Enum for subCategoryData
// enum SubCategoryDataState { initial, failure, success }
//
// // Enum for gifts
// enum GiftsState { initial, failure, success }
//
// // Enum for position
// enum PositionState { initial, failure, success }
//
// // Enum for sendGiftErrorData
// enum SendGiftErrorDataState { initial, failure, success }
//
// // Enum for startDragOffset
// enum StartDragOffsetState { initial, failure, success }
//
// // Enum for rotation
// enum RotationState { initial, failure, success }
//
// // Enum for currentIndex
// enum CurrentIndexState { initial, failure, success }
//
// // Enum for currentStoryIndex
// enum CurrentStoryIndexState { initial, failure, success }
//
// // Enum for isUserNearby
// enum IsUserNearbyState { initial, failure, success }
//
// // Enum for lastSeenModel
// enum LastSeenModelState { initial, failure, success }
// class TinderViewState {
//   final List<UserData> userData;
//   final UserDataState userDataState;
//
//   final List<SubCategoryData> subCategoryData;
//   final SubCategoryDataState subCategoryDataState;
//
//   final List<GiftData> gifts;
//   final GiftsState giftsState;
//
//   final Offset position;
//   final PositionState positionState;
//
//   final SendGiftErrorData? sendGiftErrorData;
//   final SendGiftErrorDataState sendGiftErrorDataState;
//
//   final Offset startDragOffset;
//   final StartDragOffsetState startDragOffsetState;
//
//   final double rotation;
//   final RotationState rotationState;
//
//   final int currentIndex;
//   final CurrentIndexState currentIndexState;
//
//   final int currentStoryIndex;
//   final CurrentStoryIndexState currentStoryIndexState;
//
//   final bool isUserNearby;
//   final IsUserNearbyState isUserNearbyState;
//
//   final LastSeenModel? lastSeenModel;
//   final LastSeenModelState lastSeenModelState;
//
//   TinderViewState({
//     required this.userData,
//     required this.userDataState,
//     required this.subCategoryData,
//     required this.subCategoryDataState,
//     required this.gifts,
//     required this.giftsState,
//     required this.position,
//     required this.positionState,
//     required this.sendGiftErrorData,
//     required this.sendGiftErrorDataState,
//     required this.startDragOffset,
//     required this.startDragOffsetState,
//     required this.rotation,
//     required this.rotationState,
//     required this.currentIndex,
//     required this.currentIndexState,
//     required this.currentStoryIndex,
//     required this.currentStoryIndexState,
//     required this.isUserNearby,
//     required this.isUserNearbyState,
//     required this.lastSeenModel,
//     required this.lastSeenModelState,
//   });
//
//   factory TinderViewState.initial() {
//     return TinderViewState(
//       userData: [],
//       userDataState: UserDataState.initial,
//       subCategoryData: [],
//       subCategoryDataState: SubCategoryDataState.initial,
//       gifts: [],
//       giftsState: GiftsState.initial,
//       position: Offset.zero,
//       positionState: PositionState.initial,
//       sendGiftErrorData: SendGiftErrorData(),
//       sendGiftErrorDataState: SendGiftErrorDataState.initial,
//       startDragOffset: Offset.zero,
//       startDragOffsetState: StartDragOffsetState.initial,
//       rotation: 0,
//       rotationState: RotationState.initial,
//       currentIndex: 0,
//       currentIndexState: CurrentIndexState.initial,
//       currentStoryIndex: 0,
//       currentStoryIndexState: CurrentStoryIndexState.initial,
//       isUserNearby: false,
//       isUserNearbyState: IsUserNearbyState.initial,
//       lastSeenModel: LastSeenModel(),
//       lastSeenModelState: LastSeenModelState.initial,
//     );
//   }
//
//   TinderViewState updated({
//     List<UserData>? userData,
//     UserDataState? userDataState,
//     List<SubCategoryData>? subCategoryData,
//     SubCategoryDataState? subCategoryDataState,
//     List<GiftData>? gifts,
//     GiftsState? giftsState,
//     Offset? position,
//     PositionState? positionState,
//     SendGiftErrorData? sendGiftErrorData,
//     SendGiftErrorDataState? sendGiftErrorDataState,
//     Offset? startDragOffset,
//     StartDragOffsetState? startDragOffsetState,
//     double? rotation,
//     RotationState? rotationState,
//     int? currentIndex,
//     CurrentIndexState? currentIndexState,
//     int? currentStoryIndex,
//     CurrentStoryIndexState? currentStoryIndexState,
//     bool? isUserNearby,
//     IsUserNearbyState? isUserNearbyState,
//     LastSeenModel? lastSeenModel,
//     LastSeenModelState? lastSeenModelState,
//   }) {
//     return TinderViewState(
//       userData: userData ?? this.userData,
//       userDataState: userDataState ?? this.userDataState,
//       subCategoryData: subCategoryData ?? this.subCategoryData,
//       subCategoryDataState: subCategoryDataState ?? this.subCategoryDataState,
//       gifts: gifts ?? this.gifts,
//       giftsState: giftsState ?? this.giftsState,
//       position: position ?? this.position,
//       positionState: positionState ?? this.positionState,
//       sendGiftErrorData: sendGiftErrorData ?? this.sendGiftErrorData,
//       sendGiftErrorDataState: sendGiftErrorDataState ?? this.sendGiftErrorDataState,
//       startDragOffset: startDragOffset ?? this.startDragOffset,
//       startDragOffsetState: startDragOffsetState ?? this.startDragOffsetState,
//       rotation: rotation ?? this.rotation,
//       rotationState: rotationState ?? this.rotationState,
//       currentIndex: currentIndex ?? this.currentIndex,
//       currentIndexState: currentIndexState ?? this.currentIndexState,
//       currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
//       currentStoryIndexState: currentStoryIndexState ?? this.currentStoryIndexState,
//       isUserNearby: isUserNearby ?? this.isUserNearby,
//       isUserNearbyState: isUserNearbyState ?? this.isUserNearbyState,
//       lastSeenModel: lastSeenModel ?? this.lastSeenModel,
//       lastSeenModelState: lastSeenModelState ?? this.lastSeenModelState,
//     );
//   }
// }
//refactored
// Enum for representing the state of different properties in the TinderViewState
enum DataState { initial, failure, success }

class TinderViewState {
  final List<UserData>? userData0;
  final DataState? userDataState0;
  final int? currentPage;

  final List<UserData> userData;
  final DataState userDataState;

  final ProfileUserData? profileUserData;
  final DataState profileUserState;

  final List<SubCategoryData> subCategoryData;
  final DataState subCategoryDataState;

  final DataState uploadImageState;

  final SubFavoritesResponse? getFavCategoryModel;
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
    required this.getFavCategoryModelState,
  });

  // Factory method to create an initial state
  factory TinderViewState.initial() {
    return TinderViewState(
      userData: [],
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
      getFavCategoryModelState: DataState.initial,
      addCategoryModel: AddCategoryModel(),
      addCategoryModelState: DataState.initial,
      profileUserData: null,
      profileUserState: DataState.initial,
      uploadImageState: DataState.initial,
      userData0: [],
      userDataState0: DataState.initial,
    );
  }

  // Method to update the state
  TinderViewState copyWith({
    List<UserData>? userData0,
    DataState? userDataState0,
    int? currentPage,
    ProfileUserData? profileUserData,
    DataState? profileUserState,
    SubFavoritesResponse? getFavCategoryList,
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
      getFavCategoryModelState:
          getFavCategoryListState ?? getFavCategoryModelState,
      addCategoryModel: addCategoryModel ?? this.addCategoryModel,
      addCategoryModelState:
          addCategoryModelState ?? this.addCategoryModelState,
      profileUserData: profileUserData ?? this.profileUserData,
      profileUserState: profileUserState ?? this.profileUserState,
      uploadImageState: this.uploadImageState,
    );
  }
}
