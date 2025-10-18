
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
import '../features/auction/domain/usecases/fetch_all_winner_auction_use_case.dart';
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
import '../features/auction/domain/usecases/search_auction_use_case.dart';
import '../features/auction/presentation/cubit/auction_cubit.dart';
import '../features/social_media/find/data/data_sources/find_data_source.dart';
import '../features/social_media/find/data/repositories/find_repository_impl.dart';
import '../features/social_media/find/domain/repositories/find_repository.dart';
import '../features/social_media/find/domain/usecase/add_dis_like_tinder_use_case.dart';
import '../features/social_media/find/domain/usecase/add_like_tinder_use_case.dart';
import '../features/social_media/find/domain/usecase/add_love_tinder_use_case.dart';
import '../features/social_media/find/domain/usecase/get_find_use_case.dart';
import '../features/social_media/find/presentation/cubit/find_cubit.dart';

class FindServiceLocator {
  static void execute({required GetIt serviceLocator}) async {

    serviceLocator.registerLazySingleton<FindRemoteDataSource>(() =>
        FindRemoteDataSourceImpl(serviceLocator(),));


    serviceLocator.registerLazySingleton<FindRepository>(
        () => FindRepositoryImpl(serviceLocator()));



   serviceLocator.registerLazySingleton<AddLikeFindUseCase >(
        () => AddLikeFindUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<AddDisLikeFindUseCase >(
        () => AddDisLikeFindUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<AddLoveFindUseCase >(
        () => AddLoveFindUseCase (serviceLocator()));


   serviceLocator.registerLazySingleton<GetFindUseCase >(
        () => GetFindUseCase (serviceLocator()));



    serviceLocator
        .registerFactory<FindCubit>(() => FindCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),


            ));
  }
}
