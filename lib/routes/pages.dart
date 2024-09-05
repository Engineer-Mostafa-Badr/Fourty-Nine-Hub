import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/pages/favourite_view.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/presentation/cubit/contact_us_cubit.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/presentation/pages/contact_us_view.dart';
import 'package:fourtyninehub/features/account_taps/lists/presentation/pages/lists_view.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/pages/privacy_view.dart';
import 'package:fourtyninehub/features/account_taps/share_app/presentation/pages/share_the_app.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/ad_details_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/pages/create_ad.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_cubit.dart';
import 'package:fourtyninehub/features/food_feature/cusine_restaurants/presentation/cubit/cusine_restaurants_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/cubit/food_cart_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_dashboard_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/create_resturant_view.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/slider_cubit.dart/slider_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/thumbnails/thumbnails_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/pages/create_doctor_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/all_doctor_reservations/all_doctor_reservations_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_statistics/doctor_statistics_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_today_appointments/doctor_today_appointments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_unhandled_appotinments/doctor_unhandled_appotinments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/all_doctor_reservations_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/doctor_dashboard_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/doctor_statistics.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/edit_doctor_personal_info_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/edit_doctor_profile.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/today_doctor_appointments_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/unhandled_doctor_appointments_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/city_filter_cubit/doctor_city_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/governorate_filter_cubit/doctor_governorate_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/citiy_filter_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/governorate_filter_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/subcategory_filter_view.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/pages/emergnce_view.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/installment_feature/create_installment/presentation/cubit/create_installment_cubit.dart';
import 'package:fourtyninehub/features/installment_feature/installment_details/presentation/cubit/installment_details_cubit.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/presentation/cubit/installment_list_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/spin_wheel_cubit/spin_wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_wallet_cubit/wheel_wallet_cubit.dart';
import 'package:fourtyninehub/features/mazadat_feature/create_auction/presentation/cubit/create_auction_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/pages/requests_history_view.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/settings_view.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/favorite_shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_request_by_my_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_my_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_shipping_view.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/dahsboard_driver_screen.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/driver_requests.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/register_shipping_screen.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/request_detials_screen.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/Chat_room.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/Chat_view.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/widgets/components/create_voice_room_dialogue.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_search_friends.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_search_places.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instgram_view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_home_screen.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/music_reels.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/subcategories_view.dart';
import 'package:fourtyninehub/features/trip_join/domain/usecases/fetch_location_cordinates_usecase.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/trip_join_view.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/meeting_dialogue.dart';
import 'package:go_router/go_router.dart';

