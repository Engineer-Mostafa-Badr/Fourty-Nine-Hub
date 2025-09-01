import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/interceptors/auth_interceptor.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/attach_token_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/check_guest_state_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/convert_guest_to_user_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_anonymous_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_normal_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_profile_views_by_user_id_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_profile_views_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
// import 'package:fourtyninehub/features/authentication/domain/use_cases/get_unreaded_chats_counter_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/save_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/signIn_as_guest_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/update_profile_view_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/update_user_bio_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/update_user_name_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../trip_join/helpers/print_helper.dart';
import '../../../domain/entities/user_tokens_entity.dart';
import '../../../domain/use_cases/get_user_use_case.dart';
import '../../../domain/use_cases/sign_out_usecase.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class UserCubit extends Cubit<BasicState<UserEntity>> with AutoRefreshMixin {
  static UserCubit to = AppPages
      .router.routerDelegate.navigatorKey.currentContext!
      .read<UserCubit>();
  final GetUserUseCase _getUserUseCase;
  final GetTokensUseCase _getTokensUseCase;
  final SaveTokensUseCase _saveTokensUseCase;
  final AttachTokenUseCase _attachTokenUseCase;
  final UpdateUserBioUseCase _updateUserBioUseCase;
  final UpdateUserNameUseCase _updateUserNameUseCase;
  final SignOutUseCase _signOutUseCase;
  final CacheService cacheService;
  final CreateNormalChatUseCase _createNormalChatUseCase;
  final CreateAnonymousChatUseCase _createAnonymousChatUseCase;
  final UpdateProfileViewUseCase _updateProfileViewUseCase;
  final GetProfileViewsUseCase _getProfileViewsUseCase;
  final GetProfileViewsByUserIdUseCase _getProfileViewsByUserIdUseCase;
  // final GetUnreadedChatsCounterUsecase _getUnreadedChatsCounterUsecase;
  int unreadedChatsCounter = 0;
  List<GetProfileViewsEntity> profileViews = [];
  List<GetProfileViewsEntity> profileViewsByUserId = [];
  // final UpdateSocketLocationUseCase updateSocketLocationUseCase;

  // final UserRepository repository;
  bool isTokenAttached = false;

  final SignInAsGuestUseCase _signInAsGuestUseCase;
  final CheckGuestStateUseCase _checkGuestStateUseCase;
  final ConvertGuestToUserUseCase _convertGuestToUserUseCase;

  String? token;

  UserCubit(
    this._getUserUseCase,
    this._getTokensUseCase,
    this._attachTokenUseCase,
    this._saveTokensUseCase,
    this._signOutUseCase,
    this.cacheService,
    this._updateUserBioUseCase,
    this._updateUserNameUseCase,
    this._createNormalChatUseCase,
    this._createAnonymousChatUseCase,
    this._updateProfileViewUseCase,
    this._getProfileViewsUseCase,
    this._getProfileViewsByUserIdUseCase,
    // this.updateSocketLocationUseCase,
    // this._getUnreadedChatsCounterUsecase,
    this._signInAsGuestUseCase,
    this._checkGuestStateUseCase,
    this._convertGuestToUserUseCase,
  ) : super(const BasicState()) {
    // Initialize auto-refresh functionality
    initializeAutoRefresh();
  }
  bool get isAuthenticated => state.data != null && !isGuestMode;
  bool get isGuestMode => state.data?.isGuest == true;

  bool get isLoggedIn => cacheService.isLogin() ?? false;

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

  Future<void> attachToken() async {
    String? accessToken = await CacheManager.getAccessToken();
    String? refreshToken = await CacheManager.getRefreshToken();
    if (accessToken != null && refreshToken != null) {
      final tokens = UserTokensEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      _attachTokenUseCase(tokens);
      
      // Token refresh is now handled by AutoRefreshMixin via stream notification
      // No need for direct callback setup
    }
    isTokenAttached = accessToken != null && refreshToken != null;
    await getUser();
  }

  // فحص حالة Guest عند بدء التطبيق
  Future<void> checkAuthState() async {
    emit(state.copyWith(status: StateStatus.loading));

    // فحص إذا كان في Guest mode
    final guestResult = await _checkGuestStateUseCase(const NoParams());

    guestResult.fold(
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        // فحص التوكن العادي
        attachToken();
      },
      (isGuest) {
        if (isGuest) {
          emit(state.copyWith(
            status: StateStatus.success,
            data: UserEntity.guest(),
          ));
        } else {
          // فحص التوكن العادي
          attachToken();
        }
      },
    );
  }

  Future<void> convertGuestToUser({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    bool isNewAccount = false,
  }) async {
    if (!isGuestMode) return;

    emit(state.copyWith(status: StateStatus.loading));

    final result = await _convertGuestToUserUseCase(ConvertGuestParams(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      isNewAccount: isNewAccount,
    ));

    result.fold(
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
        status: StateStatus.error,
        failure: failure,
      ));},
      (tokens) async {
        // حفظ التوكنز
        await CacheManager.saveAccessToken(tokens.accessToken);
        await CacheManager.saveRefreshToken(tokens.refreshToken);

        // تحديث التوكن في الـ API
        _attachTokenUseCase(tokens);
        isTokenAttached = true;

        // Token refresh is now handled by AutoRefreshMixin via stream notification
        // No need for direct callback setup

        // جلب بيانات المستخدم
        await getUser();

        // إعداد WebSocket
        SharedWebSocket.connect(token: tokens.accessToken);
      },
    );
  }

  // create anonymous chat
  Future<ChatEntity?> createAnonymousChat({required String otherId}) async {
    // emit(state.copyWith(status: StateStatus.loading));
    final response = await _createAnonymousChatUseCase(
        CreateAnonymousChatParams(otherUserId: otherId));
    ChatEntity? chat;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      chat = data;
      emit(state.copyWith(status: StateStatus.success));
    });
    return chat;
  }

  // create normal chat
  Future<ChatEntity?> createNormalChat(
      {required String otherId, required String categoryId}) async {
    // emit(state.copyWith(status: StateStatus.loading));
    final response = await _createNormalChatUseCase(
        CreateNormalChatParams(otherUserId: otherId, categoryId: categoryId));
    ChatEntity? chat;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      chat = data;
      emit(state.copyWith(status: StateStatus.success));
    });
    return chat;
  }

  // جلب بيانات Guest
  Future<T?> getGuestData<T>(String key) async {
    if (!isGuestMode) return null;

    final repository = serviceLocator<AuthRepository>();
    final result = await repository.getGuestData();

    return result.fold(
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        return null;
      },
      (data) => data?[key] as T?,
    );
  }

  Future<void> getProfileView({required bool isProfile}) async {
    profileViews.clear();
    final response = await _getProfileViewsUseCase(
        GetProfileViewsParams(isProfile: isProfile));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      profileViews = r.reversed.toList();
      emit(state.copyWith(status: StateStatus.success));
    });
  }

  Future<void> getProfileViewByUserId(
      {required bool isProfile, required String userId}) async {
    profileViewsByUserId.clear();
    final response = await _getProfileViewsByUserIdUseCase(
        GetProfileViewsParams(isProfile: isProfile, userId: userId));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      profileViewsByUserId = r.reversed.toList();
      emit(state.copyWith(status: StateStatus.success));
    });
  }

  // Future<Either<Failure, UserEntity>?> getUser() async {
  //   if (!isTokenAttached) return null;
  //   final result = await _getUserUseCase(const NoParams());
  //   SharedWebSocket.connect(token: (await CacheManager.getAccessToken())!);
  //   emit(
  //     result.fold(
  //       (failure) {
  //         return state.copyWith(
  //           status: StateStatus.error,
  //           failure: failure,
  //         );
  //       },
  //       (user) {
  //         log("user is :${user.id}");
  //         return state.copyWith(status: StateStatus.success, data: user);
  //       },
  //     ),
  //   );
  //   return result;
  // }

  Future<Either<Failure, UserEntity>?> getUser() async {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    if (!isTokenAttached || isGuestMode||!currentContext.isUserLoggedIn) return null;

    final result = await _getUserUseCase(const NoParams());
    SharedWebSocket.connect(token: (await CacheManager.getAccessToken())??'');

    emit(
      result.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          return state.copyWith(
            status: StateStatus.error,
            failure: failure,
          );
        },
        (user) {
          log("user is :${user.id}");
          return state.copyWith(status: StateStatus.success, data: user);
        },
      ),
    );
    return result;
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

  bool isSameAccount(String anotherId) {
    if (isLoggedIn) {
      return state.data?.id == anotherId;
    }
    return false;
  }

  // Future<void> logout(BuildContext context) async {
  //   // cacheService.setLogin(false);
  //   // _attachTokenUseCase(null);
  //   // _saveTokensUseCase(null);
  //   // isTokenAttached = false;
  //   // log("Token logout ${await CacheManager.getAccessToken()}");
  //   emit(state.copyWith(status: StateStatus.loading));
  //   final result = await _signOutUseCase(const NoParams());
  //   result.fold((l) => emit(state.copyWith(status: StateStatus.error)),
  //       (r) async {
  //     emit(
  //       state.copyWith(
  //         status: StateStatus.success,
  //         token: null,
  //         // data: const UserEntity(
  //         //   id: '',
  //         //   firstName: '',
  //         //   lastName: '',
  //         //   email: null,
  //         //   profilePicture: null,
  //         //   profileCover: null,
  //         //   friendsCount: null,
  //         //   followersCount: null,
  //         //   followingCount: null,
  //         //   wallet: null,
  //         // ),
  //         data: null,
  //       ),
  //     );
  //     // await DI.reset();
  //     // await DI.execute();
  //     SharedWebSocket.disconnect();
  //   });
  //   // if(result == true){
  //   //   emit(state.copyWith(status: StateStatus.success,data: null,token: null));

  //   pr('state token is  ${state.token}');
  //   // }else{
  //   // emit(state.copyWith(status: StateStatus.error));
  //   // }
  // }

  Future<void> logout(BuildContext context) async {
    emit(state.copyWith(status: StateStatus.loading));
    print("isGuestMode $isGuestMode");
    if (isGuestMode) {
      // مسح Guest state
      final result = await _checkGuestStateUseCase(const NoParams());
      result.fold(
        (failure) => emit(state.copyWith(status: StateStatus.error)),
        (_) async {
          await CacheManager.deleteAllTokens();
          emit(state.copyWith(
            status: StateStatus.success,
            data: null,
            token: null,
          ));
        },
      );
    } else {
      // تسجيل خروج عادي
      final result = await _signOutUseCase(const NoParams());
      result.fold(
        (l) {
          var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
          currentContext.pop();
          currentContext.pop();
          showErrorMessage(currentContext, currentContext.isArabic?'حدث خطأ':'Something went wrong');
          emit(state.copyWith(status: StateStatus.error));
        },
        (r) async {
          setLogOut();
          emit(state.copyWith(
            status: StateStatus.success,
            token: null,
            data: null,
          ));
          SharedWebSocket.disconnect();
        },
      );
    }
  }

  Future<void> setLogOut() async {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("ISLOGIN", false);
    currentContext.pop();
    currentContext.pop();
    currentContext.pushReplacement(Routes.HOME);
  }

  // Future<void> getUnreadedChatsCounter() async {
  //   final respons = await _getUnreadedChatsCounterUsecase( const NoParams());
  //   respons.fold((l) => null, (r) {
  //     unreadedChatsCounter = r;
  //   });
  //   emit(state.copyWith(status: StateStatus.success));
  // }

  Future<void> resetUnreadedChatsCounter() async {
    unreadedChatsCounter = 0;
    emit(state.copyWith(status: StateStatus.success));
  }

  // حفظ بيانات Guest (مثل السلة، المفضلة)
  Future<void> saveGuestData(String key, dynamic value) async {
    if (!isGuestMode) return;

    // جلب البيانات الحالية
    final repository = serviceLocator<AuthRepository>();
    final currentDataResult = await repository.getGuestData();

    currentDataResult.fold(
      (failure) => null,
      (currentData) async {
        final updatedData = currentData ?? <String, dynamic>{};
        updatedData[key] = value;
        await repository.saveGuestData(updatedData);
      },
    );
  }

  setLogin(bool value) {
    cacheService.setLogin(value);
  }

  Future<void> signInAsGuest() async {
    emit(state.copyWith(status: StateStatus.loading));

    final result = await _signInAsGuestUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: StateStatus.error,
        failure: failure,
      )),
      (guestUser) => emit(state.copyWith(
        status: StateStatus.success,
        data: guestUser,
      )),
    );
  }

  Future<void> updateProfileView(
      {required bool isProfile, required String userId}) async {
    final response = await _updateProfileViewUseCase(UpdateProfileViewParams(
      isProfile: isProfile,
      userId: userId,
    ));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      log("status = $r");
      emit(state.copyWith(status: StateStatus.success));
    });
  }

  Future<void> updateUserBio({required String bio}) async {
    final respons = await _updateUserBioUseCase(bio);
    respons.fold((l) => null, (r) {
      log("status = $r");
    });
    emit(state.copyWith(status: StateStatus.success));
  }

  Future<void> updateUserName({required String name}) async {
    final respons = await _updateUserNameUseCase(name);
    respons.fold((l) => null, (r) {
      log("status = $r");
    });
    emit(state.copyWith(status: StateStatus.success));
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

  uploadPhoto({bool isGallery = true, required BuildContext context}) async {
    emit(state.copyWith(status: StateStatus.loading));
    Navigator.pop(context);
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
        },
        context: context);
  }

  // Future<void> emitDriverLocation() async {
  //   final result = await updateSocketLocationUseCase(
  //       UpdateSocketLocationParams(latitude: 31.241106, longitude: 30.047558)
  //   );
  //   result.fold(
  //           (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
  //           (r) async {
  //         if(r==true)log("Location Updated Successfully");
  //       });
  // }

  // updateDriverLocation(){
  //   print("state.data?.email${state.data?.email}");
  // final locationService = LocationService();
  //
  //   locationService.startLocationTracking();
  //
  //   // Listen for new locations (only when moved at least 300m)
  //   locationService.locationUpdates.listen((position) {
  //     // emitDriverLocation();
  //     Fluttertoast.showToast(
  //         msg: "New location (moved at least 1m): ${position.latitude}, ${position.longitude}",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0
  //     );
  //     print('New location (moved at least 1m): ${position.latitude}, ${position.longitude}');
  //   });
  //   }

  @override
  void onTokenRefreshed() {
    print('🔄 UserCubit: Token refreshed, updating authentication state...');
    // Get the latest tokens from cache and update the app state
    _updateTokensFromCache();
  }
  
  Future<void> _updateTokensFromCache() async {
    try {
      String? accessToken = await CacheManager.getAccessToken();
      String? refreshToken = await CacheManager.getRefreshToken();
      
      if (accessToken != null && refreshToken != null) {
        final tokens = UserTokensEntity(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        _attachTokenUseCase(tokens);
        isTokenAttached = true;
        print('🔄 UserCubit: Tokens updated successfully');
      }
    } catch (e) {
      print('❌ UserCubit: Error updating tokens from cache: $e');
    }
  }
  
  @override
  Future<void> close() {
    disposeAutoRefresh();
    return super.close();
  }
}
