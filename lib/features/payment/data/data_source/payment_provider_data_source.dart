import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/payment/data/models/fawry_delete_card_model.dart';
import 'package:fourtyninehub/features/payment/data/models/fawry_pay_with_card_model.dart';
import 'package:fourtyninehub/features/payment/data/models/fawry_save_card_token_model.dart';
import 'package:fourtyninehub/features/payment/data/models/fawry_saved_card_model.dart';
import 'package:fourtyninehub/features/payment/data/models/instapay_model.dart';
import 'package:fourtyninehub/features/payment/data/models/pay_with_token_model.dart';
import 'package:fourtyninehub/features/payment/data/models/payment_provider_model.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_card_token_response_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_delete_card_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_multi_payment_response.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_card_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_token.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_saved_cards_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/instapay_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/paymob_entity.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_card_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_save_card_token_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/multi_payment_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/pay_with_token_use_case.dart';

import '../../../../core/error/failure.dart';

abstract class PaymentProviderRemoteDataSource {
  Future<Either<Failure, List<PaymentProviderEntity>>> getPaymentProvider();
  Future<Either<Failure, PaymobEntity>> getPaymob(String amountId, String providerId);
  Future<Either<Failure, FawryPayWithCardEntity>> chargeWithCard(FawryParams params);
  Future<Either<Failure, FawryCardTokenResponseEntity>> saveCardToken(FawrySaveCardTokenParams params);
  Future<Either<Failure, List<CardEntity>>> getSavedCards();
  Future<Either<Failure, DeleteCardResponse>> deleteCard(String cardId); 
  Future<Either<Failure, MutliPaymentResponse>> makeMultiPayment(MutliPaymentParams params);
  Future<Either<Failure, InstaPayResponseEntity>> postInstaPay(InstaPayParams params);
  Future<Either<Failure, PayWithTokenResponseEntity>> payWithToken(PayWithTokenParams params);

}

class PaymentProviderRemoteDataSourceImpl implements PaymentProviderRemoteDataSource {
  final ApiConsumer _apiConsumer;
  PaymentProviderRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<PaymentProviderEntity>>> getPaymentProvider()async {
    final response = await _apiConsumer.get(EndPoints.getPaymentProvider);
    return response.fold(
            (failure) => Left(failure),
            (data) => Right((data['data'] as List)
            .map((e) => PaymentProviderModel.fromJson(e))
            .toList()));
  }
  @override
  Future<Either<Failure, PaymobEntity>> getPaymob(String amountId, String providerId) async {
    final response = await _apiConsumer.post(
      EndPoints.getPaymob,
      data:{
        'amountId': amountId,
        'providerId': providerId,
      },
    );
    return response.fold(
          (failure) => Left(failure),
          (data) {
        final paymobData = data['data'] as String;
        return Right(PaymobEntity(
          status: data['status'] as bool,
          message: data['message'] as String,
          data: paymobData,
        ));
      },
    );
  }

  @override
  Future<Either<Failure, FawryPayWithCardEntity>> chargeWithCard(FawryParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.chargeWithCard,
      data: {
        'cardNumber': params.cardNumber,
        'cardExpiryYear': params.cardExpiryYear,
        'cardExpiryMonth': params.cardExpiryMonth,
        'cvv': params.cvv,
        'amountId': params.amountId,
        'providerId': params.providerId,
        'paymentMethod': params.paymentMethod,
      },
    );

    return response.fold(
          (failure) => Left(failure),          (data) {
        final fawryData = data['data'] ?? {};
        final nextActionData = fawryData['nextAction'] ?? {};

        return Right(FawryPayWithCardEntity(
          status: data['status'] as bool? ?? false,
          message: data['message'] as String? ?? 'No message provided',
          data: FawryDataModel(
            type: fawryData['type'] as String? ?? '',
            nextAction: NextActionModel(
              type: nextActionData['type'] as String? ?? '',
              redirectUrl: nextActionData['redirectUrl'] as String? ?? '',
            ),
            statusCode: fawryData['statusCode'] as int? ?? 0,
            statusDescription: fawryData['statusDescription'] as String? ?? '',
            basketPayment: fawryData['basketPayment'] as bool? ?? false,
          ),
        ));
      },
    );
  }

  @override
  Future<Either<Failure, FawryCardTokenResponseEntity>> saveCardToken(FawrySaveCardTokenParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.saveCardToken,
      data: FawrySaveCardTokenModel(
        cardNumber: params.cardNumber,
        cardExpiryYear: params.cardExpiryYear,
        cardExpiryMonth: params.cardExpiryMonth,
        cardAlias: params.cardAlias,
        cvv: params.cvv,
      ).toJson(),
    );

    return response.fold(
          (failure) => Left(failure),
          (data) {
        final cardTokenData = data['data'] ?? {};

        return Right(FawryCardTokenResponseEntity(
          status: data['status'] as bool? ?? false,
          message: data['message'] as String? ?? 'No message provided',
          data: CardTokenDataEntity(
            type: cardTokenData['type'] as String? ?? '',
            statusCode: cardTokenData['statusCode'] as int? ?? 0,
            statusDescription: cardTokenData['statusDescription'] as String? ?? '',
            basketPayment: cardTokenData['basketPayment'] as bool? ?? false,
          ),
        ));
      },
    );
  }

  @override
  Future<Either<Failure, List<CardEntity>>> getSavedCards() async {
    final response = await _apiConsumer.get(EndPoints.getSavedCards);
    return response.fold(
          (failure) => Left(failure),
          (data) {
        final cardList = data['data'] as List;
        final cardModels = cardList.map((e) => SavedCardModel.fromJson(e)).toList();
        return Right(cardModels.map((model) => model.toEntity()).toList());
      },
    );
  }

  @override
  Future<Either<Failure, DeleteCardResponse>> deleteCard(String cardId) async {
    final response = await _apiConsumer.delete(
      '${EndPoints.deleteSavedCard}/$cardId',
    );

    return response.fold(
          (failure) => Left(failure),
          (data) {
        return Right(DeleteCardResponseModel.fromJson(data));
      },
    );
  }

  @override
  Future<Either<Failure, MutliPaymentResponse>> makeMultiPayment(MutliPaymentParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.makeMultiPayment,
      data: {
        'amountId': params.amountId,
        'providerId': params.providerId,
        'paymentMethod': params.paymentMethod,
      },
    );

    return response.fold(
          (failure) => Left(failure),
          (data) {
        return Right(MutliPaymentResponse.fromJson(data));
      },
    );
  }

  @override
  Future<Either<Failure, InstaPayResponseEntity>> postInstaPay(InstaPayParams params)async {
    final response = await _apiConsumer.post(
      EndPoints.postInstaPay,
      data: {
        'receiptId': params.receiptId,
        'amountId': params.amountId,
        'paymentProviderId': params.paymentProviderId,
      },
    );
    return response.fold(
          (failure) => Left(failure),
          (data) {
        return Right(InstapayModel.fromJson(data));
      },
    );
  }

  @override
  Future<Either<Failure, PayWithTokenResponseEntity>> payWithToken(PayWithTokenParams params) async{
    final response = await _apiConsumer.post(
      EndPoints.payWithCardToken,
      data: {
        'cardId': params.cardId,
        'amountId': params.amountId,
        'cvv': params.cvv,
      },
    );
    return response.fold(
          (failure) => Left(failure),
          (data) {
        return Right(PayWithTokenModel.fromJson(data));
      },
    );
  }



}
