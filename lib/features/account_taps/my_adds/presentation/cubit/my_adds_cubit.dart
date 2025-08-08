import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/edit_my_ads_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/accept_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/accept_pick_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/fetch_my_ads_by_id_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/get_my_trip_join_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/reject_come_with_me_usecase.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/usecases/reject_pick_me_usecase.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';
import '../../../../ride/trip_details/domain/entities/trip_and_request_entity.dart';
import '../../domain/entity/click_entity.dart';
import '../../domain/entity/get_all_count_ads_entity.dart';
import '../../domain/entity/get_all_counts_trip_join_entity.dart';
import '../../domain/entity/my_ads_auction.dart';
import '../../domain/entity/my_ads_trip_join_entity.dart';
import '../../domain/usecases/cancel_ad_usecase.dart';
import '../../domain/usecases/click_use_case.dart';
import '../../domain/usecases/delete_come_with_me_usecase.dart';
import '../../domain/usecases/delete_my_installment_usecase.dart';
import '../../domain/usecases/delete_my_trip_join_usecase.dart';
import '../../domain/usecases/delete_pick_me_usecase.dart';
import '../../domain/usecases/edit_my_ads_use_case.dart';
import '../../domain/usecases/get_all_counts_ads_usecase.dart';
import '../../domain/usecases/get_all_counts_usecase.dart';
import '../../domain/usecases/get_my_ads_usecase.dart';
import '../../domain/usecases/get_my_auctions_usecase.dart';
import '../../domain/usecases/get_my_come_with_you_usecase.dart';
import '../../domain/usecases/get_my_installments_usecase.dart';
import '../../domain/usecases/get_my_other_ads_usecase.dart';
import '../../domain/usecases/get_my_pick_me_usecase.dart';

part 'my_adds_state.dart';

class MyAddsCubit extends Cubit<MyAddsState> {
  final GetMyAdsUseCase _getMyAdsUseCase;
  final GetMyPickMeAdsUseCase _getMyPickMeAdsUseCase;
  final GetMyComeWithMeUseCase _getMyComeWithMeUseCase;
  final DeletePickMeUseCase _deletePickMeUseCase;
  final DeleteComeWithMeUseCase _deleteComeWithMeUseCase;
  final AcceptPickMeUseCase _acceptPickMeUseCase;
  final AcceptComeWithMeUseCase _acceptComeWithMeUseCase;
  final RejectComeWithMeUseCase _rejectComeWithMeUseCase;
  final RejectPickMeUseCase _rejectPickMeUseCase;
  final CancelAdUseCase _cancelAdUseCase;
  final GetMyAuctionsUseCase _getMyAuctionsUseCase;
  final GetMyInstallmentUseCase _getMyInstallmentUseCase;
  final GetMyOtherAdsUseCase _getMyOtherAdsUseCase;
  final GetMyTripJoinUseCase _getMyTripJoinUseCase;
  final DeleteMyTripJoinUseCase _deleteMyTripJoinUseCase;
  final DeleteMyInstallmentUseCase _deleteMyInstallmentUseCase;
  final GetAllCountsUseCase _allCountsUseCase;
  final GetAllCountsAdsUseCase _allCountsAdsUseCase;
  final EditMyAdsUseCase _editMyAdsUseCase;
  final ClickUseCase _clickUseCase;
  final FetchMyAdsByIdUseCase _adsByIdUseCase;

  List<String>? selectedImages;

  MyAddsCubit(
      this._getMyAdsUseCase,
      this._deleteComeWithMeUseCase,
      this._deletePickMeUseCase,
      this._getMyComeWithMeUseCase,
      this._getMyPickMeAdsUseCase,
      this._acceptComeWithMeUseCase,
      this._acceptPickMeUseCase,
      this._rejectComeWithMeUseCase,
      this._cancelAdUseCase,
      this._getMyAuctionsUseCase,
      this._rejectPickMeUseCase,
      this._getMyInstallmentUseCase,
      this._getMyTripJoinUseCase,
      this._deleteMyTripJoinUseCase,
      this._deleteMyInstallmentUseCase,
      this._getMyOtherAdsUseCase,
      this._allCountsUseCase,
      this._allCountsAdsUseCase,
      this._editMyAdsUseCase,
      this._clickUseCase,
      this._adsByIdUseCase)
      : super(const MyAddsState());

