import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_places_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../common/models/public/pagination_params.dart';
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
  final GetPlacesUseCase _getPlacesUseCase;
  final postContentTextController = TextEditingController();
  CreatePostCubit(
      this._createPostUseCase,
      this._getActivitiesUseCase,
      this._getFeelingsUseCase,
      this._createTwitterPostUseCase,
      this._friendsFollowersUseCase,
      this._getPlacesUseCase)
      : super(CreatePostState());

  List<String>? selectedImages;
  String? selectedAudio;

  // void addMusic(String musicPath) {
  //   emit(state.copyWith(music: musicPath));
  // }

  // void removeMusic() {
  //   emit(state.copyWith(music: null));
  // }

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> addMusic(String musicPath) async {
    // Update the state with the selected music path
    emit(state.copyWith(music: musicPath));

    try {
      // Set the audio source using a file path
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(musicPath)));
      await _audioPlayer.play();
    } catch (e) {
      // Handle exceptions, such as invalid file paths or unsupported formats
      print("Error playing music: $e");
    }
  }

  Future<void> removeMusic() async {
    try {
      await _audioPlayer.stop();
      emit(state.copyWith(music: null)); // Clear the music from state
    } catch (e) {
      print("Error stopping music: $e");
    }
  }

  Future<void> playMusic() async {
    try {
      if (state.music != null) {
        await _audioPlayer.play();
      }
    } catch (e) {
      print("Error resuming music: $e");
    }
  }

  Future<void> pauseMusic() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print("Error pausing music: $e");
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose(); // Dispose the player when no longer needed
    return super.close();
  }


