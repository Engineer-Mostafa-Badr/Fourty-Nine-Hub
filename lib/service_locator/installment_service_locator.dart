import 'package:fourtyninehub/features/installment_feature/installment_details/data/datasources/installment_details_remote_datasource.dart';
import 'package:fourtyninehub/features/installment_feature/installment_details/domain/repositories/installment_details_repo.dart';
import 'package:fourtyninehub/features/installment_feature/installment_details/domain/usecases/buy_installment_usecase.dart';
import 'package:fourtyninehub/features/installment_feature/installment_details/domain/usecases/get_installment_details_usecase.dart';
import 'package:fourtyninehub/features/installment_feature/installment_details/presentation/cubit/installment_details_cubit.dart';

import 'package:fourtyninehub/features/installment_feature/installment_list/data/datasources/installment_list_remote_datasource.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/domain/repositories/installment_list_repo.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/domain/usecases/get_installment_list_usecase.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/presentation/cubit/installment_list_cubit.dart';

import 'package:get_it/get_it.dart';

import '../features/installment_feature/installment_details/data/repositories/installment_details_repo_impl.dart';
import '../features/installment_feature/installment_list/data/repositories/installment_list_repo_impl.dart';

class InstallmentServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<InstallmentListRemoteDataSource>(
        () => InstallmentListRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<InstallmentDetailsRemoteDataSource>(
        () => InstallmentDetailsRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<InstallmentListRepo>(
        () => InstallmentListRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<InstallmentDetailsRepo>(
        () => InstallmentDetailsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<GetInstallmentListUseCase>(
        () => GetInstallmentListUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetInstallmentDetailsUseCase>(
        () => GetInstallmentDetailsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<BuyWithInstallmentUseCase>(
        () => BuyWithInstallmentUseCase(serviceLocator()));
    serviceLocator
        .registerFactory<InstallmentListCubit>(() => InstallmentListCubit(
          serviceLocator(),
          serviceLocator(),
        )..loadData());
         serviceLocator
        .registerFactory<InstallmentDetailsCubit>(() => InstallmentDetailsCubit(
          serviceLocator(),
          serviceLocator(),
        )..loadData());
  }
}
