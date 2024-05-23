import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_view.dart';
import 'package:go_router/go_router.dart';

import '../features/Food/presentation/pages/CustomerView/restaurant_details.dart';
import '../features/Food/presentation/pages/food_view.dart';
import '../features/RideRequest/presentation/pages/ride_request_view.dart';
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
import '../features/lucky_wheel/presentation/pages/lucky_wheel.dart';
import '../features/mazadat/presentation/pages/Mazad_details.dart';
import '../features/mazadat/presentation/pages/Mazadat_view.dart';
import '../features/social_media/chat/presentation/pages/Chat_room.dart';
import '../features/social_media/chat/presentation/pages/Chat_view.dart';
import '../features/social_media/club_house/presentation/pages/club_house_home.dart';
import '../features/social_media/club_house/presentation/widgets/clubHouseChat.dart';
import '../features/social_media/club_house/presentation/widgets/clubHouseRoom.dart';
import '../features/social_media/reels/presentation/pages/Reel_view.dart';
import '../features/social_media/social/presentation/pages/Social_home.dart';
import '../features/social_media/social/presentation/pages/other_account_view.dart';
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
          builder: (context, state) => const RegisterView(),
          routes: [
            GoRoute(
              name: Routes.VERIFYMAIL,
              path: Paths.VERIFYMAIL,
              builder: (context, state) => RegisterVerifyOTP(
                email: state.extra as String,
              ),
            ),
          ],
        ),
        GoRoute(
          name: Routes.LUCKYWHEEL,
          path: Paths.LUCKYWHEEL,
          builder: (context, state) => LuckyWheelView(),
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
        // WalletView
        GoRoute(
          path: Paths.WALLET,
          name: Routes.WALLET,
          builder: (context, state) => WalletView(),
        ),
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
                builder: (context, state) => ReelView(),
              ),
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
