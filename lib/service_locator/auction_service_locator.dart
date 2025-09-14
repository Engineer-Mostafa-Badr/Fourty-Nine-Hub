
import 'package:get_it/get_it.dart';

import '../features/auction/data/datasource/auction_remote_datasource.dart';
import '../features/auction/data/repositories/auction_repo_impl.dart';
import '../features/auction/domain/repositories/auction_repo.dart';
import '../features/auction/domain/usecases/add_favorite_auction_use_case.dart';
import '../features/auction/domain/usecases/banner_auction_use_case.dart';
import '../features/auction/domain/usecases/bid_auction_use_case.dart';
import '../features/auction/domain/usecases/bid_winner_auction_use_case.dart';
import '../features/auction/domain/usecases/create_auction_use_case.dart';
import '../features/auction/domain/usecases/error_bid_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_available_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_expired_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_favorite_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_main_category_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_my_bidder_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_myauction_use_case.dart';
import '../features/auction/domain/usecases/fetch_participants_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_single_auction_use_case.dart';
import '../features/auction/domain/usecases/fetch_sub_category_auction_use_case.dart';
import '../features/auction/domain/usecases/join_auction_use_case.dart';
import '../features/auction/domain/usecases/leave_auction_use_case.dart';
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


    serviceLocator.registerLazySingleton<GetExpiredAuctionUseCase >(
        () => GetExpiredAuctionUseCase (serviceLocator()));

   serviceLocator.registerLazySingleton<GetFavoriteAuctionUseCase >(
        () => GetFavoriteAuctionUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<AddFavoriteAuctionUseCase >(
        () => AddFavoriteAuctionUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<GetMyAuctionUseCase >(
        () => GetMyAuctionUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<ErrorBidAuctionUseCase >(
        () => ErrorBidAuctionUseCase (serviceLocator()));



   serviceLocator.registerLazySingleton<BidWinnerAuctionUseCase >(
        () => BidWinnerAuctionUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<LeaveToAuctionUseCase >(
        () => LeaveToAuctionUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<CreateAuctionUseCase >(
        () => CreateAuctionUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<GetMyBiddersAuctionUseCase >(
        () => GetMyBiddersAuctionUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<BannerAuctionUseCase >(
        () => BannerAuctionUseCase (serviceLocator()));



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
              serviceLocator(),
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
