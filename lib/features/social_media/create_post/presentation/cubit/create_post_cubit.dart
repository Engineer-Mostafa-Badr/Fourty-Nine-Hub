import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
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

  UploadFileEntity? fileEntity;

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

  void createPost({required BuildContext context, required String type}) async {
    if (postContentTextController.text.isNotEmpty) {
      print("test media ${fileEntity?.mediaId}");
      if (type == 'twitter') {
        final response = await _createTwitterPostUseCase(
            CreateTwitterPostParams(
                content: postContentTextController.text,
                mediaIds:
                    fileEntity == null ? [] : [fileEntity?.mediaId ?? '']));
        response.fold(
            (l) => emit(
                state.copyWith(failure: l, status: CreatePostStates.error)),
            (r) {
          Navigator.pop(context);
        });
      } else if (type == "facebook") {
        final response = await _createPostUseCase(
            PostParams(content: postContentTextController.text));
        response.fold(
            (l) => emit(
                state.copyWith(failure: l, status: CreatePostStates.error)),
            (r) {
          Navigator.pop(context);
        });
      }
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

  uploadPhoto() {
    final UploadFile upload = UploadFile();
    upload.uploadImage(
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("file name ${data.file}");
          print("mediaId: ${data.mediaId}");
          fileEntity = data;
          print(fileEntity?.mediaId);
          emit(state.copyWith(
              fileEntity: data, status: CreatePostStates.success));
        });
  }

  removePhoto() {
    emit(state.copyWith(fileEntity: null, status: CreatePostStates.success));
  }
}