  void acceptComeWithMeRequest({required String id}) async {
    final response = await _acceptComeWithMeUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) {
      getComeWithMeTrips();
    });
  }

  void acceptPickMeRequest({
    required String id,
  }) async {
    final response = await _acceptPickMeUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) {
      getPickMeTrips();
    });
  }

  void cancelAd({required String id}) async {
    final response = await _cancelAdUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) {
      getMyAds();
    });
  }

  Future<void> click({
    required ClickParams params,
  }) async {
    final response = await _clickUseCase(params);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) => emit(state.copyWith(click: r, status: MyAddsStates.success)));
  }

  void deleteAd({required String id}) async {}

  void deleteComeWithMe({required String id}) async {
    final response = await _deleteComeWithMeUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) {
      getComeWithMeTrips();
    });
  }

  Future<void> deleteMyInstallment({required String id}) async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _deleteMyInstallmentUseCase(id);
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: MyAddsStates.error));
      },
      (r) {
        emit(
          state.copyWith(status: MyAddsStates.success),
        );
        getMyInstallment();
      },
    );
  }

  Future<void> deleteMyTripJoin({required String id}) async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _deleteMyTripJoinUseCase(id);
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: MyAddsStates.error));
      },
      (r) {
        emit(
          state.copyWith(status: MyAddsStates.success),
        );
        getMyTripJoin();
      },
    );
  }

  void deletePickMeRequest({
    required String id,
  }) async {
    final response = await _deletePickMeUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) {
      getPickMeTrips();
    });
  }

  Future<void> editMyAds({
    required EditParams params,
  }) async {
    final response = await _editMyAdsUseCase(params);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) => emit(state.copyWith(status: MyAddsStates.initState)));
  }

  Future<void> fetchMyAdsById({
    required String id,
  }) async {
    final response = await _adsByIdUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) => emit(state.copyWith(adsById: r, status: MyAddsStates.success)));
  }

  Future<void> getAllCount({
    required Params params,
  }) async {
    final response = await _allCountsUseCase(params);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    },
        (r) =>
            emit(state.copyWith(allCounts: r, status: MyAddsStates.initState)));
  }

  Future<void> getAllCountAds({
    required CountAdsParams params,
  }) async {
    final response = await _allCountsAdsUseCase(params);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    },
        (r) =>
            emit(state.copyWith(countAds: r, status: MyAddsStates.initState)));
  }

  Future<void> getComeWithMeTrips() async {
    final response = await _getMyComeWithMeUseCase(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    },
        (r) => emit(state.copyWith(
            comeWithMeTrips: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyAds() async {
    final response = await _getMyAdsUseCase.call(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) => emit(state.copyWith(myAds: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyAuctions() async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _getMyAuctionsUseCase(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    },
        (r) => emit(
            state.copyWith(myAuctions: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyInstallment() async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _getMyInstallmentUseCase(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    },
        (r) => emit(
            state.copyWith(myInstallments: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyOtherAds() async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _getMyOtherAdsUseCase(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    },
        (r) => emit(
            state.copyWith(myOtherAds: r, status: MyAddsStates.initState)));
  }

  Future<void> getMyTripJoin() async {
    emit(state.copyWith(status: MyAddsStates.loading));
    final response = await _getMyTripJoinUseCase(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    },
        (r) =>
            emit(state.copyWith(tripJoin: r, status: MyAddsStates.initState)));
  }

  Future<void> getPickMeTrips() async {
    final response = await _getMyPickMeAdsUseCase(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    },
        (r) => emit(
            state.copyWith(pickMeTrips: r, status: MyAddsStates.initState)));
  }

  void loadData() async {
    // await getMyAds();
    await getPickMeTrips();
    // await getComeWithMeTrips();
    // await getMyAuctions();
  }

  void rejectComeWithMeRequest({required String id}) async {
    final response = await _rejectComeWithMeUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) {
      getComeWithMeTrips();
    });
  }

  void rejectPickMeRequest({required String id}) async {
    final response = await _rejectPickMeUseCase(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: MyAddsStates.error));
    }, (r) {
      getPickMeTrips();
    });
  }

  removePhoto(UploadFileEntity? image) {
    final images = state.images;
    images?.remove(image);
    emit(state.copyWith(images: images, status: MyAddsStates.success));
    // print(state.fileEntity?.mediaId);
  }

  uploadPhoto({bool isGallery = true, required BuildContext context}) async {
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
              // backColor: '#FFFFFFFF',
              status: MyAddsStates.success));
        },
        context: context);
    print("length${state.images?.length}");
  }
}
