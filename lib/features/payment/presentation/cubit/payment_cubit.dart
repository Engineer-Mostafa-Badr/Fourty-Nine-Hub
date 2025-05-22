import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_card_token_response_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_delete_card_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_multi_payment_response.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_card_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_token.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_saved_cards_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/instapay_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/paymob_entity.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/delete_card_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_card_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_save_card_token_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_saved_cards_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/get_payment_provider_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/insta_pay_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/multi_payment_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/pay_with_token_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/paymob_use_case.dart';
import 'package:fourtyninehub/routes/routes.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(
      this.getPaymentProviderUseCase,
      this.paymobUseCase,
      this.fawryCardUseCase,
      this.fawrySaveCardTokenUseCase,
      this.getSavedCardsUseCase,
      this.deleteCardUseCase,
      this.makeMultiPaymentUseCase,
      this.instaPayUseCase,
      this.payWithTokenUseCase)
      : super(PaymentState());
  final GetPaymentProviderUseCase getPaymentProviderUseCase;
  final PaymobUseCase paymobUseCase;
  final FawryCardUseCase fawryCardUseCase;
  final FawrySaveCardTokenUseCase fawrySaveCardTokenUseCase;
  final GetSavedCardsUseCase getSavedCardsUseCase;
  final DeleteCardUseCase deleteCardUseCase;
  final MutliPaymentUseCase makeMultiPaymentUseCase;
  final InstaPayUseCase instaPayUseCase;
  final PayWithTokenseCase payWithTokenUseCase; // Add this line

  CardEntity? get selectedCard => _selectedCard;
  CardEntity? _selectedCard;
  File? _selectedImage;
  Future<void> payWithToken({
    required String cardId,
    required String amountId,
    required String cvv,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await payWithTokenUseCase(PayWithTokenParams(
      cardId: cardId,
      amountId: amountId,
      cvv: cvv,
    ));

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        emit(state.copyWith(
          payWithTokenResponseData: data,
          status: StateStatus.success,
        ));
        print(
            "Pay with Token Data: ${data.message}"); // Logging the message or data received
      },
    );
  }

  File? get selectedImage => _selectedImage;
  Future<void> uploadProfileImage({required BuildContext context}) async {
    emit(state.copyWith(uploadStatus: StateStatus.loading));
    final result = await UploadFile().uploadImage(
      subCategoryId: "66b6167938e6690c102ffa9c",
      onUploaded: (media) {
        emit(state.copyWith(
            uploadedImage: File(media.file.path),
            uploadStatus: StateStatus.success,
            imageMediaId: media.mediaId));
      },
      context: context,
    );
    if (result != null) {
    } else {
      emit(state.copyWith(uploadStatus: StateStatus.error));
    }
  }

  Future<void> postInstaPay(
    context, {
    required String receiptId,
    required String amountId,
    required String paymentProviderId,
    required String phoneNumber,
  }) async {
    emit(state.copyWith(instaPayStatus: StateStatus.loading));

    showLoadingDialog(context);

    final response = await instaPayUseCase(
      InstaPayParams(
        receiptId: receiptId,
        amountId: amountId,
        paymentProviderId: paymentProviderId,
        phoneNumber: phoneNumber,
      ),
    );

    response.fold(
      (failure) {
        Navigator.pop(context);
        emit(state.copyWith(
          failure: failure,
          instaPayStatus: StateStatus.error,
        ));
      },
      (data) {
        Navigator.pop(context);
        emit(state.copyWith(
          instaPayResponseData: data,
          instaPayStatus: StateStatus.success,
        ));
        showSuccessMessage(context, LocaleKeys.paymentSuccessful.localize);
        context.go(Routes.HOME);
        print("InstaPay Data: ${data.message}");
      },
    );
  }

  void setSelectedImage(File xFile) {
    final file = File(xFile.path);
    emit(state.copyWith(selectedImage: file));
  }

  void selectCard(CardEntity card) {
    _selectedCard = card;
    emit(state.copyWith());
  }

  Future<void> deleteCard(String cardId) async {
    emit(state.copyWith(status: StateStatus.loading));
    final response = await deleteCardUseCase(cardId);

    response.fold(
      (failure) {
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
      (deleteCardResponse) {
        emit(state.copyWith(
          status: StateStatus.success,
          deleteCardResponse: deleteCardResponse,
        ));

        getSavedCards();
        print("Card successfully deleted: ${deleteCardResponse.message}");
      },
    );
  }

  Map<String, String> paymentProviderMap = {};

  /// get PaymentProvider

  Future<List<PaymentProviderEntity>> getPaymentProvider() async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await getPaymentProviderUseCase(const NoParams());
    List<PaymentProviderEntity> paymentProviderList = [];
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      paymentProviderList.addAll(data);
      for (var provider in paymentProviderList) {
        paymentProviderMap[provider.nameEn] = provider.id;
        print('Fetched provider: ${provider.nameEn}, ID: ${provider.id}');
      }
      emit(state.copyWith(
          data: paymentProviderList, status: StateStatus.success));
    });
    print("Payment Data:${paymentProviderList.length}");
    return paymentProviderList;
  }

  /// Get Paymob Data
  ///
  ///
  Future<void> getPaymobData(
      {required String amountId, required String providerId}) async {
    emit(state.copyWith(status: StateStatus.loading));
    final response = await paymobUseCase(
        PaymobParams(amountId: amountId, providerId: providerId));

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        emit(state.copyWith(
          paymobData: data,
          status: StateStatus.success,
        ));
        print("Paymob Data: ${data.data}");
      },
    );
  }

  /// Charge with Card
  Future<void> chargeWithCard({
    required String cardNumber,
    required String cardExpiryYear,
    required String cardExpiryMonth,
    required String cvv,
    required String amountId,
    required String providerId,
    required String paymentMethod,
  }) async {
    emit(state.copyWith(status: StateStatus.loading)); // Set loading status

    final response = await fawryCardUseCase(FawryParams(
      cardNumber: cardNumber,
      cardExpiryYear: cardExpiryYear,
      cardExpiryMonth: cardExpiryMonth,
      cvv: cvv,
      amountId: amountId,
      providerId: providerId,
      paymentMethod: paymentMethod,
    ));

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        emit(state.copyWith(
          fawryPayWithCardData: data,
          status: StateStatus.success,
        ));
        print(
            "Fawry Pay with Card Data: ${data.message}"); // Logging the message or data received
      },
    );
  }

  /// Save Card Token
  Future<void> saveCardToken({
    required String cardNumber,
    required String cardExpiryYear,
    required String cardExpiryMonth,
    required String cardAlias,
    required String cvv,
  }) async {
    emit(state.copyWith(status: StateStatus.loading)); // Set loading status

    final response = await fawrySaveCardTokenUseCase(FawrySaveCardTokenParams(
      cardNumber: cardNumber,
      cardExpiryYear: cardExpiryYear,
      cardExpiryMonth: cardExpiryMonth,
      cardAlias: cardAlias,
      cvv: cvv,
    ));

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        emit(state.copyWith(
          fawryCardTokenResponseData: data,
          status: StateStatus.success,
        ));
        print(
            "Fawry Card Token Response Data: ${data.message}"); // Logging the message or data received
      },
    );
  }

  Future<void> getSavedCards() async {
    emit(state.copyWith(status: StateStatus.loading));
    final response = await getSavedCardsUseCase(const NoParams());

    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
      (data) {
        // Print the saved cards data
        print(
            "Fetched saved cards: ${data.map((card) => card.toString()).toList()}");
        emit(state.copyWith(savedCardsData: data, status: StateStatus.success));
      },
    );
  }

  /// Make Multi-Payment
  Future<void> makeMultiPayment({
    required String amountId,
    required String providerId,
    required String paymentMethod,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await makeMultiPaymentUseCase(MutliPaymentParams(
      amountId: amountId,
      providerId: providerId,
      paymentMethod: paymentMethod,
    ));

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
      (data) {
        emit(state.copyWith(
          mutliPaymentResponse: data,
          status: StateStatus.success,
        ));
        print("Multi-Payment Response Data: ${data.message}");
      },
    );
  }
}
