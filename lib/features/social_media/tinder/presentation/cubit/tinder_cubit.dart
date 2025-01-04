import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/add_favourite_category_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/chech_user_nearby_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/delete_tinder_picture_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_favourites_category_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_favourites_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_gifts_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_last_seen_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/fetch_subcategory_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_tinder_profile_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_user_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/send_geft_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/upload_tinder_picture_use_case.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import '../../data/models/near_by_model.dart';
import 'tinder_state.dart';

class TinderViewCubit extends Cubit<TinderViewState> {
  final GetMainCategoryDetailsUseCase getMainCategoryDetailsUseCase;
  final GetTinderFavouritesCategoryUseCase _getTinderFavouritesCategoryUseCase;
  final GetUserDataUseCase _getUserDataUseCase;
  final GetTinderFavouritesUseCase _getTinderFavouritesUseCase;
  final GetTinderProfileUseCase _getTinderProfileUseCase;
  final AddTinderFavouriteCategoryUseCase _addTinderFavouriteCategoryUseCase;
  final FetchLastSeenUseCase _fetchLastSeenUseCase;
  final SendGiftUseCase _sendGiftUseCase;
  final FetchGiftsUseCase _fetchGiftsUseCase;
  final CheckUserNearbyUseCase _checkUserNearbyUseCase;
  final FetchSubCategoryDataUseCase _fetchSubCategoryDataUseCase;
  final UploadTinderPictureUseCase _uploadTinderPictureUseCase;
  final ToggleSubCategoryToFavoritesUseCase
      _toggleSubCategoryToFavoritesUseCase;
  final DeleteTinderPictureUseCase _deleteTinderPictureUseCase;

  TinderViewCubit(
      this._getUserDataUseCase,
      this._getTinderProfileUseCase,
      this._getTinderFavouritesUseCase,
      this._getTinderFavouritesCategoryUseCase,
      this.getMainCategoryDetailsUseCase,
      this._addTinderFavouriteCategoryUseCase,
      this._fetchLastSeenUseCase,
      this._sendGiftUseCase,
      this._fetchGiftsUseCase,
      this._checkUserNearbyUseCase,
      this._fetchSubCategoryDataUseCase,
      this._uploadTinderPictureUseCase,
      this._toggleSubCategoryToFavoritesUseCase,
      this._deleteTinderPictureUseCase)
      : super(TinderViewState());

  // Future<void> fetchUserData() async{
  //   if (!isClosed){
  //     emit(state.copyWith(userDataState: TinderStates.initial));
  //     var response = await _getUserDataUseCase.call(GetUsersParams(gender: gender, page: page, limit: 20,));
  //   }
  // }
  Future<void> fetchUserData(String gender) async {
    final response = await _getUserDataUseCase(
      GetUsersParams(gender: gender, page: 1, limit: 20),
    );
    if (isClosed) return;
    response.fold(
      (failure) {
        print('Failure : $failure');
        if (!isClosed) {
          emit(state.copyWith(failure: failure, status: TinderStates.failure));
        }
      },
      (data) {
        if (!isClosed) {
          emit(state.copyWith(userData0: data, status: TinderStates.success));
        }
        print('object_________________________________');
        print('data $data');
      },
    );
  }

  Future<void> fetchMainCategoryById(BuildContext context, String id) async {
    if (!isClosed) {
      emit(state.copyWith(
          mainCategoryResponseState: TinderStates.loading,
          status: TinderStates.loading));
      final mainCategoryResponse = await getMainCategoryDetailsUseCase(id);

      mainCategoryResponse.fold((l) {
        log('there is a failure ${getFailureMessage(l, context)}');

        emit(state.copyWith(
          mainCategoryResponseState: TinderStates.failure,
          status: TinderStates.failure,
        ));
      }, (r) {
        emit(state.copyWith(
            mainCategoryEntity: r, status: TinderStates.success));
        // emit(state.copyWith(
        //   mainCategoryResponseState: TinderStates.success,
        //   mainCategoryEntity: r,
        //   status: TinderStates.success,
        // ));
      });
    }

    // if (mainCategoryResponse != null) {
    //   print(mainCategoryResponse.data.mainCategory.nameEn);
    //
    //   emit(state.copyWith(
    //       mainCategoryResponseState: DataState.success,
    //       mainCategoryResponse: mainCategoryResponse));
    //   // log('main categoty response ${mainCategoryResponse.data.mainCategory.nameEn}');
    // } else {
    //   emit(state.copyWith(mainCategoryResponseState: DataState.failure));
    // }
  }

