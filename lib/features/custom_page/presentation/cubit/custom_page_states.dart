import 'package:fourtyninehub/features/custom_page/domain/entity/activate_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/navigate_bar_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

import '../../../../../../core/error/failure.dart';
import '../../data/model/update_custom_page_categorise_model.dart';
import '../../domain/entity/custom_page_categories_entity.dart';
import '../../domain/entity/custom_page_sub_categories_entity.dart';
import '../../domain/entity/sub_tab_entity.dart';

enum CustomPageStates { loading, initial, error, success, updateSuccess,uploadSubCatSuccess }

// class CustomPageState {
//   final CustomPageStates status;
//   final Failure? failure;
//   final SocialPageEntity? social;
//   final SubTabEntity? subTab;
//   final NavigateBarEntity? navigateBar;
//   final List<CustomPageCategoriesEntity>? favourite;
//   final List<CustomPageSubCategoriesEntity>? favouriteSubCat;
//   final List<UpdateCustomPageCategoriesModel>? updateData;
//   late  List<String>? updateCategoriesId;
//   final ActivateEntity? activate;
//
//    CustomPageState({
//     this.status = CustomPageStates.loading,
//     this.failure,
//     this.social,
//     this.subTab,
//     this.navigateBar,
//     this.favourite,
//     this.favouriteSubCat,
//     this.activate,
//     this.updateData = const [],
//     this.updateCategoriesId = const [],
//   });
//
//   CustomPageState copyWith({
//     CustomPageStates? status,
//     Failure? failure,
//     SocialPageEntity? social,
//     SubTabEntity? subTab,
//     NavigateBarEntity? navigateBar,
//     List<CustomPageCategoriesEntity>? favourite,
//     List<CustomPageSubCategoriesEntity>? favouriteSubCat,
//     List<UpdateCustomPageCategoriesModel>? updateData,
//     List<String>? updateCategoriesId,
//     ActivateEntity? activate,
//   }) {
//     return CustomPageState(
//       status: status ?? this.status,
//       failure: failure ?? this.failure,
//       social: social ?? this.social,
//       subTab: subTab ?? this.subTab,
//       navigateBar: navigateBar ?? this.navigateBar,
//       favourite: favourite ?? this.favourite,
//       favouriteSubCat: favouriteSubCat ?? this.favouriteSubCat,
//       activate: activate ?? this.activate,
//       updateData: updateData ?? this.updateData,
//       updateCategoriesId: updateCategoriesId ?? this.updateCategoriesId,
//     );
//   }
//   List<String>? get updateCategoriesIds => updateCategoriesId;
// }
class CustomPageState {
  final CustomPageStates status;
  final Failure? failure;
  final SocialPageEntity? social;
  final SubTabEntity? subTab;
  final NavigateBarEntity? navigateBar;
  final List<CustomPageCategoriesEntity>? favourite;
  final List<CustomPageSubCategoriesEntity>? favouriteSubCat;
  final List<UpdateCustomPageCategoriesModel>? updateData;
  final List<String> updateSubCategoriesId; // ✅ No 'late', and made non-nullable
  final ActivateEntity? activate;

  CustomPageState({
  this.status = CustomPageStates.loading,
  this.failure,
  this.social,
  this.subTab,
  this.navigateBar,
  this.favourite,
  this.favouriteSubCat,
  this.activate,
  this.updateData = const [],
  List<String>? updateSubCategoriesId, // Accepts a nullable list
  }) : updateSubCategoriesId = updateSubCategoriesId ?? [];

  CustomPageState copyWith({
    CustomPageStates? status,
    Failure? failure,
    SocialPageEntity? social,
    SubTabEntity? subTab,
    NavigateBarEntity? navigateBar,
    List<CustomPageCategoriesEntity>? favourite,
    List<CustomPageSubCategoriesEntity>? favouriteSubCat,
    List<UpdateCustomPageCategoriesModel>? updateData,
    List<String>? updateCategoriesId,
    ActivateEntity? activate,
  }) {
    return CustomPageState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      social: social ?? this.social,
      subTab: subTab ?? this.subTab,
      navigateBar: navigateBar ?? this.navigateBar,
      favourite: favourite ?? this.favourite,
      favouriteSubCat: favouriteSubCat ?? this.favouriteSubCat,
      activate: activate ?? this.activate,
      updateData: updateData ?? this.updateData,
      updateSubCategoriesId: updateCategoriesId ?? updateSubCategoriesId, // ✅
    );
  }
}
