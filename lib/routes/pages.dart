import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/account/presentation/pages/favourite_view.dart';
import 'package:fourtyninehub/features/account/presentation/pages/my_adds.dart';
import 'package:fourtyninehub/features/account/presentation/pages/share_the_app.dart';
import 'package:fourtyninehub/features/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/spin_wheel_cubit/spin_wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_wallet_cubit/wheel_wallet_cubit.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/settings_view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/music_reels.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/subcategories_view.dart';
import 'package:go_router/go_router.dart';

import '../features/Food/presentation/pages/CustomerView/restaurant_details.dart';
import '../features/Food/presentation/pages/food_view.dart';
import '../features/RideRequest/presentation/pages/ride_request_view.dart';
import '../features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';
import '../features/account/presentation/pages/favourite_category_view.dart';
import '../features/account/presentation/pages/favourite_subcategory_view.dart';
import '../features/health_care/presentation/pages/VisitaView.dart';
import '../features/health_care/presentation/pages/customer_view/DoctorDetails.dart';
import '../features/health_care/presentation/pages/customer_view/DoctorsList.dart';
import '../features/health_care/presentation/pages/customer_view/visita_booking.dart';

import '../features/authentication/presentation/pages/login_view.dart';
import '../features/authentication/presentation/pages/register/register_verify_otp.dart';
import '../features/authentication/presentation/pages/register/register_view.dart';
import '../features/competition/presentation/pages/competition_view.dart';
import '../features/competition/presentation/pages/winners.dart';
import '../features/fourty_nine/presentation/pages/fourty_nine.dart';
import '../features/installments/presentation/pages/installment_details.dart';
import '../features/installments/presentation/pages/installment_order_details.dart';
import '../features/installments/presentation/pages/installment_orders_list.dart';
import '../features/installments/presentation/pages/installment_view.dart';
import '../features/lucky_wheel/presentation/controllers/wheel_cubit/wheel_cubit.dart';
import '../features/lucky_wheel/presentation/pages/lucky_wheel.dart';
import '../features/mazadat/presentation/pages/Mazad_details.dart';
import '../features/mazadat/presentation/pages/Mazadat_view.dart';
import '../features/notifications/presentation/pages/notification_view.dart';
import '../features/quraan/presentation/pages/quraan_view.dart';
import '../features/register/driver_register/presentation/cubit/driver_register_cubit.dart';
import '../features/register/driver_register/presentation/pages/driver_register_view.dart';
import '../features/social_media/chat/presentation/pages/Chat_room.dart';
import '../features/social_media/chat/presentation/pages/Chat_view.dart';
import '../features/social_media/club_house/presentation/pages/club_house_home.dart';
import '../features/social_media/club_house/presentation/widgets/clubHouseChat.dart';
import '../features/social_media/club_house/presentation/widgets/clubHouseRoom.dart';
import '../features/social_media/reels/presentation/pages/Reel_view.dart';
import '../features/social_media/social/presentation/pages/Social_home.dart';
import '../features/social_media/social/presentation/pages/other_account_view.dart';
import '../features/wallet/presentation/pages/wallet_history.dart';
import '../features/wallet/presentation/pages/wallet_view.dart';
import '../features/youtube/presentation/pages/play_video.dart';
import '../features/youtube/presentation/pages/youtube.dart';
import '../features/zoom/presentation/pages/meeting_room.dart';
import '../features/zoom/presentation/pages/zoom_view.dart';
import '../service_locator/service_locator.dart';
import 'routes.dart';

class AppPages {
  AppPages._();

