import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../common/functions/global/upload_file.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../fourty_nine/domain/entities/wallet_home_entity.dart';
import '../../../fourty_nine/domain/use_cases/get_wallet_home_use_case.dart';
import '../../domain/entities/cache_out_entity/list_bank_entity.dart';
import '../../domain/entities/instapay_cache_out_entity.dart';
import '../../domain/use_cases/cache_out/fetch_all_bank_use_case.dart';
import '../../domain/use_cases/cache_out/instapay_cache_out_use_case.dart';
import '../../domain/use_cases/cache_out/pay_out_request_use_case.dart';
import '../../domain/use_cases/cache_out/request_yellow_card_use_case.dart';

part 'payment_state.dart';

class PaymentCacheOutCubit extends Cubit<PaymentCacheOutState> {
  PaymentCacheOutCubit(
    this._instapayCacheOutUseCase,
    this._requestYellowCardUseCase, this._getWalletHomeUseCase, this._allBankUseCase, this._payOutRequestUseCase,
  ) : super(PaymentCacheOutState());

  final InstapayCacheOutUseCase _instapayCacheOutUseCase;
  final RequestYellowCardUseCase _requestYellowCardUseCase;
  final GetWalletHomeUseCase _getWalletHomeUseCase;
  final FetchAllBankUseCase _allBankUseCase;//
  final PayOutRequestUseCase _payOutRequestUseCase;


  List<String>? selectedImages;

  Future<void> getWallet() async {
    emit(state.copyWith( status: StateStatus.loading));
    final response = await _getWalletHomeUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (data) {
      emit(state.copyWith(wallet: data));
    });
  }

  Future<void> postInstaPay({
    required InstapayParams params,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await _instapayCacheOutUseCase(params);

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        emit(state.copyWith(
          instaPay: data,
          status: StateStatus.success,
        ));
        // print("InstaPay Data: ${data.message}");
      },
    );
  }

  Future<void> requestYellowCard({
    required RequestYellowCardParams params,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await _requestYellowCardUseCase(params);
    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        emit(state.copyWith(
          status: StateStatus.success,
        ));
        // print("InstaPay Data: ${data.message}");
      },
    );
  }

  Future<void> uploadPhoto({
    bool isGallery = true,
    required bool isFrontImage, // New parameter to differentiate between front and back images
  }) async {
    final UploadFile upload = UploadFile();
    await upload.uploadImage(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          if (isFrontImage) {
            emit(state.copyWith(
              frontImage: data, // Update the frontImage
              backColor: '#FFFFFFFF',
            ));
          } else {
            emit(state.copyWith(
              backImage: data, // Update the backImage
              backColor: '#FFFFFFFF',
            ));
          }
        });
  }

  void removePhoto({bool isFrontImage = true}) {
    if (isFrontImage) {
      state.frontImage==null;
      emit(state.copyWith(
        frontImage: null, // Remove front image
      ));
    } else {
      state.frontImage==null;
      emit(state.copyWith(
        backImage: null, // Remove back image
      ));
    }
  }

  Future<void> fetchAllBank() async {
    emit(state.copyWith( status: StateStatus.loading));
    final response = await _allBankUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (data) {
      emit(state.copyWith(banks: data));
    });
  }

  Future<void> payOutRequest({
    required PayoutRequestParams params,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await _payOutRequestUseCase(params);
    response.fold(
          (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
          (data) {
        emit(state.copyWith(
          status: StateStatus.success,
        ));
        // print("InstaPay Data: ${data.message}");
      },
    );
  }
}