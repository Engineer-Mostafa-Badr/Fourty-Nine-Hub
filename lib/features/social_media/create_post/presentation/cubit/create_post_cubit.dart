import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_live_event_categories_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_live_event_sub_categories_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_places_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_sub_activities_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/confirmation_sheet.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/Social_home.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
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
  final GetSubActivitiesUseCase _getSubActivitiesUseCase;
  final GetFeelingsUseCase _getFeelingsUseCase;
  final FriendsFollowersUseCase _friendsFollowersUseCase;
  final GetPlacesUseCase _getPlacesUseCase;
  final GetLifeEventCategoriesUseCase _getLifeEventCategoriesUseCase;
  final GetLifeEventSubCategoriesUseCase _getLifeEventSubCategoriesUseCase;
  final postContentTextController = TextEditingController();
  CreatePostCubit(
      this._createPostUseCase,
      this._getActivitiesUseCase,
      this._getFeelingsUseCase,
      this._createTwitterPostUseCase,
      this._friendsFollowersUseCase,
      this._getLifeEventCategoriesUseCase,
      this._getLifeEventSubCategoriesUseCase,
      this._getPlacesUseCase, this._getSubActivitiesUseCase)
      : super(CreatePostState());


  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String>? selectedImages;
  String? selectedAudio;
  setAddress(PlaceEntity address) {
    emit(state.copyWith(place: address,status: CreatePostStates.success));
  }

  removeAddress() {
    emit(state.copyWith(place: PlaceEntity(formattedAddress: '', name: '', lat: 0, lng: 0),status: CreatePostStates.success));
  }

  onRemoveAddress() {
    emit(state.copyWith(selectedLocation: '',status: CreatePostStates.success));
  }

  onSelectDate(DateTime date){
    emit(state.copyWith(pickedDate:date,status: CreatePostStates.success));
  }

  setLifeEvent(LifeEventEntity life){
    emit(state.copyWith(selectedLifeEvent: life,
    gifImage: '',
      backColor: '#FFFFFFFF',
      images: [],
    ));
  }

  onChangePublishTweetStatus(bool status){
    emit(state.copyWith(onTweet: status,status: CreatePostStates.success));
  }
  onChangePublishInstaStatus(bool status){
    emit(state.copyWith(onInsta: status,status: CreatePostStates.success));
  }
  // void addMusic(String musicPath) {
  //   emit(state.copyWith(music: musicPath));
  // }

  // void removeMusic() {
  //   emit(state.copyWith(music: null));
  // }
  //

  Future<dynamic> bottomSheet({
    required BuildContext context,
    required Widget child,
    required Color backgroundColor,
    bool enableDrag = true,
    bool isDismissible = true,
    BoxConstraints? constraints,
    double radius = 30,
    bool isScrollControlled = true,
    bool useRootNavigator = false,
  }) async {
    return await showModalBottomSheet(
      showDragHandle: false,
      context: context,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      constraints: constraints,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (_) => child,
    );
  }

  Future<void> onDiscardPost()async {
    titleController.clear();
    descriptionController.clear();
    postContentTextController.clear();
    emit(state.copyWith(
      selectedFeeling: FeelingEntity(id: '', name: '', nameEn: '', image: ''),
      selectedActivity: ActivityEntity(id: '', name: '', nameEn: '', image: '',mainId: ''),
      gifImage: '',
      backColor: '#FFFFFFFF',
      images: [],
      lifeEventImages: [],
      onTweet: false,
      onInsta: false,
      selectedUsers: [],
      selectedLifeEvent: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: ''),
      place: PlaceEntity(formattedAddress: '', name: '', lat: 0, lng: 0),
    ));
  }

  void handleBack(BuildContext context) {
    bottomSheet(
      context: context,
      child: ConfirmationSheet(
        title: "تأكيد التراجع",
        btnTitle: 'Confirm',
        description: "ستفقد بيانات الصفحة الحالية عند تأكيد التراجع",
        onSafeAsDraft: (){
          context.go(Routes.SOCIAL,
              extra: SocialParams(
                  userId: UserCubit.to.state.data?.id ?? '', index: 0));
        },
        onDiscardPost: () async{
          await onDiscardPost();
          context.go(Routes.SOCIAL,
              extra: SocialParams(
                  userId: UserCubit.to.state.data?.id ?? '', index: 0));
          // });
        },

      ),
      backgroundColor: Colors.white,
    );
  }

  bool handlePopAction(){
    if((state.images?.isNotEmpty??false)||(state.gifImage!=null&&(state.gifImage?.isNotEmpty??false))||(state.selectedLifeEvent!=null&&(state.selectedLifeEvent?.id.isNotEmpty??false))||postContentTextController.text.isNotEmpty||(state.backColor!='#FFFFFFFF'&&state.backColor!=null)||(state.selectedActivity!=null&&(state.selectedActivity?.id.isNotEmpty??false))||(state.place!=null&&(state.place?.name.isNotEmpty??false))||(state.selectedUsers!=null&&(state.selectedUsers?.isNotEmpty??false))){
      return false;
    }else{
      return true;
    }
  }
  onSelectGif(String gifPath) {
    emit(state.copyWith(
        gifImage: gifPath,
        selectedLifeEvent: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: '',mainCat: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: '')),
        backColor: '#FFFFFFFF',
        images: [],
        status: CreatePostStates.success));
  }

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

  showRemoveBalletColors(){
    emit(state.copyWith(showBallet: !state.showBallet));
  }

  void loadData() async {
    // await getActivities();
    // await getFeelings();
    // getLifeEventCategories();
    loadInitialActivities();
    loadInitialFeelings();

    // await Future.wait([
    //   loadInitialActivities(),
    //   loadInitialFeelings(),
    // ]);
  }
  bool loadFeelings = false;
  bool loadActivities = false;
  bool loadSubActivities = false;

  Future loadInitialActivities() async {
    loadActivities = true;
    activities.clear();
    activitiesPage = 1;
    hasMoreActivities = true;
    await getActivities();
    loadActivities = true;
  }

  Future loadInitialSubActivities(String id) async {
    loadSubActivities = true;
    subActivities.clear();
    subActivitiesPage = 1;
    hasMoreSubActivities = true;
    await getSubActivities(id);
    loadSubActivities = false;
    emit(state.copyWith(status: CreatePostStates.success));
  }
  Future loadInitialFeelings() async {
    loadFeelings = true;
    feelings.clear();
    activitiesPage = 1;
    hasMoreActivities = true;
    await getFeelings();
    loadFeelings = false;
  }
  int activitiesPage = 1;
  int subActivitiesPage = 1;
  int feelingsPage = 1;
  bool isLoadingMoreActivities = false;
  bool isLoadingMoreSubActivities = false;
  bool isLoadingMoreFeelings = false;
  bool hasMoreActivities = true;
  bool hasMoreSubActivities = true;
  bool hasMoreFeelings = true;
  List<ActivityEntity> activities = [];
  List<ActivityEntity> subActivities = [];
  List<FeelingEntity> feelings = [];
  List<LifeEventEntity> lifeEventCategories = [];
  List<LifeEventEntity> lifeEventSubCategories = [];

  onSelectActivity(ActivityEntity activity){
    emit(state.copyWith(selectedActivity: activity,status: CreatePostStates.success));
  }
  Future<void> getActivities() async {
    if (!hasMoreActivities || isLoadingMoreActivities) return;
    isLoadingMoreActivities = true;
    emit(state.copyWith(status: CreatePostStates.loading));
    final response = await _getActivitiesUseCase(PaginationParams(page: activitiesPage,limit: 20));
    response.fold((l) => emit(state.copyWith(failure: l)), (data) {
      activities.addAll(data);
      if (data.length < 20) {
        hasMoreActivities = false;
      } else {
        activitiesPage++;
      }

      isLoadingMoreActivities = false;
      print(data.length);
      emit(state.copyWith(activities: data));
    });
  }

  bool isLoadingMoreLifeEvent = false;
  bool hasMoreLifeEvent = false;
  Future<void> getLifeEventCategories() async {
    // if (!hasMoreLifeEvent || isLoadingMoreLifeEvent) return;
    isLoadingMoreLifeEvent = true;
    emit(state.copyWith(status: CreatePostStates.loading));
    final response = await _getLifeEventCategoriesUseCase(const NoParams());
    response.fold((l) => emit(state.copyWith(failure: l)), (data) {
      lifeEventCategories.clear();
      lifeEventCategories.addAll(data);
      // if (data.length < 20) {
      //   hasMoreLifeEvent = false;

      // } else {
      //   activitiesPage++;
      // }

      isLoadingMoreLifeEvent = false;
      print(data.length);
      emit(state.copyWith(status: CreatePostStates.success));
    });
  }

  bool isLoadingMoreLifeEventSubCat = false;
  bool hasMoreLifeEventSubCat = false;
  Future<void> getLifeEventSubCategories(String id) async {
    // if (!hasMoreLifeEvent || isLoadingMoreLifeEvent) return;
    isLoadingMoreLifeEventSubCat = true;
    emit(state.copyWith(status: CreatePostStates.loading));
    final response = await _getLifeEventSubCategoriesUseCase(id);
    response.fold((l) => emit(state.copyWith(failure: l)), (data) {
      lifeEventSubCategories.clear();
      lifeEventSubCategories.addAll(data);
      // if (data.length < 20) {
      //   hasMoreLifeEvent = false;

      // } else {
      //   activitiesPage++;
      // }

      isLoadingMoreLifeEventSubCat = false;
      print(data.length);
      emit(state.copyWith(status: CreatePostStates.success));
    });
  }

  Future<void> getSubActivities(String id) async {
    if (!hasMoreSubActivities || isLoadingMoreSubActivities) return;
    isLoadingMoreSubActivities = true;
    emit(state.copyWith(status: CreatePostStates.loading));
    final response = await _getSubActivitiesUseCase(GetSubActivitiesParams(page: activitiesPage,limit: 20, id: id));
    response.fold((l) => emit(state.copyWith(failure: l)), (data) {
      subActivities.addAll(data);
      if (data.length < 20) {
        hasMoreSubActivities = false;
      } else {
        subActivitiesPage++;
      }

      isLoadingMoreSubActivities = false;
      print(data.length);
      emit(state.copyWith(subActivities: data));
    });
  }

  Future<void> getFeelings() async {
    if (!hasMoreFeelings || isLoadingMoreFeelings) return;
    isLoadingMoreFeelings = true;
    emit(state.copyWith(status: CreatePostStates.loading));

    final response = await _getFeelingsUseCase(PaginationParams(page: feelingsPage,limit: 20));
    response.fold((l) => emit(state.copyWith(failure: l)), (data) {
      feelings.addAll(data);
      print("objectFeelings ${feelings.length}");
      if (data.length < 20) {
        hasMoreFeelings = false;
      } else {
        feelingsPage++;
      }

      isLoadingMoreFeelings = false;
      print("feel ${data.length}");
      emit(state.copyWith(feelings: data));
    });
  }

  Future loadInitialUsers(String Search) async {
    usersList.clear();
    usersPage = 1;
    hasMoreUsers = true;
    emit(state.copyWith(status: CreatePostStates.loading));
    await fetchFriendsFollowers(Search);
  }
  int usersPage = 1;
  bool isLoadingMoreUsers = false;
  bool hasMoreUsers = true;
  List<PostUserEntity> selectedUserList=[];
  TextEditingController searchController = TextEditingController();
  fetchFriendsFollowers(String Search) async {
    print(hasMoreUsers);
    print(isLoadingMoreUsers);
    if (!hasMoreUsers || isLoadingMoreUsers) return;
    isLoadingMoreUsers = true;
    emit(state.copyWith(status: CreatePostStates.loading));


    final response = await _friendsFollowersUseCase(
        FriendsFollowersParams(search: searchController.text, limit: 25, page: usersPage));
    response.fold(
          (l) => emit(state.copyWith(failure: l, status: CreatePostStates.error)),
          (data) {
            selectedUserList.addAll(state.selectedUsers??[]);
            usersList.addAll(data);
            for (var user in usersList) {
              user.isSelected = selectedUserList.any((selectedUser) => selectedUser.id == user.id);
            }
            print("objectFeelings ${feelings.length}");
            if (data.length < 20) {
              hasMoreUsers = false;
            } else {
              usersPage++;
            }
            isLoadingMoreUsers = false;
        emit(state.copyWith(status: CreatePostStates.success));
      },
    );
  }


  void createPost({required BuildContext context,}) async {
    emit(state.copyWith(status: CreatePostStates.loadingCreatePost));

    if (postContentTextController.text.isNotEmpty ||
        selectedImages != null ||
        selectedImages!.isNotEmpty) {
      List<UploadFileEntity> images = [];
      images=state.images??[];
      print(state.selectedLifeEvent);
      print(state.selectedLifeEvent?.id);
        final response = await _createPostUseCase(
          PostParams(
            type:(state.selectedLifeEvent!=null&&(state.selectedLifeEvent?.id.isNotEmpty??false))?"live_event_post":(state.gifImage != null&&(state.gifImage?.isNotEmpty??false)) ? "gif_post":"normal_post",
            content: postContentTextController.text,
            mediaId: images.map((e)=>e.mediaId).toList(),
            color: state.backColor,
            gifUrl: state.gifImage,
            activity: state.selectedActivity,
            feeling: state.selectedFeeling?.id,
            place: state.place,
            onInsta: state.onInsta??false,
            onTweet: state.onTweet??false,
            privacy: state.selectedPrivacy,
            lifeEvent:state.selectedLifeEvent,
            users: state.selectedUsers?.map((e) => e.id).toList() ?? [],
          ),
        );
        response.fold(
            (l) => emit(
                state.copyWith(failure: l, status: CreatePostStates.error)),
            (r) async {
              emit(state.copyWith(status: CreatePostStates.success));
              onDiscardPost();
              context.go(Routes.SOCIAL,
                  extra: SocialParams(
                      userId: UserCubit.to.state.data?.id ?? '', index: 0));
            });
      // }
    }
  }

  void selectColor({required String color}) {
    emit(state.copyWith(backColor: color));
  }

  void selectedFeeling({required FeelingEntity item}) {
    emit(state.copyWith(selectedFeeling: item,
    selectedActivity: ActivityEntity(id: '', name: '', nameEn: '', image: '',mainId: ''),
    ));
  }

  void selectPrivacy({required String privacy}) {
    emit(state.copyWith(selectedPrivacy: privacy));
    print(state.selectedPrivacy);
  }

  void selectActivity({required ActivityEntity item}) {
    emit(state.copyWith(selectedActivity: item,selectedFeeling: FeelingEntity(id: '', name: '', nameEn: '', image: '')));
  }

  uploadPhoto({bool isGallery = true,required BuildContext context,bool? hasLoading}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadImage(
        isGallery: isGallery,
        // hasLoading: hasLoading,
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
              selectedLifeEvent: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: '',mainCat: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: '')),
              gifImage: '',
              status: CreatePostStates.success));
        }, context: context);
    print("length${state.images?.length}");
  }

  onRemoveLifeEventImages(int index) {
    final images = state.lifeEventImages ?? [];
    images.removeAt(index);
    emit(state.copyWith(
        lifeEventImages: images,
        pageIndex:index,
        status: CreatePostStates.success
    ));
  }

  removeLifeEvent(){
    print("objectobjectobject");
    emit(state.copyWith(
      selectedLifeEvent: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: '',desc: '',title: '',mainCat: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: '',desc: '',title: '')),
    ));
  }
  removeGif(){
    print("objectobjectobject");
    emit(state.copyWith(gifImage: ''
    ));
  }

  onChangePage(int index) {
    descriptionController.clear();
    titleController.clear();
    emit(state.copyWith(
        pageIndex:index,
        lifeEventImages: [],
        selectedLifeEvent: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: '',mainCat: LifeEventEntity(id: '', titleAr: '', titleEn: '', image: '', media: [], liveEventMainCategoryId: '')),
        status: CreatePostStates.success
    ));
  }

  uploadLifeEventPhoto({bool isGallery = true,required BuildContext context,bool? hasLoading}) async {
    final UploadFile upload = UploadFile();
    print("objectssssssssss");
    await upload.uploadImage(
        isGallery: isGallery,
        // hasLoading: hasLoading,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("file name ${data.file}");
          print("mediaId: ${data.mediaId}");
          selectedImages?.add(data.mediaId);
          final images = state.lifeEventImages ?? [];

          images.add(data);
          selectedImages = images.map((e) => e.mediaId).toList();
          print("selectedImages${selectedImages?.length}");
          print(images.length);
          emit(state.copyWith(
              lifeEventImages: images,
              backColor: '#FFFFFFFF',
              status: CreatePostStates.success));
        }, context: context);
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

  // loadUsers(String search) async {
  //   await getFriendsFollowers(1, search);
  //   usersPagingController.addPageRequestListener((pageKey) {
  //     print("initStatePageKey : $pageKey");
  //     getFriendsFollowers(pageKey, search);
  //   });
  // }
  //
  // loadPlaces(String search) async {
  //   await getPlaces(1, search);
  //   usersPagingController.addPageRequestListener((pageKey) {
  //     print("initStatePageKey : $pageKey");
  //     getPlaces(pageKey, search);
  //   });
  // }

  // int pageSize = 4;
  // final PagingController<int, PostUserEntity> usersPagingController =
  //     PagingController(firstPageKey: 1);

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
  // getFriendsFollowers(int page, String search) async {
  //   print("paaaaaaaaaaaaaage$page");
  //   if (page == 1) {
  //     usersPagingController.itemList = [];
  //   }
  //   final response = await _friendsFollowersUseCase(
  //       FriendsFollowersParams(search: search, limit: pageSize, page: page));
  //   response.fold(
  //     (l) => emit(state.copyWith(failure: l, status: CreatePostStates.error)),
  //     (data) {
  //       final isLastPage = data.length < pageSize;
  //       List<PostUserEntity> fetchUsers = [];
  //       if (state.selectedUsers != null && state.selectedUsers!.isNotEmpty) {
  //         fetchUsers.clear();
  //         print("ssssssssssssssssssssssssssssssssssssssssssss");
  //         fetchUsers = data.map((item) {
  //           var isSelected =
  //               state.selectedUsers!.any((selected) => item.id == selected.id);
  //
  //           if (isSelected) {
  //             item.isSelected = true;
  //           }
  //
  //           return item;
  //         }).toList();
  //       } else {
  //         fetchUsers.clear();
  //         fetchUsers = data;
  //       }
  //       if (isLastPage) {
  //         usersPagingController.appendLastPage(fetchUsers);
  //       } else {
  //         final nextPageKey = page + 1;
  //         usersPagingController.appendPage(fetchUsers, nextPageKey);
  //       }
  //       emit(state.copyWith(status: CreatePostStates.success));
  //     },
  //   );
  // }

  // final PagingController<int, PlaceEntity> placesPagingController =
  //     PagingController(firstPageKey: 1);
  // Future<void> getPlaces(int page, String search) async {
  //   // emit(state.copyWith(status: St))
  //   // final user = context.read<UserCubit>().state.data;
  //   final response = await _getPlacesUseCase(
  //       FriendsFollowersParams(search: search, limit: pageSize, page: page));
  //   response.fold(
  //       (l) => emit(state.copyWith(failure: l, status: CreatePostStates.error)),
  //       (data) {
  //     final isLastPage = data.length < pageSize;
  //     if (page == 1) {
  //       print("page == 1 $page");
  //       placesPagingController.itemList = [];
  //     }
  //     if (isLastPage) {
  //       print("isLastPage = $isLastPage");
  //       // List<PlaceEntity> fetchUsers=[];
  //       placesPagingController.appendLastPage(data);
  //     } else {
  //       print("isNotLastPage = $isLastPage");
  //       final nextPageKey = page + 1;
  //       placesPagingController.appendPage(data, nextPageKey);
  //     }
  //     emit(state.copyWith(status: CreatePostStates.success));
  //   });
  // }

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
        selectedFeeling: FeelingEntity(name: '', image: '', id: '', nameEn: ''),
        status: CreatePostStates.success));
  }

  onRemoveActivity() {
    emit(state.copyWith(
        selectedActivity: ActivityEntity(name: '', nameEn:'',image: '', id: ''),
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