  static final router = GoRouter(routes: <RouteBase>[
    GoRoute(
      path: Routes.HOME,
      builder: (context, state) => const FourtyNineView(),
      routes: <RouteBase>[
        GoRoute(
            path: Paths.SUBCATEGORIES,
            name: Routes.SUBCATEGORIES,
            builder: (context, state) => const SubCategoriesView(),
            routes: [
              GoRoute(
                  path: Paths.ADS,
                  name: Routes.ADS,
                  builder: (context, state) => const AdsView())
            ]),
        GoRoute(
          name: Routes.LOGIN,
          path: Paths.LOGIN,
          builder: (context, state) => BlocProvider(
            create: (_) => serviceLocator<LoginCubit>(),
            child: const LoginView(),
          ),
        ),
        GoRoute(
          name: Routes.REGISTER,
          path: Paths.REGISTER,
          builder: (context, state) => BlocProvider<RegisterCubit>(
            create: (_) => serviceLocator(),
            child: const RegisterView(),
          ),
          routes: [
            GoRoute(
              name: Routes.VERIFYMAIL,
              path: Paths.VERIFYMAIL,
              builder: (context, state) => BlocProvider<VerifyOtpCubit>(
                create: (context) => serviceLocator(),
                child: RegisterVerifyOTP(
                  email: state.extra as String,
                ),
              ),
            ),
            // DriverRegister
            GoRoute(
              name: Routes.REGISTERDRIVER,
              path: Paths.REGISTERDRIVER,
              builder: (context, state) => BlocProvider<DriverRegisterCubit>(
                create: (_) => serviceLocator(),
                child: const DriverRegister(),
              ),
            ),
          ],
        ),

        GoRoute(
          name: Routes.LUCKYWHEEL,
          path: Paths.LUCKYWHEEL,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<WheelCubit>(
                create: (_) => serviceLocator(),
              ),
              BlocProvider<SpinWheelCubit>(
                create: (_) => serviceLocator(),
              ),
              BlocProvider<WheelWalletCubit>(
                create: (_) => serviceLocator(),
              ),
            ],
            child: const LuckyWheelView(),
          ),
        ),
        // CompetitionView
        GoRoute(
          name: Routes.COMPETITIONS,
          path: Paths.COMPETITIONS,
          builder: (context, state) => CompetitionView(),
          routes: [],
        ),
        GoRoute(
          path: Paths.WINNERS,
          name: Routes.WINNERS,
          builder: (context, state) => Winners(),
        ),
        GoRoute(
          path: Paths.QURAAN,
          name: Routes.QURAAN,
          builder: (context, state) => const QuraanView(),
        ),
        GoRoute(
          path: Paths.AZKAAR,
          name: Routes.AZKAAR,
          builder: (context, state) => const QuraanView(),
        ),
        // WalletView
        GoRoute(
            path: Paths.WALLET,
            name: Routes.WALLET,
            builder: (context, state) => const WalletView(),
            routes: [
              GoRoute(
                path: Paths.WALLETHISTORY,
                name: Routes.WALLETHISTORY,
                builder: (context, state) => const WalletHistory(),
              ),
            ]),
        GoRoute(
            path: Paths.ACCOUNT,
            name: Routes.ACCOUNT,
            builder: (context, state) => const NotificationView(),
            routes: [
              GoRoute(
                  path: Paths.NOTIFICATIONS,
                  name: Routes.NOTIFICATIONS,
                  builder: (context, state) => const NotificationView()),
              GoRoute(
                  path: Paths.SETTINGS,
                  name: Routes.SETTINGS,
                  builder: (context, state) => const SettingsView()),
              GoRoute(
                  path: Paths.SHAREAPP,
                  name: Routes.SHAREAPP,
                  builder: (context, state) => const ShareTheApp()),
              GoRoute(
                  path: Paths.FAVOURITE,
                  name: Routes.FAVOURITE,
                  builder: (context, state) => const FavouriteView()),
              GoRoute(
                  path: Paths.FAVOURITECATEGORIES,
                  name: Routes.FAVOURITECATEGORIES,
                  builder: (context, state) => const FavouriteCategoryView()),
              GoRoute(
                  path: Paths.FAVOURITESUBCATEGORIES,
                  name: Routes.FAVOURITESUBCATEGORIES,
                  builder: (context, state) =>
                      const FavouriteSubCategoryView()),
              GoRoute(
                  path: Paths.MYADDS,
                  name: Routes.MYADDS,
                  builder: (context, state) => const MyAdds()),
            ]),
        GoRoute(
            path: Paths.SOCIAL,
            name: Routes.SOCIAL,
            builder: (context, state) => const SocialHomeView(),
            routes: [
              GoRoute(
                  path: Paths.TWITTER,
                  name: Routes.TWITTER,
                  builder: (context, state) => const TwitterView()),
              GoRoute(
                path: Paths.OTHERSACCOUNT,
                name: Routes.OTHERSACCOUNT,
                builder: (context, state) => const OtherAccountView(),
              ),
              GoRoute(
                  path: Paths.REELS,
                  name: Routes.REELS,
                  builder: (context, state) => MultiBlocProvider(
                        providers: [
                          BlocProvider<ExploreReelsCubit>(
                            create: (_) => serviceLocator(),
                          ),
                        ],
                        child: const ReelView(),
                      ),
                  routes: [
                    GoRoute(
                      path: Paths.MUSICREELS,
                      name: Routes.MUSICREELS,
                      builder: (context, state) => const MusicReels(),
                    ),
                  ]),
              GoRoute(
                  path: Paths.TINDER,
                  name: Routes.Tinder,
                  builder: (context, state) => const TinderView()),
              GoRoute(
                  path: Paths.LIVE,
                  name: Routes.LIVE,
                  builder: (context, state) => const LiveStreamView()),
              // ClubHouseHome
              GoRoute(
                  path: Paths.CLUBHOUSE,
                  name: Routes.CLUBHOUSE,
                  builder: (context, state) => const ClubHouseHome(),
                  routes: [
                    GoRoute(
                      path: Paths.CLUBHOUSECHAT,
                      name: Routes.CLUBHOUSECHAT,
                      builder: (context, state) => const ClubHouseChat(),
                    ),
                    // ClubHouseRoom
                    GoRoute(
                      path: Paths.CLUBHOUSEROOM,
                      name: Routes.CLUBHOUSEROOM,
                      builder: (context, state) => const ClubHouseRoom(),
                    ),
                  ]),
            ]),
        // MazadatView
        GoRoute(
            path: Paths.MAZADAT,
            name: Routes.MAZADAT,
            builder: (context, state) => const MazadatView(),
            routes: [
              GoRoute(
                path: Paths.MAZADDETAILS,
                name: Routes.MAZADDETAILS,
                builder: (context, state) => const MazadDetails(),
              ),
              // OtherAccountView
            ]),

        // ChatView
        GoRoute(
            path: Paths.CHAT,
            name: Routes.CHAT,
            builder: (context, state) => ChatView(),
            routes: [
              // ChatRoom
              GoRoute(
                path: Paths.CHATROOM,
                name: Routes.CHATROOM,
                builder: (context, state) => const ChatRoom(),
              ),
            ]),

        // _________________ services ____________
        GoRoute(
            path: Paths.VISITA,
            name: Routes.VISITA,
            builder: (context, state) => const VisitaView(),
            routes: [
              GoRoute(
                  path: Paths.VISITADOCTORLIST,
                  name: Routes.VISITADOCTORLIST,
                  builder: (context, state) => const DoctorsList()),
              GoRoute(
                  path: Paths.VISITADOCTORDETAILS,
                  name: Routes.VISITADOCTORDETAILS,
                  builder: (context, state) => const DoctorDetails()),
              GoRoute(
                  path: Paths.VISITABOOKING,
                  name: Routes.VISITABOOKING,
                  builder: (context, state) => const VisitaBooking()),
            ]),
        GoRoute(
            path: Paths.FOOD,
            name: Routes.FOOD,
            builder: (context, state) => const FoodView(),
            routes: [
              GoRoute(
                path: Paths.RESTAURANTDETAILS,
                name: Routes.RESTAURANTDETAILS,
                builder: (context, state) => const RestaurantDetails(),
              )
            ]),

        GoRoute(
            path: Paths.RIDE,
            name: Routes.RIDE,
            builder: (context, state) => BlocProvider(
                  create: (_) => serviceLocator<RiderequestCubit>(),
                  child: const RideRequestView(),
                ),
            routes: []),
        GoRoute(
            path: Paths.YOUTUBE,
            name: Routes.YOUTUBE,
            builder: (context, state) => const YouTubeView(),
            routes: [
              // PlayVideo
              GoRoute(
                path: Paths.PLAYVIDEO,
                name: Routes.PLAYVIDEO,
                builder: (context, state) => const PlayVideo(),
              )
            ]),
        GoRoute(
            path: Paths.ZOOM,
            name: Routes.ZOOM,
            builder: (context, state) => const ZoomView(),
            routes: [
              // PlayVideo
              GoRoute(
                path: Paths.MEETINGROOM,
                name: Routes.MEETINGROOM,
                builder: (context, state) => const MeetingRoom(),
              )
            ]),
        GoRoute(
            path: Paths.INSTALLMENT,
            name: Routes.INSTALLMENT,
            builder: (context, state) => const InstallmentView(),
            routes: [
              GoRoute(
                path: Paths.INSTALLMENTDETAILS,
                name: Routes.INSTALLMENTDETAILS,
                builder: (context, state) => const InstallmentsDetails(),
              ),
              GoRoute(
                path: Paths.INSTALLMENTORDERDETAILS,
                name: Routes.INSTALLMENTORDERDETAILS,
                builder: (context, state) => const InstallmentOrderDetails(),
              ),
              GoRoute(
                path: Paths.INSTALLMENTORDERS,
                name: Routes.INSTALLMENTORDERS,
                builder: (context, state) => const InstallmentOrdersList(),
              )
            ]),
      ],
    ),
  ]);
}
