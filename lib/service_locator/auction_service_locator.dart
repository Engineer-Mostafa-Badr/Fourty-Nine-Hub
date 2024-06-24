import 'package:fourtyninehub/features/mazadat_feature/auction_details/data/datasources/auction_details_remote_datasource.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/data/repositories/auction_details_repo_impl.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/usecases/follow_users_auction_usecase.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/usecases/get_auction_details_usecase.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/usecases/send_bidding_usecase.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/presentation/cubit/auction_details_cubit.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/data/datasources/auction_list_remote_date_source.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/data/repositories/auction_list_repo_impl.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/usecases/get_auction_list_usecase.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/presentation/cubit/auction_list_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/mazadat_feature/auction_details/domain/repositories/auction_details_repo.dart';
import '../features/mazadat_feature/auction_list/domain/repositories/auction_list_repo.dart';

class AuctionServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<AuctionListRemoteDataSource>(
        () => AuctionListRemoteDataSourceImpl(
              serviceLocator(),
            ));
            serviceLocator.registerLazySingleton<AuctionDetailsRemoteDataSource>(
        () => AuctionDetailsRemoteDataSourceImpl(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<AuctionListRepo>(
        () => AuctionListRepoImpl(serviceLocator()));
        serviceLocator.registerLazySingleton<AuctionDetailsRepo>(
        () => AuctionDetailsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAuctionListUseCase>(
        () => GetAuctionListUseCase(serviceLocator()));
        serviceLocator.registerLazySingleton<GetAuctionDetailsUseCase>(
        () => GetAuctionDetailsUseCase(serviceLocator()));
         serviceLocator.registerLazySingleton<SendBiddingUseCase>(
        () => SendBiddingUseCase(serviceLocator()));
          serviceLocator.registerLazySingleton<FollowUsersAuctionUseCase>(
        () => FollowUsersAuctionUseCase(serviceLocator()));
    serviceLocator.registerFactory<AuctionListCubit>(() => AuctionListCubit(
      serviceLocator(),
      serviceLocator(),
    )..loadData());
     serviceLocator.registerFactory<AuctionDetailsCubit>(() => AuctionDetailsCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    )..loadData());
  }
}