// final scrollController = ScrollController();
  //
  // void initScroll(){
  //   scrollController.addListener(() {
  //     if (scrollController.position.maxScrollExtent ==
  //         scrollController.offset &&
  //         !state.isLast) {
  //       getFriendsFollowers('');
  //     }
  //   });
  // }

  removeBackground() {
    // emit(state.copyWith(backColor:'#FFFFFFFF',));
  }

  onBigger80() {
    emit(state.copyWith(
        isBiggerThan80: true, isBiggerThen120: false, isBiggerThen150: false));
  }

  onBigger120() {
    emit(state.copyWith(
        isBiggerThan80: false, isBiggerThen120: true, isBiggerThen150: false));
  }

  onBigger150() {
    emit(state.copyWith(
        isBiggerThan80: false, isBiggerThen120: false, isBiggerThen150: true));
  }

  onSmallerText() {
    emit(state.copyWith(
        isBiggerThan80: false, isBiggerThen120: false, isBiggerThen150: false));
  }

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
    if (postContentTextController.text.isNotEmpty ||
        selectedImages != null ||
        selectedImages!.isNotEmpty) {
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
            place: state.place,
            privacy: state.selectedPrivacy,
            users: state.selectedUsers?.map((e) => e.id).toList() ?? [],
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

  uploadPhoto({bool isGallery = true}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadImage(
        isGallery: isGallery,
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

  uploadAudio({bool isGallery = true}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadAudio(
        isGallery: isGallery,
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
    await getFriendsFollowers(1, search);
    usersPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFriendsFollowers(pageKey, search);
    });
  }

  loadPlaces(String search) async {
    await getPlaces(1, search);
    usersPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPlaces(pageKey, search);
    });
  }

  // int pageSize = 4;
  final PagingController<int, PostUserEntity> usersPagingController =
      PagingController(firstPageKey: 1);

  PaginationParams paginationParams = PaginationParams.basic();
  List<PostUserEntity> usersList = [];

  resetPagination() {
    paginationParams.page = 1;
    usersList = [];
    emit(state.copyWith(users: [], isLast: false));
    print("lennnnnnnnnnnng${state.users?.length}");
  }

  // Future<void> getFriendsFollowers(String search) async {
  //   if(paginationParams.page==1){
  //     resetPagination();
  //   }
  //   final response = await _friendsFollowersUseCase(
  //       FriendsFollowersParams(search: search, limit: paginationParams.limit, page: paginationParams.page));
  //   response.fold(
  //           (failure) => emit(state.copyWith(
  //           failure: failure, status: CreatePostStates.error)),
  //           (r) {
  //             paginationParams.page++;
  //             usersList.addAll(r);
  //             emit(state.copyWith(users:usersList,isLast: (r.isEmpty || r.length < paginationParams.limit)));
  //           });
  // }

  int pageSize = 100;
  getFriendsFollowers(int page, String search) async {
    print("paaaaaaaaaaaaaage$page");
    if (page == 1) {
      usersPagingController.itemList = [];
    }
    final response = await _friendsFollowersUseCase(
        FriendsFollowersParams(search: search, limit: pageSize, page: page));
    response.fold(
      (l) => emit(state.copyWith(failure: l, status: CreatePostStates.error)),
      (data) {
        final isLastPage = data.length < pageSize;
        List<PostUserEntity> fetchUsers = [];
        if (state.selectedUsers != null && state.selectedUsers!.isNotEmpty) {
          fetchUsers.clear();
          print("ssssssssssssssssssssssssssssssssssssssssssss");
          fetchUsers = data.map((item) {
            var isSelected =
                state.selectedUsers!.any((selected) => item.id == selected.id);

            if (isSelected) {
              item.isSelected = true;
            }

            return item;
          }).toList();
        } else {
          fetchUsers.clear();
          fetchUsers = data;
        }
        if (isLastPage) {
          usersPagingController.appendLastPage(fetchUsers);
        } else {
          final nextPageKey = page + 1;
          usersPagingController.appendPage(fetchUsers, nextPageKey);
        }
        emit(state.copyWith(status: CreatePostStates.success));
      },
    );
  }

  final PagingController<int, PlaceEntity> placesPagingController =
      PagingController(firstPageKey: 1);
  Future<void> getPlaces(int page, String search) async {
    // emit(state.copyWith(status: St))
    // final user = context.read<UserCubit>().state.data;
    final response = await _getPlacesUseCase(
        FriendsFollowersParams(search: search, limit: pageSize, page: page));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: CreatePostStates.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        placesPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        // List<PlaceEntity> fetchUsers=[];
        placesPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        placesPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(status: CreatePostStates.success));
    });
  }

  onSelectPlace(PlaceEntity place) {
    emit(state.copyWith(place: place, status: CreatePostStates.success));
    print(state.place?.name);
  }

  onRemovePlace() {
    emit(state.copyWith(
        place: PlaceEntity(formattedAddress: '', name: '', lat: 0.0, lng: 0.0),
        status: CreatePostStates.success));
  }

  onRemoveFeeling() {
    emit(state.copyWith(
        selectedFeeling: FeelingEntity(name: '', image: '', id: ''),
        status: CreatePostStates.success));
  }

  onRemoveActivity() {
    emit(state.copyWith(
        selectedActivity: ActivityEntity(name: '', image: '', id: ''),
        status: CreatePostStates.success));
  }

  onRemoveUser(PostUserEntity user) {
    List<PostUserEntity> newUsers = [];
    if (state.selectedUsers != null && state.selectedUsers!.isNotEmpty) {
      newUsers.addAll(state.selectedUsers!);
      newUsers.removeWhere((e) => e.id == user.id);
    }
    emit(state.copyWith(
        selectedUsers: newUsers, status: CreatePostStates.success));
  }

  selectUsers(PostUserEntity user) {
    print(user.isSelected);
    List<PostUserEntity> users = [];
    if (state.selectedUsers != null) {
      users.addAll(state.selectedUsers!);
    }
    if (user.isSelected == false) {
      users.add(user);
    } else {
      users.removeWhere((e) => e.id == user.id);
    }
    print(users.length);
    emit(
      state.copyWith(
        selectedUsers: users,
        status: CreatePostStates.success,
      ),
    );
  }

  void clearSelectedImages() {
    selectedImages = [];
    emit(state.copyWith(images: [])); // Emit updated state to notify listeners
  }


}