  // Future<bool> startNormalChat({
  //   required String receiverId,
  //   required String subCategoryId,
  // }) async {
  //   emit(state.copyWith(normalChatResponseState: TinderStates.initial));
  //   final normalChatModel =
  //       await tinderRepository.startNormalChat(receiverId, subCategoryId);
  //   if (normalChatModel != null) {
  //     emit(state.copyWith(
  //         normalChatResponse: normalChatModel,
  //         normalChatResponseState: TinderStates.success));
  //     return true;
  //   } else {
  //     emit(state.copyWith(normalChatResponseState: TinderStates.failure));
  //     return false;
  //   }
  // }
  //
  // Future<bool> startAnonymousChat({
  //   required String receiverId,
  // }) async {
  //   emit(state.copyWith(anonymousChatResponseState: TinderStates.initial));
  //   final anonymousChatModel =
  //       await tinderRepository.startAnonymousChat(receiverId);
  //   if (anonymousChatModel != null) {
  //     emit(state.copyWith(
  //         anonymousChatResponse: anonymousChatModel,
  //         anonymousChatResponseState: TinderStates.success));
  //     return true;
  //   } else {
  //     emit(state.copyWith(anonymousChatResponseState: TinderStates.failure));
  //     return false;
  //   }
  // }

  Future<void> fetchUserProfile({required String userId}) async {
    emit(state.copyWith(profileUserState: TinderStates.initial));
    final response = await _getTinderProfileUseCase(userId);
    // log('main categoty response ${response?.data.mainCategory.nameEn}');

    response.fold((l) {
      emit(state.copyWith(profileUserState: TinderStates.failure));
    }, (r) {
      emit(state.copyWith(
          status: TinderStates.success, profileUserData: r.data));
    });
  }

  Future<void> fetchFavorites() async {
    if (!isClosed) {
      emit(state.copyWith(getFavCategoryListState: TinderStates.initial));
      final response = await _getTinderFavouritesUseCase(const NoParams());
      response.fold((l) {
        emit(state.copyWith(getFavCategoryListState: TinderStates.failure));
      }, (r) {
        emit(state.copyWith(
            getFavCategoryListState: TinderStates.success,
            getFavCategoryList: r));
      });
    }

    Future<void> fetchFavoritesCategory() async {
      emit(state.copyWith(getFavCategoryListState: TinderStates.initial));
      final response =
          await _getTinderFavouritesCategoryUseCase(const NoParams());
      response.fold((l) {
        emit(state.copyWith(getFavCategoryListState: TinderStates.failure));
      }, (r) {
        emit(state.copyWith(
            getFavCategoryListState: TinderStates.success,
            FavoriteCategoryList: r));
      });
    }
    // emit(state.copyWith(getFavCategoryListState: TinderStates.initial));
    // final apiResponse = await tinderRepository.fetchFavoritesCategory();
    // if (apiResponse != null) {
    //   emit(state.copyWith(
    //       getFavCategoryListState: TinderStates.success,
    //       FavoriteCategoryList: apiResponse));
    // } else {
    //   emit(state.copyWith(getFavCategoryListState: TinderStates.failure));
    // }
  }

  Future<void> addFavoriteCategory({required String categoryId}) async {
    if (!isClosed) {
      emit(state.copyWith(addCategoryModelState: TinderStates.initial));
      final response = await _addTinderFavouriteCategoryUseCase(categoryId);
      response.fold((l) {
        emit(state.copyWith(getFavCategoryListState: TinderStates.failure));
      }, (r) {
        emit(state.copyWith(addCategoryModelState: TinderStates.success));
      });
    }
    // final isSuccess = await tinderRepository.addFavoriteCategory(categoryId!);
    // if (isSuccess) {
    //   emit(state.copyWith(addCategoryModelState: TinderStates.success));
    // } else {
    //   emit(state.copyWith(addCategoryModelState: TinderStates.failure));
    // }
  }

