import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/data/data_source/payment_provider_data_source.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_card_token_response_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_delete_card_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_multi_payment_response.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_card_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_token.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_saved_cards_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/instapay_cache_out_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/instapay_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/paymob_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_card_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_save_card_token_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/cache_out/instapay_cache_out_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/multi_payment_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/pay_with_token_use_case.dart';

class PaymentProviderRepositoryImpl implements PaymentProviderRepository {
  final PaymentProviderRemoteDataSource remoteDataSource;

  PaymentProviderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PaymentProviderEntity>>>
      getPaymentProvider() async {
    return await remoteDataSource.getPaymentProvider();
  }

  @override
  Future<Either<Failure, PaymobEntity>> getPaymob(
      String amountId, String providerId) async {
    return await remoteDataSource.getPaymob(amountId, providerId);
  }

  @override
  Future<Either<Failure, FawryPayWithCardEntity>> chargeWithCard(
      FawryParams params) async {
    return await remoteDataSource.chargeWithCard(params);
  }

  @override
  Future<Either<Failure, FawryCardTokenResponseEntity>> saveCardToken(
      FawrySaveCardTokenParams params) async {
    return await remoteDataSource.saveCardToken(params);
  }

  @override
  Future<Either<Failure, List<CardEntity>>> getSavedCards() async {
    return await remoteDataSource.getSavedCards();
  }

  @override
  Future<Either<Failure, DeleteCardResponse>> deleteCard(String cardId) async {
    return await remoteDataSource.deleteCard(cardId);
  }

  @override
  Future<Either<Failure, MutliPaymentResponse>> makeMultiPayment(
      MutliPaymentParams params) async {
    return await remoteDataSource.makeMultiPayment(params);
  }

  @override
  Future<Either<Failure, InstaPayResponseEntity>> postInstaPay(
      InstaPayParams params) async {
    return await remoteDataSource.postInstaPay(params);
  }

  @override
  Future<Either<Failure, PayWithTokenResponseEntity>> payWithToken(
      PayWithTokenParams params) async {
    return await remoteDataSource.payWithToken(params);
  }

  @override
  Future<Either<Failure, InstapayCacheOutEntity>> instapayCacheOut(
      InstapayParams params) {
    return remoteDataSource.instapayCacheOut(params);
  }
}
