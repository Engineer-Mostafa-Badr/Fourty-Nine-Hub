import 'package:flutter/material.dart';

import '../../data/models/tinder_person_model.dart';
import '../../data/models/tinder_subcategory_model.dart';

class TinderViewState {
  final List<UserData> userData;
  final List<SubCategoryData> subCategoryData;
  final Offset position;
  final Offset startDragOffset;
  final double rotation;
  final int currentIndex;
  final int currentStoryIndex;

  TinderViewState({
    required this.userData,
    required this.subCategoryData,
    required this.position,
    required this.startDragOffset,
    required this.rotation,
    required this.currentIndex,
    required this.currentStoryIndex,
  });

  factory TinderViewState.initial() {
    return TinderViewState(
      userData: [],
      subCategoryData: [],
      position: Offset.zero,
      startDragOffset: Offset.zero,
      rotation: 0,
      currentIndex: 0,
      currentStoryIndex: 0,
    );
  }

  TinderViewState updated({
    List<UserData>? userData,
    List<SubCategoryData>? subCategoryData,
    Offset? position,
    Offset? startDragOffset,
    double? rotation,
    int? currentIndex,
    int? currentStoryIndex,
  }) {
    return TinderViewState(
      userData: userData ?? this.userData,
      subCategoryData: subCategoryData ?? this.subCategoryData,
      position: position ?? this.position,
      startDragOffset: startDragOffset ?? this.startDragOffset,
      rotation: rotation ?? this.rotation,
      currentIndex: currentIndex ?? this.currentIndex,
      currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
    );
  }
}