  Future<bool> fetchLastSeen({
    required String userId,
  }) async {
    bool result = false;
    emit(state.copyWith(
      lastSeenModelState: TinderStates.initial,
    ));
    final response = await _fetchLastSeenUseCase(userId);
    response.fold((l) {
      emit(state.copyWith(lastSeenModelState: TinderStates.failure));
    }, (r) {
      result = true;
      emit(state.copyWith(
          lastSeenModel: r, lastSeenModelState: TinderStates.success));
    });

    // emit(state.copyWith(
    //   lastSeenModelState: TinderStates.initial,
    // ));
    //
    // final lastSeenModel = await tinderRepository.fetchLastSeen(userId);
    // if (lastSeenModel != null) {
    //   emit(state.copyWith(
    //       lastSeenModel: lastSeenModel,
    //       lastSeenModelState: TinderStates.success));
    //   return true;
    //   // print(lastSeenModel.data!.status.toString() +
    //   //     "sssssssssssssssssssssssssssssssss");
    // } else {
    //   print("sssssssssssssssssssssssssssssssss");
    //   emit(state.copyWith(lastSeenModelState: TinderStates.failure));
    //   return result;
    // }
    return result;
  }

  Future<dynamic> sendGift({
    required String receiverId,
    required String giftId,
    required String subCategoryId,
    required BuildContext context,
  }) async {
    emit(state.copyWith(
      sendGiftErrorDataState: TinderStates.initial,
    ));
    final response = await _sendGiftUseCase(SendGiftParams(
      giftId: giftId,
      receiverId: receiverId,
    ));
    response.fold((l) {
      emit(state.copyWith(sendGiftErrorDataState: TinderStates.success));
    }, (r) {
      log("send gift response $r");
      context.pop();
      showSuccessMessage(context, context.isArabic?'تم ارسال الهدية بنجاح':'Gift sent successfully');
      emit(state.copyWith(sendGiftErrorDataState: TinderStates.success));
    });
    // emit(state.copyWith(sendGiftErrorDataState: TinderStates.initial));
    // if (response != null) {
    //   log("$response--------------------------------------");
    //   emit(state.copyWith(sendGiftErrorDataState: TinderStates.success));
    //   return response;
    // } else {
    //   emit(state.copyWith(sendGiftErrorDataState: TinderStates.failure));
    // }
    // return '';
  }

  Future<void> fetchGifts() async {
    emit(state.copyWith(
      giftsState: TinderStates.initial,
    ));
    final response = await _fetchGiftsUseCase(const NoParams());
    response.fold((l) {
      emit(state.copyWith(giftsState: TinderStates.success));
    }, (r) {
      emit(state.copyWith(
          gifts: r.data?.gifts, giftsState: TinderStates.success));
    });
    // emit(state.copyWith(giftsState: TinderStates.initial));
    // final giftData = await tinderRepository.fetchGifts();
    // log("${giftData}dsssssssssssssssssaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    // if (giftData != null) {
    //   emit(state.copyWith(gifts: giftData, giftsState: TinderStates.success));
    // } else {
    //   emit(state.copyWith(giftsState: TinderStates.failure));
    // }
  }

  Future<void> checkUserNearby({
    required String cardUserId,
  }) async {
    emit(state.copyWith(isUserNearbyState: TinderStates.initial));

    final response = await _checkUserNearbyUseCase(cardUserId);
    response.fold((l) {
      emit(state.copyWith(
          isUserNearbyState: TinderStates.failure,
          isUserNearby: NearByModel()));
    }, (r) {
      emit(state.copyWith(
          isUserNearby: r, isUserNearbyState: TinderStates.success));
    });
    // final nearByModel = await tinderRepository.checkUserNearby(cardUserId);
    // if (nearByModel != null) {
    //   emit(state.copyWith(
    //       isUserNearby: nearByModel, isUserNearbyState: TinderStates.success));
    // } else {
    //   emit(state.copyWith(
    //       isUserNearbyState: TinderStates.failure,
    //       isUserNearby: NearByModel()));
    // }
  }

  Future<void> fetchSubCategoryData() async {
    if (!isClosed) {
      emit(state.copyWith(subCategoryDataState: TinderStates.loading));

      final response = await _fetchSubCategoryDataUseCase(const NoParams());
      response.fold((l) {
        emit(state.copyWith(subCategoryDataState: TinderStates.failure));
      }, (r) {
        emit(state.copyWith(subCategoryData: r, status: TinderStates.success));
      });
    }

    // emit(state.copyWith(subCategoryDataState: TinderStates.initial));
    // final subCategoryData = await tinderRepository.fetchSubCategoryData();
    // if (subCategoryData != null) {
    //   // fetchMainCategoryById('62c8b5b09332225799fe335e');
    //   emit(state.copyWith(
    //       subCategoryData: subCategoryData,
    //       subCategoryDataState: TinderStates.success));
    // } else {
    //   emit(state.copyWith(subCategoryDataState: TinderStates.failure));
    // }
  }

