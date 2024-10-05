import 'package:fourtyninehub/features/payment/data/data_source/payment_provider_data_source.dart';
import 'package:fourtyninehub/features/payment/data/repositories/cache_out/payment_cache_out_repository_impl.dart';
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
import 'package:fourtyninehub/features/payment/presentation/cache_out_cubit/payment_cubit.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/payment/data/data_source/cache_out/payment_cache_out_data_source.dart';
import '../features/payment/domain/repositories/cache_out/payment_cache_out_repository.dart';
import '../features/payment/domain/use_cases/cache_out/fetch_all_bank_use_case.dart';
import '../features/payment/domain/use_cases/cache_out/instapay_cache_out_use_case.dart';
import '../features/payment/domain/use_cases/cache_out/request_yellow_card_use_case.dart';

class PaymentProviderServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<PaymentProviderRemoteDataSource>(
        () => PaymentProviderRemoteDataSourceImpl(
              serviceLocator(),
            ));
    //Payment Cache Out
    serviceLocator.registerLazySingleton<PaymentCacheOutRemoteDataSource>(
            () => PaymentCacheOutRemoteDataSourceImpl(
          serviceLocator(),
        ));

    serviceLocator.registerLazySingleton<PaymentProviderRepository>(
            () => PaymentProviderRepositoryImpl(serviceLocator()));

    //Payment Cache Out
    serviceLocator.registerLazySingleton<PaymentCacheOutRepository>(
        () => PaymentCacheOutRepositoryImpl(serviceLocator()));

    //

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

    // Payment Cache Out
    serviceLocator.registerLazySingleton<InstapayCacheOutUseCase>(
            () => InstapayCacheOutUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RequestYellowCardUseCase>(
            () => RequestYellowCardUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<FetchAllBankUseCase>(
            () => FetchAllBankUseCase(serviceLocator()));

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

    serviceLocator.registerFactory<PaymentCacheOutCubit>(() => PaymentCacheOutCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ));
  }
}
