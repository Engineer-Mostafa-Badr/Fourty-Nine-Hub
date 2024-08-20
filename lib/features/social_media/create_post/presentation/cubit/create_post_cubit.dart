import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  final FriendsFollowersUseCase _friendsFollowersUseCase;
  final postContentTextController = TextEditingController();
  CreatePostCubit(this._createPostUseCase, this._getActivitiesUseCase,
      this._getFeelingsUseCase, this._createTwitterPostUseCase, this._friendsFollowersUseCase)
      : super(const CreatePostState());

  List<String>? selectedImages;

  void loadData() async {
    await getActivities();
    await getFeelings();
  }

  Future<void> getActivities() async {
    final response = await _getActivitiesUseCase(const NoParams());
    response.fold((l) => emit(state.copyWith(failure: l)), (data) {
      print(data.length);
      emit(state.copyWith(activities: data));
    });
  }

  Future<void> getFeelings() async {
    final response = await _getFeelingsUseCase(const NoParams());
    response.fold((l) => emit(state.copyWith(failure: l)), (data) {
      print("feel ${data.length}");
      emit(state.copyWith(feelings: data));
    });
  }

  void createPost({required BuildContext context, required String type}) async {
    if (postContentTextController.text.isNotEmpty) {
      // selectedImages=state.images?.map((e)=>e.mediaId).toList();
      print("test media ${selectedImages?.length}");
      if (type == 'twitter') {
        final response = await _createTwitterPostUseCase(
            CreateTwitterPostParams(
                content: postContentTextController.text,
                mediaIds: selectedImages ?? []));
        response.fold(
            (l) => emit(
                state.copyWith(failure: l, status: CreatePostStates.error)),
            (r) {
          Navigator.pop(context);
        });
      } else if (type == "facebook") {
        final response = await _createPostUseCase(
          PostParams(
            content: postContentTextController.text,
            mediaId: selectedImages ?? [],
            color: state.backColor,
            activity: state.selectedActivity?.id,
            feeling: state.selectedFeeling?.id,
            privacy: state.selectedPrivacy,
          ),
        );
        response.fold(
            (l) => emit(
                state.copyWith(failure: l, status: CreatePostStates.error)),
            (r) {
          Navigator.pop(context);
        });
      }
    }
  }

  void selectColor({required String color}) {
    emit(state.copyWith(backColor: color));
  }

  void selectedFeeling({required FeelingEntity item}) {
    emit(state.copyWith(selectedFeeling: item));
  }

  void selectPrivacy({required String privacy}) {
    emit(state.copyWith(selectedPrivacy: privacy));
    print(state.selectedPrivacy);
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
          selectedImages?.add(data.mediaId);
          final images = state.images ?? [];

          images.add(data);
          selectedImages = images.map((e) => e.mediaId).toList();
          print("selectedImages${selectedImages?.length}");
          print(images.length);
          emit(state.copyWith(
              images: images,
              backColor: '#FFFFFFFF',
              status: CreatePostStates.success));
        });
    print("length${state.images?.length}");
  }

  removePhoto(UploadFileEntity? image) {
    final images = state.images;
    images?.remove(image);
    emit(state.copyWith(images: images, status: CreatePostStates.success));
    // print(state.fileEntity?.mediaId);
  }

  loadUsers(String search) async {
    await getFriendsFollowers(1,search);
    usersPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFriendsFollowers(pageKey,search);
    });
  }

  int pageSize = 10;
  final PagingController<int, PostUserEntity> usersPagingController =
  PagingController(firstPageKey: 1);
  Future<void> getFriendsFollowers(int page,String search) async {
    // final user = context.read<UserCubit>().state.data;
    final response = await _friendsFollowersUseCase(
      FriendsFollowersParams(search: search, limit: pageSize, page: page));
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: CreatePostStates.error)),
            (data) {
          final isLastPage = data.length < pageSize;
          if (page == 1) {
            print("page == 1 $page");
            usersPagingController.itemList = [];
          }
          if (isLastPage) {
            print("isLastPage = $isLastPage");
            usersPagingController.appendLastPage(data);
          } else {
            print("isNotLastPage = $isLastPage");
            final nextPageKey = page + 1;
            usersPagingController.appendPage(data, nextPageKey);
          }
          emit(state.copyWith(users: data, status: CreatePostStates.success));
        });
  }

  selectUsers(String id){
    print(id);
    if(usersPagingController.itemList!.firstWhere((element) => element.id==id).isSelected==true){
      print(usersPagingController.itemList!.firstWhere((element) => element.id==id).isSelected);
      List<String> users=[];
      if(state.selectedUsers!=null){
        users.addAll(state.selectedUsers!);
      }
      users.remove(id);
      print(users.length);
      emit(state.copyWith(selectedUsers: users,status: CreatePostStates.success,),);
    }else{
      print(usersPagingController.itemList!.firstWhere((element) => element.id==id).isSelected);
      List<String> users=[];
      if(state.selectedUsers!=null){
        users.addAll(state.selectedUsers!);
      }
      users.add(id);
      print(users.length);
      emit(state.copyWith(selectedUsers: users,status: CreatePostStates.success,),);
    }
    print("usssss${state.selectedUsers?.length}");
    usersPagingController.itemList!.firstWhere((element) => element.id==id).isSelected=!usersPagingController.itemList!.firstWhere((element) => element.id==id).isSelected!;

  }

}
