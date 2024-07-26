import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';

import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/feeling_entity.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/get_activities_usecase.dart';
import '../../domain/usecases/get_feelings_usecase.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final CreatePostUseCase _createPostUseCase;
  final CreateTwitterPostUseCase _createTwitterPostUseCase;
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetFeelingsUseCase _getFeelingsUseCase;
  final postContentTextController = TextEditingController();
  CreatePostCubit(this._createPostUseCase, this._getActivitiesUseCase,
      this._getFeelingsUseCase, this._createTwitterPostUseCase)
      : super(const CreatePostState());

  void loadData() async {
    await getActivities();
    await getFeelings();
  }

  Future<void> getActivities() async {
    final response = await _getActivitiesUseCase(const NoParams());
    response.fold((l) => emit(state.copyWith(failure: l)),
        (data) => emit(state.copyWith(activities: data)));
  }

  Future<void> getFeelings() async {
    final response = await _getFeelingsUseCase(const NoParams());
    response.fold((l) => emit(state.copyWith(failure: l)),
        (data) => emit(state.copyWith(feelings: data)));
  }

  void createPost({required BuildContext context}) async {
    if (postContentTextController.text.isNotEmpty) {
      final response = await _createTwitterPostUseCase(
          CreateTwitterPostParams(content: postContentTextController.text));
      response.fold(
          (l) =>
              emit(state.copyWith(failure: l, status: CreatePostStates.error)),
          (r) {
        Navigator.pop(context);
      });
    }
  }

  void selectColor({required Color color}) {
    emit(state.copyWith(backColor: color));
  }

  void selectedFeeling({required FeelingEntity item}) {
    emit(state.copyWith(selectedFeeling: item));
  }

  void selectActivity({required ActivityEntity item}) {
    emit(state.copyWith(selectedActivity: item));
  }
}
