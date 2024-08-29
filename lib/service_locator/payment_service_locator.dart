import 'package:fourtyninehub/features/payment/data/data_source/payment_provider_data_source.dart';
import 'package:fourtyninehub/features/payment/data/repositories/payment_provider_repository_impl.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/get_payment_provider_use_case.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:get_it/get_it.dart';

class PaymentProviderServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<PaymentProviderRemoteDataSource>(() =>
        PaymentProviderRemoteDataSourceImpl(serviceLocator(),));


    serviceLocator.registerLazySingleton<PaymentProviderRepository>(
            () => PaymentProviderRepositoryImpl(serviceLocator()));


    serviceLocator.registerLazySingleton<GetPaymentProviderUseCase>(
            () => GetPaymentProviderUseCase(serviceLocator()));


    serviceLocator.registerFactory<PaymentCubit>(() =>
        PaymentCubit(
          serviceLocator(),
        ));
  }
}
