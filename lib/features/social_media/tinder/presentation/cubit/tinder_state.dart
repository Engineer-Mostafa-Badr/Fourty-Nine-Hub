import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/send_gift_model.dart';
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

class TinderViewState {
  final List<UserData> userData;
  final List<SubCategoryData> subCategoryData;
  final List<GiftData> gifts; // Add gifts data here
  final Offset position;
  final SendGiftErrorData? sendGiftErrorData;
  final Offset startDragOffset;
  final double rotation;
  final int currentIndex;
  final int currentStoryIndex;
  final bool isUserNearby;

  TinderViewState({
    required this.userData,
    required this.subCategoryData,
    required this.gifts, // Initialize gifts here
    required this.position,
    required this.sendGiftErrorData,
    required this.startDragOffset,
    required this.rotation,
    required this.currentIndex,
    required this.currentStoryIndex,
    required this.isUserNearby,
  });

  factory TinderViewState.initial() {
    return TinderViewState(
      userData: [],
      subCategoryData: [],
      gifts: [],
      // Initialize with an empty list
      position: Offset.zero,
      startDragOffset: Offset.zero,
      rotation: 0,
      currentIndex: 0,
      currentStoryIndex: 0,
      isUserNearby: false,
      sendGiftErrorData: SendGiftErrorData(),
    );
  }

  TinderViewState updated({
    List<UserData>? userData,
    List<SubCategoryData>? subCategoryData,
    List<GiftData>? gifts, // Add gifts parameter
    Offset? position,
    SendGiftErrorData? giftErrorData,
    Offset? startDragOffset,
    double? rotation,
    int? currentIndex,
    int? currentStoryIndex,
    bool? isUserNearby,
  }) {
    return TinderViewState(
      userData: userData ?? this.userData,
      subCategoryData: subCategoryData ?? this.subCategoryData,
      gifts: gifts ?? this.gifts,
      // Update gifts data
      position: position ?? this.position,
      startDragOffset: startDragOffset ?? this.startDragOffset,
      rotation: rotation ?? this.rotation,
      currentIndex: currentIndex ?? this.currentIndex,
      currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
      isUserNearby: isUserNearby ?? this.isUserNearby,
      sendGiftErrorData: giftErrorData ?? this.sendGiftErrorData,
    );
  }
}
