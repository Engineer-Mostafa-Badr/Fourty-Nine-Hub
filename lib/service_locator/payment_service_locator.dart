import 'package:fourtyninehub/features/payment/data/data_source/payment_provider_data_source.dart';
import 'package:fourtyninehub/features/payment/data/repositories/payment_provider_repository_impl.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/delete_card_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_card_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_save_card_token_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/fawry_saved_cards_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/get_payment_provider_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/insta_pay_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/multi_payment_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/pay_with_token_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/paymob_use_case.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:get_it/get_it.dart';

class PaymentProviderServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<PaymentProviderRemoteDataSource>(
        () => PaymentProviderRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<PaymentProviderRepository>(
        () => PaymentProviderRepositoryImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<GetPaymentProviderUseCase>(
        () => GetPaymentProviderUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<PaymobUseCase>(
        () => PaymobUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<FawryCardUseCase>(
        () => FawryCardUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<FawrySaveCardTokenUseCase>(
        () => FawrySaveCardTokenUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetSavedCardsUseCase>(
        () => GetSavedCardsUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<DeleteCardUseCase>(
        () => DeleteCardUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<MutliPaymentUseCase>(
        () => MutliPaymentUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<InstaPayUseCase>(
        () => InstaPayUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<PayWithTokenseCase>(
        () => PayWithTokenseCase(serviceLocator()));

    serviceLocator.registerFactory<PaymentCubit>(() => PaymentCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