  // Future<void> fetchUserData({
  //   required String gender,
  // }) async {
  //   emit(state.copyWith(userDataState: DataState.initial, userData: []));
  //   final userData = await tinderRepository.fetchUserData(gender);
  //   if (userData != null) {
  //     log(userData.first.email.toString() +
  //         '000000000000000000000000000000000000000');
  //     emit(
  //         state.copyWith(userData: userData, userDataState: DataState.success));
  //   } else {
  //     emit(state.copyWith(userDataState: DataState.failure, userData: []));
  //   }
  // }

  uploadPhoto({bool isGallery = true}) async {
    final UploadFile upload = UploadFile();
    print('=======>data Hiii');
    UploadFileEntity? image;
    await upload.uploadImage(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) async {
          image = data;
          final response = await serviceLocator<ApiConsumer>().put(
            '/users/profile-picture',
            data: {'profilePictureId': data.mediaId},
          );
          return response.fold(
            (failure) {
              print('=======>data Fal}');

              return Left(failure);
            },
            (data) {
              emit(state.copyWith(newImage: image));
              UserCubit.to.getUser();
              uploadPictures(
                  pictures: AddImagesParams(media: [state.newImage!.mediaId]));
              print("newImage====>${state.newImage?.mediaId}");
              return const Right(true);
            },
          );
        });
  }

  Future<void> uploadPictures({
    required AddImagesParams pictures,
  }) async {
    final response = await _uploadTinderPictureUseCase(pictures);
    if (isClosed) return;
    response.fold(
      (failure) {
        print('Failure : $failure');
        if (!isClosed) {
          emit(state.copyWith(failure: failure, status: TinderStates.failure));
        }
      },
      (data) {
        if (!isClosed) {
          emit(state.copyWith(status: TinderStates.success));
        }
        print('object_________________________________');
        print('data $data');
      },
    );
  }

  void setUploading(bool isUploading) {
    emit(TinderViewState(
        isUploading: isUploading, profileUserData: state.profileUserData));
  }
  // Future<void> uploadPictures({
  //   required AddImagesParams pictures,
  // }) async {
  //   emit(state.copyWith(uploadImageState: TinderStates.initial));
  //   await _uploadTinderPictureUseCase(pictures);
  //   emit(state.copyWith(uploadImageState: TinderStates.success));
  // }

  // Pan and Story handling methods
  void updatePanStart(Offset startDragOffset) {
    emit(state.copyWith(startDragOffset: startDragOffset));
  }

  void updatePanUpdate(Offset position, double rotation) {
    emit(state.copyWith(position: position, rotation: rotation));
  }

  void resetPan() {
    emit(state.copyWith(position: Offset.zero, rotation: 0));
  }

  void swipeAway() {
    emit(state.copyWith(
      position: Offset(state.position!.dx * 50, state.position!.dy * 50),
    ));
    Future.delayed(const Duration(milliseconds: 300), () {
      emit(state.copyWith(
        currentIndex: (state.currentIndex! + 1) % state.userData!.length,
        currentStoryIndex: 0,
        position: Offset.zero,
        rotation: 0,
      ));
    });
  }

  void nextStory() {
    if (state.currentStoryIndex! <
        state.userData![state.currentIndex!].pictures.length - 1) {
      emit(state.copyWith(currentStoryIndex: state.currentStoryIndex! + 1));
    }
  }

  void previousStory() {
    if (state.currentStoryIndex! > 0) {
      emit(state.copyWith(currentStoryIndex: state.currentStoryIndex! - 1));
    }
  }

  void updateCurrentIndex(int newIndex) {
    emit(state.copyWith(currentIndex: newIndex));
  }

  void resetStoryIndex() {
    emit(state.copyWith(currentStoryIndex: 0));
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleSubCategoryToFavoritesUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: TinderStates.failure)),
        (data) {
      result = data;
      emit(state.copyWith(status: TinderStates.success));
    });
    return result;
  }

  Future<void> deletePicture(String id) async {
    final response = await _deleteTinderPictureUseCase(id);
    if (isClosed) return;
    response.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(failure: failure, status: TinderStates.failure));
        }
      },
      (data) {
        if (!isClosed) {
          emit(state.copyWith(status: TinderStates.success));
        }
      },
    );
  }
}