import '../core/enums/wallet_types_enums.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_ads_cubit.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_categories_cubit.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import '../features/account_taps/account/presentation/pages/favourite_category_view.dart';
import '../features/account_taps/account/presentation/pages/favourite_subcategory_view.dart';
import '../features/account_taps/lists/presentation/cubit/lists_cubit.dart';
import '../features/account_taps/my_adds/presentation/pages/my_adds.dart';
import '../features/account_taps/policies/presentation/pages/policy_view.dart';
import '../features/account_taps/share_app/presentation/cubit/share_app_cubit.dart';
import '../features/account_taps/transfer_money/presentation/pages/transfer_money_view.dart';
import '../features/account_taps/wallet/presentation/pages/wallet_history.dart';
import '../features/account_taps/wallet/presentation/pages/wallet_view.dart';
import '../features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import '../features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import '../features/ads_feature/create_company_ad/presentation/pages/create_company_ad.dart';
import '../features/authentication/presentation/controllers/create_new_forgot_password_cubit/create_new_forgot_password_cubit.dart';
import '../features/authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import '../features/authentication/presentation/controllers/verify_forgot_password_otp/verify_forgot_password_otp_cubit.dart';
import '../features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';
import '../features/authentication/presentation/pages/forgot_password/create_new_forget_password_view.dart';
import '../features/authentication/presentation/pages/forgot_password/enter_email_forgot_password_view.dart';
import '../features/authentication/presentation/pages/forgot_password/forget_password_otp_verification_view.dart';
import '../features/authentication/presentation/pages/login_view.dart';
import '../features/authentication/presentation/pages/register/register_verify_otp.dart';
import '../features/azkaar/presentation/pages/azkar_view.dart';
import '../features/competition/presentation/pages/competition_view.dart';
import '../features/competition/presentation/pages/winners.dart';
import '../features/food_feature/cusine_restaurants/presentation/pages/cusine_restaurants_view.dart';
import '../features/food_feature/food_cart/presentation/pages/cart_view.dart';
import '../features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../features/food_feature/restaurant_details/presentation/pages/restaurant_details_view.dart';
import '../features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import '../features/food_feature/restaurants_list/presentation/pages/restaurants_lists_view.dart';
import '../features/fourty_nine/presentation/pages/fourty_nine.dart';
import '../features/fourty_nine/presentation/pages/main_categories_cards_view.dart';
import '../features/fourty_nine/presentation/pages/main_categories_taps_view.dart';
import '../features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import '../features/health_feature/booking/presentation/pages/visita_booking.dart';
import '../features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import '../features/health_feature/doctor_details/presentation/pages/DoctorDetails.dart';
import '../features/health_feature/doctor_filter/presentation/pages/doctors_list.dart';
import '../features/health_feature/health/presentation/pages/health_view.dart';
import '../features/installment_feature/create_installment/presentation/pages/create_installment_view.dart';
import '../features/installment_feature/installment_details/presentation/pages/installment_details.dart';
import '../features/installment_feature/installment_list/presentation/pages/installment_view.dart';
import '../features/installment_feature/installments/presentation/pages/installment_order_details.dart';
import '../features/installment_feature/installments/presentation/pages/installment_orders_list.dart';
import '../features/lucky_wheel/presentation/controllers/wheel_cubit/wheel_cubit.dart';
import '../features/lucky_wheel/presentation/pages/lucky_wheel.dart';
import '../features/mazadat_feature/auction_details/presentation/cubit/auction_details_cubit.dart';
import '../features/mazadat_feature/auction_details/presentation/pages/Mazad_details.dart';
import '../features/mazadat_feature/auction_list/presentation/cubit/auction_list_cubit.dart';
import '../features/mazadat_feature/auction_list/presentation/pages/Mazadat_view.dart';
import '../features/mazadat_feature/create_auction/presentation/pages/create_auction_view.dart';
import '../features/notifications/presentation/pages/notification_view.dart';
import '../features/payment/presentation/pages/payment_view.dart';
import '../features/quraan/presentation/pages/quraan_view.dart';
import '../features/register/driver_register/presentation/cubit/driver_register_cubit.dart';
import '../features/register/driver_register/presentation/pages/driver_register_view.dart';
import '../features/requests_history/presentation/cubit/request_history_cubit.dart';
import '../features/ride/RideRequest/presentation/pages/ride_request_view.dart';
import '../features/ride/driver_dashboard/presentation/cubit/driver_dashboard_cubit.dart';
import '../features/ride/driver_dashboard/presentation/pages/driver_dashboard_view.dart';
import '../features/ride/trip_details/presentation/cubit/trip_details_cubit.dart';
import '../features/ride/trip_details/presentation/pages/trip_details_view.dart';
import '../features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
import '../features/social_media/club_house/presentation/pages/audio_stream_screen.dart';
import '../features/social_media/club_house/presentation/pages/club_house_home_screen.dart';
import '../features/social_media/create_post/presentation/pages/create_post_view.dart';
import '../features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import '../features/social_media/social_posts/presentation/pages/Social_home.dart';
import '../features/social_media/social_posts/presentation/pages/other_account_view.dart';
import '../features/social_media/twitter/presentation/pages/twitter_post_details.dart';
import '../features/subcategories/presentation/cubit/subcategories_cubit.dart';
import '../features/youtube/presentation/pages/play_video.dart';
import '../features/youtube/presentation/pages/youtube.dart';
import '../features/zoom/presentation/pages/meeting_room.dart';
import '../features/zoom/presentation/pages/meeting_view.dart';
import '../service_locator/service_locator.dart';
import 'routes.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';

class AppPages {
  AppPages._();

