part of 'view_all_pick_me_cubit.dart';

sealed class ViewAllPickMeState {}

final class ViewAllPickMeInitial extends ViewAllPickMeState {}

final class ViewAllPickMeLoading extends ViewAllPickMeState {}

final class ViewAllPickMeFailed extends ViewAllPickMeState {
  final String message;

  ViewAllPickMeFailed(this.message);
}

final class ViewAllPickMeSuccess extends ViewAllPickMeState {
  final List<PickMeCardEntity> pickMeCards;

  ViewAllPickMeSuccess(this.pickMeCards);
}
