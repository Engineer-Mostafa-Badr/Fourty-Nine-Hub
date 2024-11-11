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
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/balance_wallet_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/gift_wallet_view.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/ad_details_view.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/cubit/ad_requests_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/pages/ad_requests_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/pages/create_ad.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/filter_ads.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/governorate_filter_ads.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/destination_location_carpool/cubit/map_box_dest_cubit_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_price_carpool/get_price_carpool_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/mapBox_cubit/cubit/map_box_cubit_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/views/add_new_route_view.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/views/carpool_view.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/presentation/cubits/cubit/create_car_pool_cubit.dart';
import 'package:fourtyninehub/features/food_feature/cusine_restaurants/presentation/cubit/cusine_restaurants_cubit.dart';
import 'package:fourtyninehub/features/food_feature/edit_food/presentation/cubit/edit_food_cubit.dart';
import 'package:fourtyninehub/features/food_feature/edit_food/presentation/pages/edit_food_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_dashboard_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_orders.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/create_resturant_view.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';
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
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/pages/requests_history_view.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_driver_type_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_all_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_expired_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_route_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/offer_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/picture_optional_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/raise_fare_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/select_cateogry_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/all_rider_trip_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/rider_register_view.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/shipping_rider_tab_screen.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/settings_view.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/driverStatistics_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_shipping_view.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/dahsboard_driver_screen.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/register_shipping_screen.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/trip_rating_screen.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/attachments_view.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/pages/broadcast_view.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/pages/see_all_broadcasts.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_profile/presentation/pages/chat_profile_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/camera_picker/camera_picker.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/chat_room_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/contacts_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/select_contacts_to_share_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/show_image_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/show_images_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/viewcontact_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/archived_chats_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/widgets/components/create_voice_room_sheet.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/pages/edit_profile_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instgram_view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_home_screen.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/music_reels.dart';
import 'package:fourtyninehub/features/social_media/snap/presentation/pages/snap_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/instagram_profile.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/pages/spotlight_view.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/be_star_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/subcategories_view.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_brand_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_model_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_year_type_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_location_cordinates_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_price_distance_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/publish_trip_join_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_year_type/fetch_car_year_type_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/publish_trip_join/publish_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/trip_join_view.dart';
import 'package:fourtyninehub/features/trip_join/notifications/presentation/views/request_trip_join_notification.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/get_request/get_request_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/pages/tripjoin_request_history_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/usecases/view_all_pick_me_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/cubits/view_all_pick_me/view_all_pick_me_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/request_trip_join_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/view_all_trip_join_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/request_trip_join_cubit/request_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/avaiable_trips_view.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/join_meeting_screen.dart';
import 'package:go_router/go_router.dart';

import '../features/account_taps/account/presentation/cubit/cubit/favourite_drawer_cubit.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_categories_cubit.dart';
import '../features/account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import '../features/account_taps/account/presentation/pages/favourite_category_view.dart';
import '../features/account_taps/account/presentation/pages/favourite_subcategory_view.dart';
import '../features/account_taps/lists/presentation/cubit/lists_cubit.dart';
import '../features/account_taps/my_adds/domain/entity/my_ads_auction.dart';
import '../features/account_taps/my_adds/presentation/pages/edit_my_ads.dart';
import '../features/account_taps/my_adds/presentation/pages/my_adds.dart';
import '../features/account_taps/policies/presentation/pages/policy_view.dart';
import '../features/account_taps/share_app/presentation/cubit/share_app_cubit.dart';
import '../features/account_taps/transfer_money/presentation/pages/transfer_money_view.dart';
import '../features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_cubit.dart';
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
import '../features/food_feature/food_cart/presentation/pages/restaurant_orders.dart';
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
import '../features/ride/driver_dashboard/presentation/cubit/driver_dashboard_cubit.dart';
import '../features/ride/driver_dashboard/presentation/pages/driver_dashboard_view.dart';
import '../features/ride/trip_details/presentation/cubit/trip_details_cubit.dart';
import '../features/ride/trip_details/presentation/pages/trip_details_view.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/accept_decline_trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/favorite_main_cateogry_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/favorite_shipping_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/get_all_request_by_my_trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/get_my_trip_cubit.dart';
import '../features/social_media/club_house/presentation/pages/audio_stream_screen.dart';
import '../features/social_media/club_house/presentation/pages/club_house_home_screen.dart';
import '../features/social_media/create_post/presentation/pages/create_post_view.dart';
import '../features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import '../features/social_media/social_posts/presentation/pages/Social_home.dart';
import '../features/social_media/social_posts/presentation/pages/other_account_view.dart';
import '../features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import '../features/subcategories/presentation/cubit/subcategories_cubit.dart';
import '../features/youtube/presentation/pages/play_video.dart';
import '../features/youtube/presentation/pages/youtube.dart';
import '../features/zoom/presentation/pages/meeting_room.dart';
import '../features/zoom/presentation/pages/meeting_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'routes.dart';

