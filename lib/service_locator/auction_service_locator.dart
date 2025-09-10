
import 'package:get_it/get_it.dart';

import '../features/auction/data/datasource/auction_remote_datasource.dart';
import '../features/auction/data/repositories/auction_repo_impl.dart';
import '../features/auction/domain/repositories/auction_repo.dart';
import '../features/auction/domain/usecases/bid_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_available_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_main_category_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_participants_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_single_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_sub_category_auction_use_case.dart';
import '../features/auction/domain/usecases/join_auction_use_case.dart';
import '../features/auction/domain/usecases/listen_to_new_auction_use_case.dart';
import '../features/auction/domain/usecases/listen_to_new_bid_auction_use_case.dart';
import '../features/auction/presentation/cubit/auction_cubit.dart';

class AuctionServiceLocator {
  static void execute({required GetIt serviceLocator}) async {

    serviceLocator.registerLazySingleton<AuctionRemoteDataSource>(() =>
        AuctionRemoteDataSourceImpl(serviceLocator(),));

    serviceLocator.registerLazySingleton<GetAvailableAuctionUseCase>(
        () => GetAvailableAuctionUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<AuctionRepository>(
        () => AuctionRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<ListenToNewAuctionUseCase>(
        () => ListenToNewAuctionUseCase(serviceLocator()));


    serviceLocator.registerLazySingleton<JoinToAuctionUseCase>(
        () => JoinToAuctionUseCase(serviceLocator()));


    serviceLocator.registerLazySingleton<GetSingleAuctionUseCase>(
        () => GetSingleAuctionUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetParticipantsAuctionUseCase>(
        () => GetParticipantsAuctionUseCase(serviceLocator()));


    serviceLocator.registerLazySingleton<BidAuctionUseCase>(
        () => BidAuctionUseCase(serviceLocator()));


    serviceLocator.registerLazySingleton<ListenToNewBidAuctionUseCase>(
        () => ListenToNewBidAuctionUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetAuctionMainCategoryUseCase>(
        () => GetAuctionMainCategoryUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetAuctionSubCategoryUseCase >(
        () => GetAuctionSubCategoryUseCase (serviceLocator()));



    serviceLocator
        .registerFactory<AuctionCubit>(() => AuctionCubit(
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
