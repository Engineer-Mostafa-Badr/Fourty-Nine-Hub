import 'package:fourtyninehub/features/custom_page/domain/entity/activate_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/navigate_bar_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

import '../../../../../../core/error/failure.dart';
import '../../domain/entity/favourite_categ_entity.dart';
import '../../domain/entity/sub_tab_entity.dart';

enum CustomPageStates { loading, initial, error, success }

class CustomPageState {
  final CustomPageStates status;
  final Failure? failure;
  final SocialPageEntity? social;
  final SubTabEntity? subTab;
  final NavigateBarEntity? navigateBar;
  final FavouriteCatEntity? favourite;
  final ActivateEntity? activate;

  const CustomPageState(
      {this.status = CustomPageStates.loading,
      this.failure,
      this.social,
      this.subTab,
      this.navigateBar,
      this.favourite,
      this.activate,
      });
  CustomPageState copyWith(
      {CustomPageStates? status,
      Failure? failure,
      SocialPageEntity? social,
      SubTabEntity? subTab,
      NavigateBarEntity? navigateBar,
      FavouriteCatEntity? favourite,
        ActivateEntity? activate
      }) {
    return CustomPageState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      social: social ?? this.social,
      subTab: subTab ?? this.subTab,
      navigateBar: navigateBar ?? this.navigateBar,
      favourite: favourite ?? this.favourite,
      activate: activate ?? this.activate,
    );
  }
}
