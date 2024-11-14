import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/attach_token_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/save_tokens_use_case.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../trip_join/helpers/print_helper.dart';
import '../../../domain/entities/user_tokens_entity.dart';
import '../../../domain/use_cases/get_user_use_case.dart';
import '../../../domain/use_cases/sign_out_usecase.dart';

class UserCubit extends Cubit<BasicState<UserEntity>> {
  static UserCubit to = AppPages
      .router.routerDelegate.navigatorKey.currentContext!
      .read<UserCubit>();
  final GetUserUseCase _getUserUseCase;
  final GetTokensUseCase _getTokensUseCase;
  final SaveTokensUseCase _saveTokensUseCase;
  final AttachTokenUseCase _attachTokenUseCase;
  final SignOutUseCase _signOutUseCase;
  final CacheService cacheService;

  // final UserRepository repository;
  bool isTokenAttached = false;

  UserCubit(
      this._getUserUseCase,
      this._getTokensUseCase,
      this._attachTokenUseCase,
      this._saveTokensUseCase,
      this._signOutUseCase,
      this.cacheService)
      : super(const BasicState());

  bool get isLoggedIn => cacheService.isLogin() ?? false;

  bool isSameAccount(String anotherId) {
    if (isLoggedIn) {
      return state.data?.id == anotherId;
    }
    return false;
  }

  Future<Either<Failure, UserEntity>?> getUser() async {
    if (!isTokenAttached) return null;
    final result = await _getUserUseCase(const NoParams());
    emit(
      result.fold(
        (failure) {
          return state.copyWith(
            status: StateStatus.error,
            failure: failure,
          );
        },
        (user) {
          serviceLocator<Socket>().connect();
          log("user is :${user.id}");
          return state.copyWith(status: StateStatus.success, data: user);
        },
      ),
    );
    return result;
  }

  String? token;

  // void attachToken() async {
  //   final result = await _getTokensUseCase(const NoParams());
  //   result.fold(
  //     (_) {},
  //     (tokens) {
  //       if (tokens == null) {
  //         return;
  //       } else {
  //         token = tokens.accessToken.toString();
  //       }
  //       _attachTokenUseCase(tokens);
  //       isTokenAttached = true;
  //       getUser();
  //     },
  //   );
  // }

  void attachToken() async {
    String? accessToken = await CacheManager.getAccessToken();
    String? refreshToken = await CacheManager.getRefreshToken();
    if (accessToken != null && refreshToken != null) {
      _attachTokenUseCase(UserTokensEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ));
    }
    isTokenAttached = accessToken != null && refreshToken != null;
    getUser();
  }

  void logout() async {
    // cacheService.setLogin(false);
    // _attachTokenUseCase(null);
    // _saveTokensUseCase(null);
    // isTokenAttached = false;
    log("Token logout ${await CacheManager.getAccessToken()}");
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _signOutUseCase(const NoParams());
    result.fold((l) => emit(state.copyWith(status: StateStatus.error)),
        (r) => emit(state.copyWith(status: StateStatus.success,token: null,data: const UserEntity(id: '', firstName: '', lastName: '', email: '', profilePicture: '', profileCover: '', friendsCount: null, followersCount: null, followingCount: null, wallet: null))));
    // if(result == true){
    //   emit(state.copyWith(status: StateStatus.success,data: null,token: null));
      pr('state token is  ${state.token}');
    // }else{
    // emit(state.copyWith(status: StateStatus.error));
    // }
  }

  setLogin(bool value) {
    cacheService.setLogin(value);
  }

  Future<void> giveMeTokenForTinder() async {
    final result = await _getTokensUseCase(const NoParams());

    // UserTokensEntity? token;
    result.fold(
      (_) {},
      (tokens) {
        _attachTokenUseCase(tokens);
        isTokenAttached = true;
        // token = tokens!;
        emit(state.copyWith(status: StateStatus.success, token: tokens));
      },
    );
    // TinderSharedUtils.initializeToken(token!.accessToken);
    // return token;
  }

// getWallet() async {
//   if (!isTokenAttached) return;
//   var response = await repository.getWallet();
//   response.fold(
//     (error) {

//     },
//     (data) {

//     },
//   );
// }

  uploadPhoto({bool isGallery = true}) async {
    emit(state.copyWith(status: StateStatus.loading));
    final UploadFile upload = UploadFile();
    await upload.uploadImage(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) async {
          final response = await serviceLocator<ApiConsumer>().put(
            '/users/profile-picture',
            data: {'profilePictureId': data.mediaId},
          );
          return response.fold(
            (failure) {
              emit(state.copyWith(status: StateStatus.error, failure: failure));
              return Left(failure);
            },
            (data) {
              getUser();
              emit(state.copyWith(
                status: StateStatus.success,
              ));

              return const Right(true);
            },
          );
        });
  }
}
