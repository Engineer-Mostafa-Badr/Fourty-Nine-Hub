import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
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

abstract class PaymentProviderRepository {
  Future<Either<Failure, List<PaymentProviderEntity>>> getPaymentProvider();
  Future<Either<Failure, PaymobEntity>> getPaymob(
      String amountId, String providerId);
  Future<Either<Failure, FawryPayWithCardEntity>> chargeWithCard(
      FawryParams params);
  Future<Either<Failure, FawryCardTokenResponseEntity>> saveCardToken(
      FawrySaveCardTokenParams params);
  Future<Either<Failure, List<CardEntity>>> getSavedCards();
  Future<Either<Failure, DeleteCardResponse>> deleteCard(String cardId);
  Future<Either<Failure, MutliPaymentResponse>> makeMultiPayment(
      MutliPaymentParams params);
  Future<Either<Failure, InstaPayResponseEntity>> postInstaPay(
      InstaPayParams params);
  Future<Either<Failure, PayWithTokenResponseEntity>> payWithToken(
      PayWithTokenParams params);
}