class AppPages {
  AppPages._();

  static final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: Routes.HOME,
        builder: (context, state) =>
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => serviceLocator<SliderCubit>(),
                ),
                BlocProvider(
                  create: (context) => serviceLocator<ThumbnailsCubit>(),
                ),
              ],
              child: const FourtyNineView(),
            ),
        routes: <RouteBase>[
          GoRoute(
            path: Paths.RestaurantDashboard,
            name: Routes.RestaurantDashboard,
            routes:[
              GoRoute(
                path: Paths.RestaurantOrders,
                name: Routes.RestaurantOrders,
                builder: (context, state) =>
                    BlocProvider(
                        create: (context) => serviceLocator<RestaurantDashboardCubit>(),
                        child: const RestaurantDashboardOrders()),
              ),
            ],
            builder: (context, state) =>
                BlocProvider(
                    create: (context) => serviceLocator<RestaurantDashboardCubit>()..initialize(),
                    child: RestaurantDashboardView(payload: state.extra)),
          ),
          GoRoute(
            path: Paths.RESTAURANTORDERS,
            name: Routes.RESTAURANTORDERS,
            builder: (context, state) => const RestaurantOrders(),
          ),
          GoRoute(
            path: Paths.EditFoodView,
            name: Routes.EditFoodView,
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: RestaurantMenuCubit(serviceLocator()),
                ),
                BlocProvider<CreateRestaurantCubit>.value(
                  value: serviceLocator()..loadData(),
                ),
                BlocProvider(
                  create: (context)=>serviceLocator<EditFoodCubit>(),
                )
              ],
              child: EditFoodView(payload: state.extra,),
            ),
          ),
          // FLIP CARDS
          GoRoute(
            path: Paths.MAINCATEGORIESCARDS,
            name: Routes.MAINCATEGORIESCARDS,
            builder: (context, state) => const MainCategoriesFlipCardsView(),
          ),
          GoRoute(
            path: Paths.CONTACTS_VIEW,
            name: Routes.CONTACTSVIEW,
            builder: (context, state) =>
                ContactsView(
                  contactsViewParams: state.extra as ContactsViewParams,
                ),

          ),
          GoRoute(
            path: Paths.ARCHIVEDCHATS,
            name: Routes.ARCHIVEDCHATS,
            builder: (context, state) =>
                OptionsChatsView(
                  params: state.extra as OptionsChatsViewParams,
                ),
          ),
          GoRoute(
            path: Paths.BROADCAST,
            name: Routes.BROADCAST,
            builder: (context, state) => const BroadcastView(),
          ),
          GoRoute(
            path: Paths.IMAGESPAGEVIEW,
            name: Routes.IMAGESPAGEVIEW,
            builder: (context, state) =>
                ImagesPageView(
                  params: state.extra as ImagesPageViewParams,
                ),
          ),
          GoRoute(
            path: Paths.SHOWIMAGESVIEW,
            name: Routes.SHOWIMAGEVIEW,
            builder: (context, state) =>
                ShowImagesView(
                  messageEntity: state.extra as MessageEntity,
                ),
          ),
          GoRoute(
            path: Paths.SEEALLBROADCASTS,
            name: Routes.SEEALLBROADCASTS,
            builder: (context, state) => const SeeAllBroadcasts(),
          ),
          GoRoute(
            path: Paths.CHATPROFILEVIEW,
            name: Routes.CHATPROFILEVIEW,
            builder: (context, state) => const ChatProfileView(),
          ),
          //GRID VIEW
          GoRoute(
            path: Paths.MAINCATEGORIESTREE,
            name: Routes.MAINCATEGORIESTREE,
            builder: (context, state) =>
                BlocProvider(
                    create: (context) =>
                        serviceLocator<MainCategoriesTapsCubit>(),
                    child: const MainCategoriesGridView()),
          ),
          GoRoute(
              path: Paths.SUBCATEGORIES,
              name: Routes.SUBCATEGORIES,
              builder: (context, state) =>
                  BlocProvider.value(
                    value: serviceLocator<SubcategoriesCubit>(),
                    child: SubCategoriesView(
                      mainCategory: state.extra as MainCategoryEntity,
                    ),
                  ),
              routes: [
                GoRoute(
                    path: Paths.ADS,
                    name: Routes.ADS,
                    builder: (context, state) =>
                        BlocProvider(
                          create: (_) => serviceLocator<AdvertisementCubit>(),
                          child: AdsView(
                            params: state.extra as AdsViewParams,
                          ),
                        ),
                    routes: [
                      GoRoute(
                          path: Paths.ADdetails,
                          name: Routes.ADdetails,
                          routes: [
                            GoRoute(
                                path: Paths.ADRequests,
                                name: Routes.ADRequests,
                                builder: (context, state) =>
                                    BlocProvider<AdRequestsCubit>(
                                      create: (_) => serviceLocator(),
                                      child:
                                      AdRequestsView(payload: state.extra),
                                    ))
                          ],
                          builder: (context, state) =>
                              BlocProvider<AdDetailsCubit>(
                                create: (_) => serviceLocator(),
                                child:
                                AdDetailsView(payload: state.extra),
                              )),
                      GoRoute(
                        path: Paths.CREATEAD,
                        name: Routes.CREATEAD,
                        builder: (context, state) =>
                            BlocProvider.value(
                                value: serviceLocator<CreateAdCubit>(),
                                child: CreateAdView(

                                  categorization:
                                  state.extra as CategorizationEntity,
                                )),
                      ),
                      GoRoute(
                        path: Paths.FILTERADS,
                        name: Routes.FILTERADS,
                        builder: (context, state) =>
                            BlocProvider.value(
                                value: serviceLocator<CreateAdCubit>(),
                                child: FilterAdsView(
                                  categorization:
                                  state.extra as CategorizationEntity,
                                )),
                      ),
                      GoRoute(
                        path: Paths.GOVERNORATEFILTERADS,
                        name: Routes.GOVERNORATEFILTERADS,
                        builder: (context, state) =>
                            BlocProvider.value(
                                value: serviceLocator<CreateAdCubit>(),
                                child: GovernorateFilterAdsView(
                                  categorization: state
                                      .extra as CategorizationEntity,
                                )),
                      ),
                      // CreateCompanyAdView
                      GoRoute(
                        path: Paths.CREATECOMPANYAD,
                        name: Routes.CREATECOMPANYAD,
                        builder: (context, state) =>
                            BlocProvider<CreateCompanyAdCubit>(
                                create: (_) => serviceLocator()..loadData(),
                                child: const CreateCompanyAdView()),
                      ),
                    ]),
              ]),
          GoRoute(
            name: Routes.LOGIN,
            path: Paths.LOGIN,
            builder: (context, state) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => serviceLocator<LoginCubit>(),
                    ),
                    BlocProvider(
                      create: (_) => serviceLocator<GetWalletCubit>(),
                    ),
                    BlocProvider(
                      create: (_) => serviceLocator<UserCubit>(),
                    ),
                    BlocProvider(
                      create: (_) => serviceLocator<RegisterCubit>(),
                    ),
                    BlocProvider(
                      create: (_) =>
                      serviceLocator<WalletCubit>()
                        ..loadData(),
                    ),
                    BlocProvider(
                      create: (_) =>
                      serviceLocator<GiftCubit>()
                        ..loadData(),
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
            builder: (context, state) =>
                BlocProvider<ForgotPasswordCubit>(
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
            builder: (context, state) =>
                MultiBlocProvider(
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
                builder: (context, state) =>
                    BlocProvider<VerifyOtpCubit>(
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
                builder: (context, state) =>
                    BlocProvider<DriverRegisterCubit>(
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
            builder: (context, state) =>
                MultiBlocProvider(
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
            builder: (context, state) =>
            const CompetitionView(
              list: [],
            ),
            routes: const [],
          ),
          // PaymentView
          GoRoute(
            name: Routes.PAYMENT,
            path: Paths.PAYMENT,
            builder: (context, state) {
              final args = state.extra as PaymobLink;

              return BlocProvider(
                create: (context) {
                  return serviceLocator<PaymentCubit>()
                    ..getPaymentProvider()
                    ..getSavedCards();
                  // ..getPaymobData(
                  //     amountId: args.amountId,
                  //     providerId: args.providerId
                  // );
                  // ..chargeWithCard(
                  //   cardNumber: params.cardNumber,
                  //   cardExpiryYear: params.cardExpiryYear,
                  //   cardExpiryMonth: params.cardExpiryMonth,
                  //   cvv: params.cvv,
                  //   amountId: params.amountId,
                  //   providerId: params.providerId,
                  //   paymentMethod: params.paymentMethod,
                  // );
                },
                child: PaymentView(
                  amountId: args.amountId,
                  // providerId: args.providerId,
                  amount: args.amount,
                ),
              );
            },
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
            builder: (context, state) => BlocProvider<QuranCubit>(
                create: (_) => serviceLocator(),child: const QuraanView()),
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
              builder: (context, state) =>
                  BlocProvider<WalletCubit>(
                    create: (_) => serviceLocator(),
                    child: const WalletView(
                      // type: state.extra as WalletTypes,
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
              path: Paths.BALANCE,
              name: Routes.BALANCE,
              builder: (context, state) =>
                  BlocProvider<WalletCubit>(
                    create: (_) => serviceLocator(),
                    child: const BalanceWalletView(),
                  ),
              ),
          GoRoute(
            path: Paths.GIFT,
            name: Routes.GIFT,
            builder: (context, state) =>
                BlocProvider<WalletCubit>(
                  create: (_) => serviceLocator(),
                  child: const GiftWalletView(),
                ),
          ),

          GoRoute(
              path: Paths.ACCOUNT,
              name: Routes.ACCOUNT,
              builder: (context, state) => const NotificationView(),
              routes: [
                GoRoute(
                  path: Paths.NOTIFICATIONS,
                  name: Routes.NOTIFICATIONS,
                  builder: (context, state) => const NotificationView(),
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
                    builder: (context, state) =>
                        BlocProvider<ListsCubit>(
                          create: (_) => serviceLocator()..loadFriends(''),
                          child: const ListsView(),
                        )),
                GoRoute(
                    path: Paths.SHAREAPP,
                    name: Routes.SHAREAPP,
                    //
                    builder: (context, state) =>
                        BlocProvider<ShareAppCubit>(
                          create: (_) => serviceLocator(),
                          child: const ShareTheApp(),
                        )),
                GoRoute(
                    path: Paths.FAVOURITE,
                    name: Routes.FAVOURITE,
                    builder: (context, state) => BlocProvider.value(
                        value: serviceLocator<FavouriteDrawerCubit>(),
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
                        child: const FavSubCategoryView(),
                      ),
                ),
                GoRoute(
                    path: Paths.MYADDS,
                    name: Routes.MYADDS,
                    routes: [
                      GoRoute(
                          path: Paths.EDITAD,
                          name: Routes.EDITAD,
                          builder: (context, state) =>
                              BlocProvider<CreateAdCubit>(
                                create: (_) => serviceLocator(),
                                child: EditMyAds(
                                  categorization:
                                      state.extra as MyAuctionAdsEntity,
                                ),
                              ))
                    ],
                    builder: (context, state) =>
                        BlocProvider<MyAddsCubit>(
                          create: (_) => serviceLocator(),
                          child: const MyAddsView(),
                        )),
              ]),

          GoRoute(
            path: Paths.INSTAGRAM,
            name: Routes.INSTAGRAM,
            routes: [
              GoRoute(
                path: Paths.INSTAGRAMPROFILE,
                name: Routes.INSTAGRAMPROFILE,
                routes: const [],
                builder: (context, state) {
                  final id = state.extra as String?;

                  return BlocProvider<SocialPostsCubit>(
                    create: (_) =>
                        serviceLocator()..getUserProfile(id: id ?? ''),
                    child: InstagramProfile(userId: id ?? ''),
                  );
                },
              ),
            ],
            builder: (context, state) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                  create: (context) =>
                      serviceLocator<InstagramCubit>()..loadData(),
                    ),
                    BlocProvider(
                      create: (context) => serviceLocator<StoryCubit>(),
                    ),
                  ],
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
                          return serviceLocator()
                            ..loadData();
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
                    builder: (context, state) => const TwitterView(),
                    routes: const []),
                GoRoute(
                    path: Paths.OTHERSACCOUNT,
                    name: Routes.OTHERSACCOUNT,
                    builder: (context, state) {
                      final id = state.extra as String?;
                      return BlocProvider<SocialPostsCubit>(
                          create: (_) =>
                              serviceLocator()..getUserProfile(id: id ?? ''),
                          child: OtherAccountView(
                            payload: state.extra,
                          ));
                    },
                    routes: [
                      GoRoute(
                        path: Paths.EDITPROFILE,
                        name: Routes.EDITPROFILE,
                        builder: (context, state) =>
                            BlocProvider<EditProfileCubit>(
                                create: (_) => serviceLocator(),
                                child: const EditProfileView()),
                      ),
                    ]),
                GoRoute(
                    path: Paths.REELS,
                    name: Routes.REELS,
                    builder: (context, state) =>
                        const ReelView(),
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
                    builder: (context, state) =>
                        MultiBlocProvider(
                          providers: [
                            //club voice
                            BlocProvider<ClubVoiceCubit>(
                              create: (context) => serviceLocator()..loadData(),
                              child: const ClubHouseHome(),
                            ),
                          ],
                          child: const LiveStreamHomeScreen(),
                        ),
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

                      // ClubHouseHome

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
                  builder: (context, state) =>
                      BlocProvider<AuctionDetailsCubit>(
                        create: (_) => serviceLocator(),
                        child: MazadDetails(id: state.extra as String),
                      ),
                ),
                // CreateAuctionView
                GoRoute(
                    path: Paths.CREATEAUCTION,
                    name: Routes.CREATEAUCTION,
                    builder: (context, state) =>
                        BlocProvider.value(
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
            builder: (context, state) =>
                BlocProvider<ChatsCubit>(
                  create: (_) => serviceLocator(),
                  child: const ChatView(),
                ),
          ),

          // Chat Room
          GoRoute(
              path: Paths.CHATROOM,
              name: Routes.CHATROOM,
              builder: (context, state) =>
                  ChatRoomView(chatsCubit: state.extra as ChatsCubit),
              routes: [
                GoRoute(
                  path: Paths.CHATROOMCAMERAPICKER,
                  name: Routes.CHATROOMCAMERAPICKER,
                  builder: (context, state) => CameraPickerView(
                    prams: state.extra as CameraPickerViewPrams,
                  ),
                ),
                GoRoute(
                  path: Paths.MEDIASLIDER,
                  name: Routes.MEDIASLIDER,
                  builder: (context, state) => MediaSliderView(
                      chatRoomCubit: (state.extra) as ChatRoomCubit),
                ),
                GoRoute(
                  path: Paths.VIEWCONTACT,
                  name: Routes.VIEWCONTACT,
                  builder: (context, state) =>
                      ViewContactView(
                        sender: state.extra as String,
                      ),
                ),
                GoRoute(
                  path: Paths.ATTACHMENTSVIEW,
                  name: Routes.ATTACHMENTSVIEW,
                  builder: (context, state) => AttachementsView(
                    chatRoomCubit: state.extra as ChatRoomCubit,
                  ),
                ),
                GoRoute(
                  path: Paths.SELECTCONTACTSTOSHARE,
                  name: Routes.SELECTCONTACTSTOSHARE,
                  builder: (context, state) => SelectContactsToShareView(
                    chatRoomCubit: state.extra as ChatRoomCubit,
                  ),
                ),
              ]),
          // Snap

          GoRoute(
              path: Paths.SNAP,
              name: Routes.SNAP,
              builder: (context, state) => const SnapView()),
          // Spotlight
          GoRoute(
              path: Paths.SPOTLIGHT,
              name: Routes.SPOTLIGHT,
              builder: (context, state) =>
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          create: (context) => serviceLocator<ReelsCubit>()),
                      BlocProvider<StoryCubit>(
                        create: (_) => serviceLocator<StoryCubit>(),
                      ),
                    ],
                    child: const SpotlightView(),
                  )),
          // _________________ services ____________

          GoRoute(
              path: Paths.VISITA,
              name: Routes.VISITA,
              builder: (context, state) {
                return BlocProvider<HealthCubit>(
                  create: (_) => serviceLocator<HealthCubit>()..loadData(),
                  child: const HealthView(),
                );
              },
              routes: [
                GoRoute(
                  path: Paths.CREATERESTURANT,
                  name: Routes.CREATERESTURANT,
                  builder: (context, state) =>
                      BlocProvider<CreateResturantCubit>(
                        create: (context) => serviceLocator(),
                        child: const CreateResturantView(),
                      ),
                ),
                GoRoute(
                  path: Paths.VISITAEMERGENCY,
                  name: Routes.VISITAEMERGENCY,
                  builder: (context, state) =>
                      BlocProvider<HealthEmergencyCubit>(
                        create: (context) => serviceLocator(),
                        child: const HealthEmergencyView(),
                      ),
                ),
                GoRoute(
                  path: Paths.CREATEDOCTOR,
                  name: Routes.CREATEDOCTOR,
                  builder: (context, state) =>
                      BlocProvider<CreateDoctorCubit>(
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
                  builder: (context, state) =>
                      BlocProvider<DoctorsListCubit>(
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
              builder: (context, state) =>
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<RestaurantsCubit>(
                        create: (context) =>
                        serviceLocator()
                          ..loadData(),
                      ),
                    ],
                    child: const RestaurantsListsView(),
                  ),
              routes: [
                // CusineRestaurantsView
                // GoRoute(
                //   path: Paths.RestaurantDashboard,
                //   name: Routes.RestaurantDashboard,
                //   builder: (context, state) =>
                //       BlocProvider<RestaurantDashboardCubit>(
                //     create: (_) => serviceLocator(),
                //     child:  RestaurantDashboardView(),
                //   ),
                // ),
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
                    builder: (context, state) =>
                        BlocProvider(
                          create:(context)=> serviceLocator<RestaurantDetailsCubit>(),
                          child: RestaurantDetailsView(
                            restaurant: state.extra as Restaurant,
                          ),
                        ),
                    routes: [
                      GoRoute(
                          path: Paths.FOODCART,
                          name: Routes.FOODCART,
                          builder: (context, state) =>
                              BlocProvider.value(
                                value: serviceLocator<RestaurantDetailsCubit>(),
                                child: const FoodCartView(),
                              ))
                    ])
              ]),
          GoRoute(
            path: Paths.CONTACTUS,
            name: Routes.CONTACTUS,
            builder: (context, state) =>
                BlocProvider<ContactUsCubit>(
                  create: (_) => serviceLocator(),
                  child: const ContactUsView(),
                ),
          ),
          GoRoute(
            path: Paths.SHIPPING,
            name: Routes.SHIPPING,
            builder: (context, state) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider<ShippingCubit>(
                      create: (context) =>
                      serviceLocator<ShippingCubit>()..getBannerData(),
                    ),
                    BlocProvider<GetMyTripCubit>(
                      create: (context) =>
                      serviceLocator<GetMyTripCubit>()..getMyTrip(),
                    ),
                    BlocProvider<CreateTripCubit>(
                      create: (context) => serviceLocator<CreateTripCubit>(),
                    ),
                    BlocProvider<GetAllRequestByMyTripCubit>(
                      create: (context) =>
                          serviceLocator<GetAllRequestByMyTripCubit>(),
                    ),
                    BlocProvider<CallMessageCubit>(
                      create: (context) => serviceLocator<CallMessageCubit>(),
                    ),
                    BlocProvider<AcceptDeclineTripCubit>(
                      create: (context) =>
                          serviceLocator<AcceptDeclineTripCubit>(),
                    ),
                    BlocProvider<FavoriteMainCateogryCubit>(
                      create: (context) =>
                          serviceLocator<FavoriteMainCateogryCubit>(),
                    ),
                    BlocProvider<FavoriteShippingCubit>(
                      create: (context) =>
                          serviceLocator<FavoriteShippingCubit>(),
                    ),
                    BlocProvider<TwitterCubit>(
                      create: (context) => serviceLocator<TwitterCubit>(),
                    ),
                  ],
                  child: const CreateShippingView(),
                ),
          ),
          GoRoute(
              path: Paths.RIDE,
              name: Routes.RIDE,
              builder: (context, state) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          serviceLocator<GetCateogryRiderCubit>(),
                    ),
                    BlocProvider(
                      create: (context) => serviceLocator<RegisterRiderCubit>(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          serviceLocator<FavoriteMainCateogryCubit>(),
                    ),
                    BlocProvider(
                        create: (context) =>
                            serviceLocator<RiderTripReelTimeCubit>()),
                    BlocProvider(
                        create: (context) =>
                            serviceLocator<RiderTripReelTimeCubit>()),
                    BlocProvider(
                      create: (context) =>
                          GetTripInfoCubit(repository: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          GetTripInfoCubit(repository: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) => StartingLocationCubit(
                              fetchLocationCordinatesUseCase: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          FetchPriceDistanceCubit(
                              fetchPriceDistanceUsecase: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          FavoriteShippingCubit(repository: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          FavoriteShippingCubit(repository: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          LocationSocketCubit(repository: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          RequestRiderTripCubit(repository: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          RaiseFareCubit(repository: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          OfferCubit(repository: serviceLocator()),
                    ),
                    BlocProvider<ShippingCubit>(
                      create: (context) =>
                      serviceLocator<ShippingCubit>()
                        ..getBannerData(),
                    ),
                    BlocProvider<GetMyTripCubit>(
                      create: (context) =>
                      serviceLocator<GetMyTripCubit>()
                        ..getMyTrip(),
                    ),
                    BlocProvider<CreateTripCubit>(
                      create: (context) => serviceLocator<CreateTripCubit>(),
                    ),
                    BlocProvider<GetAllRequestByMyTripCubit>(
                      create: (context) =>
                          serviceLocator<GetAllRequestByMyTripCubit>(),
                    ),
                    BlocProvider<CallMessageCubit>(
                      create: (context) => serviceLocator<CallMessageCubit>(),
                    ),
                    BlocProvider<AcceptDeclineTripCubit>(
                      create: (context) =>
                          serviceLocator<AcceptDeclineTripCubit>(),
                    ),
                    BlocProvider<FavoriteMainCateogryCubit>(
                      create: (context) =>
                          serviceLocator<FavoriteMainCateogryCubit>(),
                    ),
                    BlocProvider<FavoriteShippingCubit>(
                      create: (context) =>
                          serviceLocator<FavoriteShippingCubit>(),
                    ),
                    BlocProvider<TwitterCubit>(
                      create: (context) => serviceLocator<TwitterCubit>(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          CheckDriverTypeCubit(repository: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          DestinationLocationCubit(fetchLocationCordinatesUseCase: serviceLocator()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          MapBoxCubit(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          MapBoxDestCubit(),
                    ),
                    BlocProvider(
                      create: (context) =>
                          SelectCateogryCubit(),
                    ),
                  ],
                  child: const ShippingRiderTabScreen(),
                );
              },
              routes: [
                GoRoute(
                    path: Paths.ALLTRIPRIDER,
                    name: Routes.ALLTRIPRIDER,
                    builder: (context, state) => MultiBlocProvider(providers: [
                          BlocProvider(
                            create: (context) => GetExpiredTripCubit(
                                repository: serviceLocator())
                              ..get(),
                          ),
                          BlocProvider(
                            create: (context) => GetAllTripRiderCubit(
                                repository: serviceLocator())
                              ..getAllTrip(),
                          ),
                          BlocProvider(
                            create: (context) => GetRouteRiderCubit(
                                repository: serviceLocator()),
                          ),
                        ], child: const AllRiderTripScreen())
                    // BlocProvider(
                    //   create: (_) => GetAllTripRiderCubit(repository: serviceLocator())..getAllTrip(),
                    //   child: const AllRiderTripScreen(),
                    // )
                    ),
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
                    builder: (context, state) =>
                        BlocProvider<TripDetailsCubit>(
                          create: (_) => serviceLocator(),
                          child: const TripDetailsView(),
                        )),
                GoRoute(
                    path: Paths.RIDERDASHBOARD,
                    name: Routes.RIDERDASHBOARD,
                    builder: (context, state) =>
                        MultiBlocProvider(
                          providers: [
                            BlocProvider<DriverDashboardCubit>(
                              create: (_) => serviceLocator(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  DriverStatisticsCubit(
                                      repository: serviceLocator()),
                            ),
                          ],
                          child: const DriverDashboardView(),
                        )),
                GoRoute(
                    path: Paths.RIDERREGISTER,
                    name: Routes.RIDERREGISTER,
                    builder: (context, state) =>
                        MultiBlocProvider(
                          providers: [
                            BlocProvider<DriverDashboardCubit>(
                              create: (_) => serviceLocator(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  RegisterRiderCubit(
                                      repo: serviceLocator(),
                                      repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<GetCateogryRiderCubit>(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<FetchCarBrandsCubit>(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<FetchCarModelsCubit>(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<FetchCarYearTypeCubit>(),
                            ),
                            BlocProvider(
                              create: (context) =>
                              PictureOptionalCubit(
                                  repository: serviceLocator())
                                ..getData(),
                            ),
                          ],
                          child: const RiderRegisterView(),
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
              builder: (context, state) =>
                  BlocProvider<StreamCubit>(
                    create: (context) =>
                        serviceLocator<StreamCubit>()..getScheduledMeetings(),
                    child: const MeetingView(),
                  ),
              // create: (context) => serviceLocator<StreamCubit>()..getScheduledMeetings(),
              // child: const MeetingView(),

              routes: [
                // PlayVideo
                GoRoute(
                  path: Paths.MEETINGROOM,
                  name: Routes.MEETINGROOM,
                  builder: (context, state) {
                    final extras = state.extra as ZegoArgs;

                    return MeetingRoom(
                      liveID: extras.liveId,
                      isHost: extras.isHost,
                      shareScreen: extras.shareScreen,
                      userName: extras.userName,
                    );
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
            builder: (context, state) =>
                MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => serviceLocator<ShippingCubit>(),
                  ),
                  //to be reviewed
                  BlocProvider(
                    create: (context) => serviceLocator<CreateDoctorCubit>(),
                  ),
            ], child: const RegisterShippingScreen()),
          ),
          GoRoute(
              path: Paths.DASHBOARDDRIVERSCREEN,
              name: Routes.DASHBOARDDRIVERSCREEN,
              builder: (context, state) => MultiBlocProvider(
                    providers: [
                      BlocProvider<RequestHistoryCubit>(
                        create: (_) => serviceLocator(),
                      ),
                      BlocProvider(
                        create: (context) => GetAllTripCubit(repository: serviceLocator()),
                      ),
                      BlocProvider(
                        create: (context) => CallMessageCubit(repository: serviceLocator()),
                      ),
                      BlocProvider(
                        create: (context) => TripCubit(repository: serviceLocator()),
                      ),
                    ],
                    child: const DahsboardDriverScreen(),
                  )),
            GoRoute(
              path: Paths.TripRating,
              name: Routes.TripRating,
              builder: (context, state) => MultiBlocProvider(
                    providers: [
                      BlocProvider<RequestHistoryCubit>(
                        create: (_) => serviceLocator(),
                      ),
                      BlocProvider(
                        create: (context) => GetAllTripCubit(repository: serviceLocator()),
                      ),
                      BlocProvider(
                        create: (context) => CallMessageCubit(repository: serviceLocator()),
                      ),
                      BlocProvider(
                        create: (context) => TripCubit(repository: serviceLocator()),
                      ),
                    ],
                    child: TripRatingScreen(model: state.extra as GetRequestsForLoadingModel),
                  )),
          // Be a Star
          GoRoute(
            path: Paths.BE_STAR,
            name: Routes.BE_STAR,
            builder: (context, state) {
              return const BeStarView();
            },
          ),
          // ___________________ trip join ______________
          GoRoute(
            path: Paths.TRIP_JOIN,
            name: Routes.TRIP_JOIN,
            builder: (context, state) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          StartingLocationCubit(
                    fetchLocationCordinatesUseCase:
                        serviceLocator<FetchLocationCordinatesUseCase>(),
                          ),
                    ),
                    BlocProvider(
                      create: (_) =>
                          DestinationLocationCubit(
                    fetchLocationCordinatesUseCase:
                        serviceLocator<FetchLocationCordinatesUseCase>(),
                          ),
                    ),
                    BlocProvider(
                      create: (_) =>
                          FetchPriceDistanceCubit(
                    fetchPriceDistanceUsecase:
                        serviceLocator<FetchPriceDistanceUsecase>(),
                          ),
                    ),
                    BlocProvider(
                      create: (_) =>
                          FetchCarBrandsCubit(
                    fetchCarBrandUseCase:
                        serviceLocator<FetchCarBrandUseCase>(),
                          ),
                    ),
                    BlocProvider(
                      create: (_) =>
                          FetchCarModelsCubit(
                    fetchCarModelUseCase:
                        serviceLocator<FetchCarModelUseCase>(),
                          ),
                    ),
                    BlocProvider(
                      create: (_) =>
                          FetchCarYearTypeCubit(
                    fetchCarYearTypeUseCase:
                        serviceLocator<FetchCarYearTypeUseCase>(),
                  ),
                ),
                BlocProvider(
                  create: (_) => MapBoxCubit(),
                ),
                BlocProvider(
                  create: (_) => PublishTripJoinCubit(
                    publishTripJoinUseCase:
                        serviceLocator<PublishTripJoinUseCase>(),
                          ),
                    ),
                    BlocProvider(create: (_) => TripJoinViewCubit()),
                  ],
                  child: const TripJoinView(),
                ),
          ),
          // ___________________ Available Trips ______________
          GoRoute(
            path: Paths.AVAILABLE_TRIPS,
            name: Routes.AVAILABLE_TRIPS,
            builder: (context, state) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          ViewAllTripJoinCubit(
                    viewAllTripJoinUseCase:
                        serviceLocator<ViewAllTripJoinUseCase>(),
                          ),
                    ),
                    BlocProvider(
                      create: (_) =>
                          RequestTripJoinCubit(
                    requestTripJoinUseCase:
                        serviceLocator<RequstTripJoinUseCase>(),
                          ),
                    ),
                    BlocProvider(
                      create: (_) =>
                          ViewAllPickMeCubit(
                    viewAllPickMeUseCase:
                        serviceLocator<ViewAllPickMeUseCase>(),
                          ),
                    ),
                  ],
                  child: const AvailableTripsView(),
                ),
          ),
          GoRoute(
            path: Paths.TRIP_JOIN_REQUEST_NOTIFICATIONS,
            name: Routes.TRIP_JOIN_REQUEST_NOTIFICATIONS,
            builder: (context, state) {
              return RequestTripJoinNotificationView(
                  payload: state.extra! as Map<String, dynamic>);
            },
          ),
          GoRoute(
            path: Paths.TRIP_JOIN_REQUEST_HISTORY,
            name: Routes.TRIP_JOIN_REQUEST_HISTORY,
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<GetRequestCubit>(
                    create: (context) =>
                        GetRequestCubit(getRequestUsecase: serviceLocator()),
                  ),
                ],
                child: TripJoinRequestHistoryView(
                    extra: state.extra! as Map<String, dynamic>),
              );
            },
          ),
          GoRoute(
            path: Paths.CAR_POOL,
            name: Routes.CAR_POOL,
            builder: (context, state) {
              return MultiBlocProvider(providers: [
                BlocProvider<GetAllTripsCubit>(
                  create: (context) => GetAllTripsCubit(serviceLocator()),
                ),
                BlocProvider<GetCurrencyCubit>(
                  create: (context) => GetCurrencyCubit(serviceLocator()),
                ),
              ], child: const CarPoolView());
            },
          ),
          GoRoute(
            path: Paths.ADD_NEW_ROUTE,
            name: Routes.ADD_NEW_ROUTE,
            builder: (context, state) {
              return MultiBlocProvider(providers: [
                BlocProvider<StartingLocationCubit>(
                  create: (context) => StartingLocationCubit(
                      fetchLocationCordinatesUseCase: serviceLocator()),
                ),
                BlocProvider<DestinationLocationCubit>(
                  create: (context) => DestinationLocationCubit(
                      fetchLocationCordinatesUseCase: serviceLocator()),
                ),

                BlocProvider<GetPriceCarpoolCubit>(
                  create: (context) => GetPriceCarpoolCubit(
                      getPriceCarpoolUsecase: serviceLocator()),
                ),
                BlocProvider<GetAllTripsCubit>(
                  create: (context) => GetAllTripsCubit(serviceLocator()),
                ),
                BlocProvider<CreateCarPoolCubit>(
                  create: (context) => CreateCarPoolCubit(
                    createCarpoolUsecase: serviceLocator(),
                  ),
                ),
                BlocProvider<MapBoxDestCubit>(
                  create: (context) => MapBoxDestCubit(),
                ),
                BlocProvider<GetAllTripsCubit>(
                  create: (context) => GetAllTripsCubit(serviceLocator()),
                ),
                BlocProvider<GetCurrencyCubit>(
                  create: (context) => GetCurrencyCubit(
                    serviceLocator(),
                  ),
                ),
                BlocProvider<MapBoxCubit>(
                  create: (context) => MapBoxCubit(),
                ),
              ], child: const AddNewRouteView());
            },
          ),
        ],
      ),
    ],
  );
}