  static final router = GoRouter(routes: <RouteBase>[
    GoRoute(
      path: Routes.HOME,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => serviceLocator<SliderCubit>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<ThumbnailsCubit>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<MainCategoriesCubit>(),
          ),
        ],
        child: const FourtyNineView(),
        // child:  DriverRequests(),
      ),
      routes: <RouteBase>[
        // FLIP CARDS
        GoRoute(
          path: Paths.MAINCATEGORIESCARDS,
          name: Routes.MAINCATEGORIESCARDS,
          builder: (context, state) => const MainCategoriesFlipCardsView(),
        ),
        //GRID VIEW
        GoRoute(
          path: Paths.MAINCATEGORIESTREE,
          name: Routes.MAINCATEGORIESTREE,
          builder: (context, state) => BlocProvider(
              create: (context) => serviceLocator<MainCategoriesTapsCubit>(),
              child: const MainCategoriesGridView()),
        ),
        GoRoute(
            path: Paths.SUBCATEGORIES,
            name: Routes.SUBCATEGORIES,
            builder: (context, state) => BlocProvider.value(
                  value: serviceLocator<SubcategoriesCubit>(),
                  child: SubCategoriesView(
                    mainCategory: state.extra as MainCategoryEntity,
                  ),
                ),
            routes: [
              GoRoute(
                  path: Paths.ADS,
                  name: Routes.ADS,
                  builder: (context, state) => BlocProvider.value(
                        value: serviceLocator<AdsCubit>(),
                        child: AdsView(
                          params: state.extra as AdsViewParams,
                        ),
                      ),
                  routes: [
                    GoRoute(
                        path: Paths.ADdetails,
                        name: Routes.ADdetails,
                        builder: (context, state) =>
                            BlocProvider<AdDetailsCubit>(
                              create: (_) => serviceLocator(),
                              child: AdDetailsView(id: state.extra as String),
                            )),
                    GoRoute(
                      path: Paths.CREATEAD,
                      name: Routes.CREATEAD,
                      builder: (context, state) => BlocProvider.value(
                          value: serviceLocator<CreateAdCubit>(),
                          child: CreateAdView(
                            categorization: state.extra as CategorizationEntity,
                          )),
                    ),
                    // CreateCompanyAdView
                    GoRoute(
                      path: Paths.CREATECOMPANYAD,
                      name: Routes.CREATECOMPANYAD,
                      builder: (context, state) =>
                          BlocProvider<CreateCompanyAdCubit>(
                              create: (_) => serviceLocator(),
                              child: const CreateCompanyAdView()),
                    ),
                  ]),
            ]),
        GoRoute(
          name: Routes.LOGIN,
          path: Paths.LOGIN,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => serviceLocator<LoginCubit>(),
              ),
              BlocProvider(
                create: (_) => serviceLocator<RegisterCubit>(),
              ),
              BlocProvider(
                create: (_) => serviceLocator<WalletCubit>(),
              ),
              BlocProvider(
                create: (_) => serviceLocator<GetWalletCubit>(),
              ),
            ],
            child: LoginView(
              authType: AuthType.LOGIN,
            ),
          ),
        ),
        GoRoute(
          path: Paths.FORGOTPASSWORD,
          name: Routes.FORGOTPASSWORD,
          builder: (context, state) => BlocProvider<ForgotPasswordCubit>(
            create: (_) => serviceLocator(),
            child: const EnterEmailForgotPasswordView(),
          ),
        ),
        GoRoute(
          path: Paths.FORGOTPASSWORDOTP,
          name: Routes.FORGOTPASSWORDOTP,
          builder: (context, state) =>
              BlocProvider<VerifyForgotPasswordOtpCubit>(
            create: (_) => serviceLocator(),
            child: ForgetPasswordOtpVerificationView(
              email: state.extra as String,
            ),
          ),
        ),
        GoRoute(
          path: Paths.CREATENEWFORGOTPASSWORD,
          name: Routes.CREATENEWFORGOTPASSWORD,
          builder: (context, state) =>
              BlocProvider<CreateNewForgotPasswordCubit>(
            create: (_) => serviceLocator(),
            child: CreateNewForgetPasswordView(
              email: state.extra as String,
            ),
          ),
        ),
        GoRoute(
          name: Routes.REGISTER,
          path: Paths.REGISTER,
          // builder: (context, state) => BlocProvider<RegisterCubit>(
          //   create: (_) => serviceLocator(),
          //   child:
          // ),
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => serviceLocator<LoginCubit>(),
              ),
              BlocProvider(
                create: (_) => serviceLocator<RegisterCubit>(),
              ),
            ],
            child: LoginView(
              authType: AuthType.REGISTER,
            ),
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
                child: DriverRegister(
                  subCategoryId: state.extra as String,
                ),
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
            builder: (context, state) => const CompetitionView(
              list: [],
            ),
            routes: const [],
          ),
          // PaymentView
          GoRoute(
            name: Routes.PAYMENT,
            path: Paths.PAYMENT,
            builder: (context, state) => const PaymentView(),
            routes: const [],
          ),
          GoRoute(
            path: Paths.WINNERS,
            name: Routes.WINNERS,
            builder: (context, state) => const Winners(),
          ),
          GoRoute(
            path: Paths.QURAAN,
            name: Routes.QURAAN,
            builder: (context, state) => const QuraanView(),
          ),
          GoRoute(
            path: Paths.AZKAAR,
            name: Routes.AZKAAR,
            builder: (context, state) => const AzkarView(),
          ),
          // WalletView
          GoRoute(
              path: Paths.WALLET,
              name: Routes.WALLET,
              builder: (context, state) => BlocProvider<WalletCubit>(
                    create: (_) => serviceLocator(),
                    child: WalletView(
                      type: state.extra as WalletTypes,
                    ),
                  ),
              routes: [
                GoRoute(
                    path: Paths.WALLETHISTORY,
                    name: Routes.WALLETHISTORY,
                    builder: (context, state) {
                      final item = state.extra as List<WalletHistoryEntity>;
                      return WalletHistory(
                        list: item,
                      );
                    }),
                GoRoute(
                  path: Paths.TRANSFERMONEY,
                  name: Routes.TRANSFERMONEY,
                  builder: (context, state) => const TransferMoneyView(),
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
                    path: Paths.PRIVACY,
                    name: Routes.PRIVACY,
                    builder: (context, state) => const PrivacyView()),
                GoRoute(
                    path: Paths.POLICY,
                    name: Routes.POLICY,
                    builder: (context, state) => const PolicyView()),
                GoRoute(
                    path: Paths.Lists,
                    name: Routes.Lists,
                    builder: (context, state) => BlocProvider<ListsCubit>(
                          create: (_) => serviceLocator(),
                          child: const ListsView(),
                        )),
                GoRoute(
                    path: Paths.SHAREAPP,
                    name: Routes.SHAREAPP,
                    //
                    builder: (context, state) => BlocProvider<ShareAppCubit>(
                          create: (_) => serviceLocator(),
                          child: const ShareTheApp(),
                        )),
                GoRoute(
                    path: Paths.FAVOURITE,
                    name: Routes.FAVOURITE,
                    builder: (context, state) => BlocProvider.value(
                        value: serviceLocator<FavouriteAdsCubit>(),
                        child: const FavouriteView())),
                GoRoute(
                    path: Paths.FAVOURITECATEGORIES,
                    name: Routes.FAVOURITECATEGORIES,
                    builder: (context, state) =>
                        BlocProvider<FavouriteCategoryCubit>(
                          create: (_) => serviceLocator(),
                          child: const FavouriteCategoryView(),
                        )),
                GoRoute(
                  path: Paths.FAVOURITESUBCATEGORIES,
                  name: Routes.FAVOURITESUBCATEGORIES,
                  builder: (context, state) =>
                      BlocProvider<FavouriteSubCategoryCubit>(
                    create: (_) => serviceLocator(),
                    child: const FavSubCategoryView(
                      favoriteSubCategory: [],
                    ),
                  ),
                ),
                GoRoute(
                    path: Paths.MYADDS,
                    name: Routes.MYADDS,
                    builder: (context, state) => BlocProvider<MyAddsCubit>(
                          create: (_) => serviceLocator(),
                          child: const MyAddsView(),
                        )),
              ]),
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
          builder: (context, state) => const CompetitionView(
            list: [],
          ),
          routes: const [],
        ),
        // PaymentView
        GoRoute(
          name: Routes.PAYMENT,
          path: Paths.PAYMENT,
          builder: (context, state) => const PaymentView(),
          routes: const [],
        ),
        GoRoute(
          path: Paths.WINNERS,
          name: Routes.WINNERS,
          builder: (context, state) => const Winners(),
        ),
        GoRoute(
          path: Paths.QURAAN,
          name: Routes.QURAAN,
          builder: (context, state) => const QuraanView(),
        ),
        GoRoute(
          path: Paths.AZKAAR,
          name: Routes.AZKAAR,
          builder: (context, state) => const AzkarView(),
        ),
        // WalletView
        GoRoute(
            path: Paths.WALLET,
            name: Routes.WALLET,
            builder: (context, state) => BlocProvider<WalletCubit>(
                  create: (_) => serviceLocator(),
                  child: WalletView(
                    type: state.extra as WalletTypes,
                  ),
                ),
            routes: [
              GoRoute(
                  path: Paths.WALLETHISTORY,
                  name: Routes.WALLETHISTORY,
                  builder: (context, state) {
                    final item = state.extra as List<WalletHistoryEntity>;
                    return WalletHistory(
                      list: item,
                    );
                  }),
              GoRoute(
                path: Paths.TRANSFERMONEY,
                name: Routes.TRANSFERMONEY,
                builder: (context, state) => const TransferMoneyView(),
              ),
            ]),
        GoRoute(
            path: Paths.ACCOUNT,
            name: Routes.ACCOUNT,
            builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => serviceLocator<CallMessageCubit>(),
                    ),
                    BlocProvider(
                      create: (context) => serviceLocator<TripCubit>(),
                    ),
                  ],
                  child: const NotificationView(),
                ),
            routes: [
              GoRoute(
                path: Paths.NOTIFICATIONS,
                name: Routes.NOTIFICATIONS,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => serviceLocator<CallMessageCubit>(),
                    ),
                    BlocProvider(
                      create: (context) => serviceLocator<TripCubit>(),
                    ),
                  ],
                  child: const NotificationView(),
                ),
              ),
              GoRoute(
                  path: Paths.SETTINGS,
                  name: Routes.SETTINGS,
                  builder: (context, state) => const SettingsView()),
              GoRoute(
                  path: Paths.PRIVACY,
                  name: Routes.PRIVACY,
                  builder: (context, state) => const PrivacyView()),
              GoRoute(
                  path: Paths.POLICY,
                  name: Routes.POLICY,
                  builder: (context, state) => const PolicyView()),
              GoRoute(
                  path: Paths.Lists,
                  name: Routes.Lists,
                  builder: (context, state) => BlocProvider<ListsCubit>(
                        create: (_) => serviceLocator(),
                        child: const ListsView(),
                      )),
              GoRoute(
                  path: Paths.SHAREAPP,
                  name: Routes.SHAREAPP,
                  //
                  builder: (context, state) => BlocProvider<ShareAppCubit>(
                        create: (_) => serviceLocator(),
                        child: const ShareTheApp(),
                      )),
              GoRoute(
                  path: Paths.FAVOURITE,
                  name: Routes.FAVOURITE,
                  builder: (context, state) => BlocProvider.value(
                      value: serviceLocator<FavouriteAdsCubit>(),
                      child: const FavouriteView())),
              GoRoute(
                  path: Paths.FAVOURITECATEGORIES,
                  name: Routes.FAVOURITECATEGORIES,
                  builder: (context, state) =>
                      BlocProvider<FavouriteCategoryCubit>(
                        create: (_) => serviceLocator(),
                        child: const FavouriteCategoryView(),
                      )),
              GoRoute(
                path: Paths.FAVOURITESUBCATEGORIES,
                name: Routes.FAVOURITESUBCATEGORIES,
                builder: (context, state) =>
                    BlocProvider<FavouriteSubCategoryCubit>(
                  create: (_) => serviceLocator(),
                  child: const FavSubCategoryView(
                    favoriteSubCategory: [],
                  ),
                ),
              ),
              GoRoute(
                  path: Paths.MYADDS,
                  name: Routes.MYADDS,
                  builder: (context, state) => BlocProvider<MyAddsCubit>(
                        create: (_) => serviceLocator(),
                        child: const MyAddsView(),
                      )),
            ]),

          GoRoute(
            path: Paths.INSTAGRAM,
            name: Routes.INSTAGRAM,
            builder: (context, state) => BlocProvider<InstagramCubit>(
              create: (_) => serviceLocator()..loadData(),
              child: const InstagramView(),
            ),
          ),
          //social home
          GoRoute(
              path: Paths.SOCIAL,
              name: Routes.SOCIAL,
              builder: (context, state) {
                final userId = state.extra as String?;

                return SocialHomeView(
                  userId: userId ?? '',
                );
              },
              routes: [
                GoRoute(
                  path: Paths.CREATEPOST,
                  name: Routes.CREATEPOST,
                  builder: (context, state) {
                    final social = state.extra as String?;

                  return BlocProvider<CreatePostCubit>(
                    create: (_) {
                      if (social != 'twitter') {
                        return serviceLocator()..loadData();
                      } else {
                        return serviceLocator();
                      }
                    },
                    child: CreatePostView(
                      social: social ?? 'social',
                    ),
                  );
                },
              ),

              GoRoute(
                  path: Paths.TWITTER,
                  name: Routes.TWITTER,
                  builder: (context, state) => BlocProvider<TwitterCubit>(
                      create: (_) => serviceLocator(),
                      child: const TwitterView()),
                  routes: [
                    GoRoute(
                      path: Paths.TWITTERPOSTDETAILS,
                      name: Routes.TWITTERPOSTDETAILS,
                      builder: (context, state) {
                        final id = state.extra as String?;
                        return TwitterPostDetails(
                          postId: id ?? '',
                        );
                      },
                    )
                  ]),
              GoRoute(
                path: Paths.OTHERSACCOUNT,
                name: Routes.OTHERSACCOUNT,
                builder: (context, state) {
                  final id = state.extra as String?;
                  return BlocProvider<SocialPostsCubit>(
                      create: (_) =>
                          serviceLocator()..getUserProfile(id: id ?? ''),
                      child: OtherAccountView(
                        userId: id ?? '',
                      ));
                },
              ),
              GoRoute(
                  path: Paths.REELS,
                  name: Routes.REELS,
                  builder: (context, state) => MultiBlocProvider(
                        providers: [
                          BlocProvider<ReelsCubit>(
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
                  builder: (context, state) => const LiveStreamHomeScreen(),
                  routes: [
                    GoRoute(
                        path: Paths.LIVEVIEW,
                        name: Routes.LIVEView,
                        builder: (context, state) {
                          var extras = state.extra as ZegoArgs;
                          return LiveStreamView(
                            isHost: extras.isHost,
                            liveID: extras.liveId,
                          );
                        }),
                  ],
                ),
                // ClubHouseHome
                GoRoute(
                    path: Paths.CLUBHOUSE,
                    name: Routes.CLUBHOUSE,
                    builder: (context, state) => BlocProvider<ClubVoiceCubit>(
                          create: (context) => serviceLocator()..getAllRooms(),
                          child: const ClubHouseHome(),
                        ),
                    routes: [
                      GoRoute(
                        path: Paths.CLUBHOUSEROOM,
                        name: Routes.AUDIOSTREAMSCREEN,
                        builder: (context, state) {
                          final extras = state.extra as RoomArgs;
                          return AudioStreamScreen(
                            liveId: extras.liveId,
                            roomSubject: extras.subject,
                            isHost: extras.isHost,
                          );
                        },
                        routes: const [],
                      ),
                    ]),
              ]),

        // MazadatView
        GoRoute(
            path: Paths.MAZADAT,
            name: Routes.MAZADAT,
            builder: (context, state) => BlocProvider<AuctionListCubit>(
                child: const MazadatView(), create: (_) => serviceLocator()),
            routes: [
              GoRoute(
                path: Paths.MAZADDETAILS,
                name: Routes.MAZADDETAILS,
                builder: (context, state) => BlocProvider<AuctionDetailsCubit>(
                  create: (_) => serviceLocator(),
                  child: MazadDetails(id: state.extra as String),
                ),
              ),
              // CreateAuctionView
              GoRoute(
                  path: Paths.CREATEAUCTION,
                  name: Routes.CREATEAUCTION,
                  builder: (context, state) => BlocProvider.value(
                        value: serviceLocator<CreateAuctionCubit>(),
                        child: CreateAuctionView(
                          adId: state.extra as String,
                        ),
                      )),
              // OtherAccountView
            ]),

          // ChatView
          GoRoute(
            path: Paths.CHAT,
            name: Routes.CHAT,
            builder: (context, state) => BlocProvider<ChatsCubit>(
              create: (_) => serviceLocator(),
              child: const ChatView(),
            ),
          ),

          // Chat Room
          GoRoute(
            path: Paths.CHATROOM,
            name: Routes.CHATROOM,
            builder: (context, state) => BlocProvider<ChatRoomCubit>(
              create: (_) => serviceLocator(),
              child: ChatRoom(
                chatId: state.extra as String,
              ),
            ),
          ),

          // _________________ services ____________

        GoRoute(
            path: Paths.VISITA,
            name: Routes.VISITA,
            builder: (context, state) {
              return BlocProvider<HealthCubit>(
                create: (_) => serviceLocator<HealthCubit>(),
                child: const HealthView(),
              );
            },
            routes: [
              GoRoute(
                path: Paths.CREATERESTURANT,
                name: Routes.CREATERESTURANT,
                builder: (context, state) => BlocProvider<CreateResturantCubit>(
                  create: (context) => serviceLocator(),
                  child: const CreateResturantView(),
                ),
              ),
              GoRoute(
                path: Paths.VISITAEMERGENCY,
                name: Routes.VISITAEMERGENCY,
                builder: (context, state) => BlocProvider<HealthEmergencyCubit>(
                  create: (context) => serviceLocator(),
                  child: const HealthEmergencyView(),
                ),
              ),
              GoRoute(
                path: Paths.CREATEDOCTOR,
                name: Routes.CREATEDOCTOR,
                builder: (context, state) => BlocProvider<CreateDoctorCubit>(
                  create: (context) => serviceLocator(),
                  child: const CreateDoctorView(),
                ),
              ),
              GoRoute(
                path: Paths.FILTERDOCTORSUBCATEGORY,
                name: Routes.FILTERDOCTORSUBCATEGORY,
                builder: (context, state) =>
                    BlocProvider<DoctorSubcategoryFilterCubit>(
                  create: (context) => serviceLocator(),
                  child: const DoctorSubcategoryFilterView(),
                ),
              ),
              GoRoute(
                path: Paths.FILTERDOCTORGOVERNORATE,
                name: Routes.FILTERDOCTORGOVERNORATE,
                builder: (context, state) =>
                    BlocProvider<DoctorGovernorateFilterCubit>(
                  create: (context) => serviceLocator(),
                  child: const DoctorGovernorateFilterView(),
                ),
              ),
              GoRoute(
                path: Paths.FILTERDOCTORCITY,
                name: Routes.FILTERDOCTORCITY,
                builder: (context, state) =>
                    BlocProvider<DoctorCityFilterCubit>(
                  create: (context) => serviceLocator(),
                  child: const DoctorCityFilterView(),
                ),
              ),
              GoRoute(
                path: Paths.VISITADOCTORLIST,
                name: Routes.VISITADOCTORLIST,
                builder: (context, state) => BlocProvider<DoctorsListCubit>(
                  create: (context) => serviceLocator(),
                  child: const DoctorsListView(),
                ),
              ),
              GoRoute(
                  path: Paths.VISITADOCTORDETAILS,
                  name: Routes.VISITADOCTORDETAILS,
                  builder: (context, state) {
                    return BlocProvider<DoctorDetailsCubit>(
                        child: DoctorDetailsView(
                          doctorId: (state.extra) as String,
                        ),
                        create: (_) => serviceLocator());
                  }),
              GoRoute(
                  path: Paths.VISITABOOKING,
                  name: Routes.VISITABOOKING,
                  // BookDoctorAppointmentCubit
                  builder: (context, state) =>
                      BlocProvider<BookDoctorAppointmentCubit>(
                          create: (_) => serviceLocator(),
                          child: VisitaBooking(
                            doctorDetailsCubit:
                                (state.extra) as DoctorDetailsCubit,
                          ))),
              GoRoute(
                  path: Paths.DOCTORDASHBOARD,
                  name: Routes.DOCTORDASHBOARD,
                  builder: (context, state) =>
                      BlocProvider<DoctorDashboardCubit>(
                          create: (_) => serviceLocator(),
                          child: const DoctorDashboardView())),
              GoRoute(
                  path: Paths.EDITDOCTORPROFILE,
                  name: Routes.EDITDOCTORPROFILE,
                  builder: (context, state) =>
                      BlocProvider<EditDoctorProfileCubit>(
                        create: (context) => serviceLocator(),
                        child: const EditDoctorProfileView(),
                      )),
              GoRoute(
                  path: Paths.EDITDOCTORPERSONALINFO,
                  name: Routes.EDITDOCTORPERSONALINFO,
                  builder: (context, state) =>
                      const EditDoctorPersonalInfoView()),
              GoRoute(
                  path: Paths.DOCTORSTATISTICS,
                  name: Routes.DOCTORSTATISTICS,
                  builder: (context, state) =>
                      BlocProvider<DoctorStatisticsCubit>(
                        create: (context) => serviceLocator(),
                        child: const DoctorStatisticsView(),
                      )),
              GoRoute(
                  path: Paths.DOCTORTODAYAPPOINTMENTS,
                  name: Routes.DOCTORTODAYAPPOINTMENTS,
                  builder: (context, state) =>
                      BlocProvider<DoctorTodayAppointmentsCubit>(
                        create: (context) => serviceLocator(),
                        child: const DoctorTodayAppointmentsView(),
                      )),
              GoRoute(
                  path: Paths.DOCTORUNHANDLEDAPPOINTMENTS,
                  name: Routes.DOCTORUNHANDLEDAPPOINTMENTS,
                  builder: (context, state) =>
                      BlocProvider<DoctorUnhandledAppointmentsCubit>(
                        create: (context) => serviceLocator(),
                        child: const DoctorUnhandledAppointmentsView(),
                      )),
              GoRoute(
                  path: Paths.ALLDOCTORRESERVATIONS,
                  name: Routes.ALLDOCTORRESERVATIONS,
                  builder: (context, state) =>
                      BlocProvider<AllDoctorReservationsCubit>(
                        create: (context) => serviceLocator(),
                        child: const AllDoctorReservationsView(),
                      )),
            ]),
        GoRoute(
            path: Paths.FOOD,
            name: Routes.FOOD,
            builder: (context, state) => BlocProvider<RestaurantsListCubit>(
                  create: (_) => serviceLocator(),
                  child: const RestaurantsListsView(),
                ),
            routes: [
              // CusineRestaurantsView
              GoRoute(
                path: Paths.RestaurantDashboard,
                name: Routes.RestaurantDashboard,
                builder: (context, state) =>
                    BlocProvider<RestaurantDashboardCubit>(
                  create: (_) => serviceLocator(),
                  child: const RestaurantDashboardView(),
                ),
              ),
              GoRoute(
                path: Paths.CusineRestaurants,
                name: Routes.CusineRestaurants,
                builder: (context, state) =>
                    BlocProvider<CusineRestaurantsCubit>(
                  create: (_) => serviceLocator(),
                  child: const CusineRestaurantsView(),
                ),
              ),
              GoRoute(
                  path: Paths.RESTAURANTDETAILS,
                  name: Routes.RESTAURANTDETAILS,
                  builder: (context, state) => BlocProvider.value(
                        value: serviceLocator<RestaurantDetailsCubit>(),
                        child: RestaurantDetailsView(
                          id: state.extra as String,
                        ),
                      ),
                  routes: [
                    GoRoute(
                        path: Paths.FOODCART,
                        name: Routes.FOODCART,
                        builder: (context, state) => BlocProvider.value(
                              value: serviceLocator<FoodCartCubit>(),
                              child: const FoodCartView(),
                            ))
                  ])
            ]),
        GoRoute(
          path: Paths.CONTACTUS,
          name: Routes.CONTACTUS,
          builder: (context, state) => BlocProvider<ContactUsCubit>(
            create: (_) => serviceLocator(),
            child: const ContactUsView(),
          ),
        ),
        GoRoute(
          path: Paths.SHIPPING,
          name: Routes.SHIPPING,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    serviceLocator<ShippingCubit>()..getBannerData(),
              ),
              BlocProvider(
                  create: (context) => serviceLocator<FavoriteShippingCubit>()),
              BlocProvider(
                  create: (context) => serviceLocator<CreateTripCubit>()),
              BlocProvider(
                  create: (context) => serviceLocator<CallMessageCubit>()),
              BlocProvider(create: (context) => serviceLocator<TripCubit>()),
              BlocProvider(
                  create: (context) =>
                      serviceLocator<GetAllRequestByMyTripCubit>()),
              BlocProvider(
                  create: (context) => serviceLocator<GetMyTripCubit>()),
            ],
            child: CreateShippingView(
              selectedId: state.extra as String?,
            ),
          ),
        ),
        GoRoute(
          path: Paths.DRIVERREQUESTS,
          name: Routes.DRIVERREQUESTS,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<GetAllTripCubit>(
                create: (context) => serviceLocator<GetAllTripCubit>(),
              ),
              BlocProvider(create: (context) => serviceLocator<TripCubit>()),
              BlocProvider(
                  create: (context) => serviceLocator<CallMessageCubit>()),
            ],
            child: const DriverRequests(),
          ),
        ),
        GoRoute(
          path: Paths.DASHBOARDDRIVERSCREEN,
          name: Routes.DASHBOARDDRIVERSCREEN,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<GetAllTripCubit>(
                create: (context) => serviceLocator<GetAllTripCubit>(),
              ),
              BlocProvider(create: (context) => serviceLocator<TripCubit>()),
              BlocProvider(
                  create: (context) => serviceLocator<CallMessageCubit>()),
            ],
            child: DahsboardDriverScreen(),
          ),
        ),
        GoRoute(
          path: Paths.DRIVERREQUESTSDETIALS,
          name: Routes.DRIVERREQUESTSDETIALS,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<GetAllTripCubit>(
                create: (context) => serviceLocator<GetAllTripCubit>(),
              ),
              BlocProvider(create: (context) => serviceLocator<TripCubit>()),
              BlocProvider(
                  create: (context) => serviceLocator<CallMessageCubit>()),
            ],
            child: RequestDetialsScreen(
              model: (state.extra as AllTripModel),
            ),
          ),
        ),
        GoRoute(
            path: Paths.RIDE,
            name: Routes.RIDE,
            builder: (context, state) => const RideRequestView(),
            routes: [
              GoRoute(
                  path: Paths.REQUESTSHISTORY,
                  name: Routes.REQUESTSHISTORY,
                  builder: (context, state) =>
                      BlocProvider<RequestHistoryCubit>(
                        create: (_) => serviceLocator(),
                        child: const HistoryRequestsView(),
                      )),
              GoRoute(
                  path: Paths.TRIPDETAILS,
                  name: Routes.TRIPDETAILS,
                  builder: (context, state) => BlocProvider<TripDetailsCubit>(
                        create: (_) => serviceLocator(),
                        child: const TripDetailsView(),
                      )),
              GoRoute(
                  path: Paths.RIDERDASHBOARD,
                  name: Routes.RIDERDASHBOARD,
                  builder: (context, state) =>
                      BlocProvider<DriverDashboardCubit>(
                        create: (_) => serviceLocator(),
                        child: const DriverDashboardView(),
                      ))
            ]),
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
            builder: (context, state) => BlocProvider<MeetingCubit>(
                  create: (context) => serviceLocator<MeetingCubit>(),
                  child: const MeetingView(),
                ),
            routes: [
              // PlayVideo
              GoRoute(
                path: Paths.MEETINGROOM,
                name: Routes.MEETINGROOM,
                builder: (context, state) {
                  final extras = state.extra as ZegoArgs;

                  return MeetingRoom(
                      liveID: extras.liveId, isHost: extras.isHost);
                },
              ),
            ]),
        GoRoute(
            path: Paths.INSTALLMENT,
            name: Routes.INSTALLMENT,
            builder: (context, state) => BlocProvider<InstallmentListCubit>(
                create: (_) => serviceLocator(),
                child: const InstallmentView()),
            routes: [
              GoRoute(
                path: Paths.INSTALLMENTDETAILS,
                name: Routes.INSTALLMENTDETAILS,
                builder: (context, state) =>
                    BlocProvider<InstallmentDetailsCubit>(
                        create: (_) => serviceLocator(),
                        child: InstallmentsDetails(
                          installmentId: state.extra as String,
                        )),
              ),
              // CreateInstallmentView
              GoRoute(
                path: Paths.CREATEINSTALLMENT,
                name: Routes.CREATEINSTALLMENT,
                builder: (context, state) =>
                    BlocProvider<CreateInstallmentCubit>(
                        create: (_) => serviceLocator(),
                        child: CreateInstallmentView(
                          adId: state.extra as String,
                        )),
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
        // ___________________ shipping ______________
        GoRoute(
          path: Paths.SHIPPING_REGISTER,
          name: Routes.SHIPPING_REGISTER,
          // builder: (context, state) => RegisterShippingScreen()
          builder: (context, state) => MultiBlocProvider(providers: [
            BlocProvider(
              create: (context) => serviceLocator<ShippingCubit>(),
            ),
            //to be reviewed
            BlocProvider(
              create: (context) => serviceLocator<CreateDoctorCubit>(),
            ),
            BlocProvider(
              create: (context) => serviceLocator<CreateTripCubit>(),
            ),
          ], child: const RegisterShippingScreen()),
        ),
      ],
    ),
  ]);
}