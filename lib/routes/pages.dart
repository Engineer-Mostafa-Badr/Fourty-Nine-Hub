import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/before_splash.dart';
import 'package:fourtyninehub/core/widget/splash_screen.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/trip_receipt.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/ride_register/ride_register_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/creminal_record_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/drug_analysis.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/technical_examination_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/activity_trip_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/complete_ride_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/expired_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/history_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/rating_driver_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_arrived_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_history_details_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/running_trips_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/emergency_contacts_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_client_details_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_ride_screen.dart';
import 'package:fourtyninehub/features/account_taps/account/presentation/pages/favourite_view.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/presentation/cubit/contact_us_cubit.dart';
import 'package:fourtyninehub/features/account_taps/contact_us/presentation/pages/contact_us_view.dart';
import 'package:fourtyninehub/features/account_taps/lists/presentation/pages/lists_view.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/pages/privacy_view.dart';
import 'package:fourtyninehub/features/account_taps/share_app/presentation/pages/share_the_app.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/winners_cashback_cubit/winners_cashback_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/winners_gift_cubit/winners_gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/balance_wallet_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/cashback_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/gift_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/winners_gift_view.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/cubit/ad_requests_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/marriage_ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/pages/create_ad.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/create_company_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/create_post_reel_company.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/create_posts_company.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/filter_ads.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/governorate_filter_ads.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/register_cubit/register_cubit.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_cubit.dart';
import 'package:fourtyninehub/features/azkaar/presentation/pages/azkar_details.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/destination_location_carpool/cubit/map_box_dest_cubit_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/cubit/dest_get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_price_carpool/get_price_carpool_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/here_cubit/cubit/here_location_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/mapBox_cubit/cubit/map_box_cubit_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/verify_complet_driver/cubit/verify_complete_driver_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/views/add_new_route_view.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/accept_trip/cubit/accept_trip_for_driver_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_available_trips_for_drivers/cubit/get_available_trips_for_drivers_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/views/carpool_view.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/presentation/cubits/cubit/create_car_pool_cubit.dart';
import 'package:fourtyninehub/features/carpool/join_trip/presentation/cubits/cubit/join_trip_car_pool_cubit.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/pages/chance_view.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/custom_page.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/page_preview.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/cusine_restaurants/presentation/cubit/cusine_restaurants_cubit.dart';
import 'package:fourtyninehub/features/food_feature/edit_food/presentation/cubit/edit_food_cubit.dart';
import 'package:fourtyninehub/features/food_feature/edit_food/presentation/pages/edit_food_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_dashboard_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/create_resturant_view.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/slider_cubit.dart/slider_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/pages/home_page.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/all_appointments_cubit/all_appointments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/pages/all_appointments_screen.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/pages/create_doctor_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/all_doctor_reservations/all_doctor_reservations_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_statistics/doctor_statistics_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_today_appointments/doctor_today_appointments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_unhandled_appotinments/doctor_unhandled_appotinments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_personal_info/edit_doctor_personal_info_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_timetable/edit_doctor_timetable_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/all_doctor_reservations_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/doctor_dashboard_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/doctor_statistics.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/edit_doctor_personal_info_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/edit_doctor_profile.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/edit_doctor_timetable_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/today_doctor_appointments_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/unhandled_doctor_appointments_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/time_table_options_checkbox.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/pages/all_reviews.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/city_filter_cubit/doctor_city_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/governorate_filter_cubit/doctor_governorate_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/citiy_filter_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/governorate_filter_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/subcategory_filter_view.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_requests_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/pages/emergency_requests_view.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/pages/emergnce_view.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/installment_feature/create_installment/presentation/cubit/create_installment_cubit.dart';
import 'package:fourtyninehub/features/installment_feature/installment_details/presentation/cubit/installment_details_cubit.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/presentation/cubit/installment_list_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/spin_wheel_cubit/spin_wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_wallet_cubit/wheel_wallet_cubit.dart';
import 'package:fourtyninehub/features/married/presentation/pages/married_view.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/captain_share_info_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/route_details_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/running_map_view_details.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/screen/ride_mode_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/screen/running_and_past_trips_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/screen/new_route_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/screen/new_trip_join_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/screen/pick_me_info_screen.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/screen/trip_Join_info_screen.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/all_notifications_seen/all_notfications_seen_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_all_notifications/delete_all_notifications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/delete_notification/delete_notification_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_seen/notification_seen_cubit.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/request_history_ride_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/pages/requests_history_view.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/review_ride_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_brand_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_colors_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_model_by_brand_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_year_by_model_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/select_car_model_brand_year_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/accept_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/decline_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/delete_offer_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_all_trip_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_trip_offers_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_user_login_trip_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/offer_no_socket_actions_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/send_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_client_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/completed_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/partial_payment_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/rider_in_start_location_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/change_driver_status_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_driver_type_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/create_trip_request_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/delete_driver_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_destination_point_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_driver_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_driver_info_shipping_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_driver_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_expired_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_location_from_lat_lng_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_reasons_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_route_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_starting_point_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/picture_optional_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/raise_fare_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/select_cateogry_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/all_rider_trip_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/all_trip_no_socket_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/register_ride_parts_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/rider_register_view.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/shipping_rider_tab_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/trip_info_by_driver_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/trip_info_by_rider_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/trip_rating_ride_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/update_driver_ride_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/update_driver_shipping_screen.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/search_view.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/change_password_second_view.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/change_password_view.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/settings_view.dart';
import 'package:fourtyninehub/features/settings/presentation/pages/verification_view.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/driverStatistics_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_shipping_view.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/dahsboard_driver_screen.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/register_shipping_screen.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/trip_rating_screen.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/pages/broadcast_view.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/pages/see_all_broadcasts.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_profile/presentation/pages/chat_profile_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/attachments_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/camera_picker/camera_picker.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/chat_room_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/contacts_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/forward_messages_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/one_time_document_message.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/one_time_voice_message_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/select_contacts_to_share_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/show_image_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/show_images_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/viewcontact_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/archived_chats_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/chats_view.dart';
import 'package:fourtyninehub/features/chat_feature/presentation/pages/chat_home_page.dart';
import 'package:fourtyninehub/features/chat_feature/presentation/controllers/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/widgets/components/create_voice_room_sheet.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/life_event_sub_categories.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/pages/edit_profile_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/Post/get_posts_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/follow_requests_instagram_cubit/follow_requests_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_add_location_cubit/instagram_add_location_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_add_music_cubit/instagram_add_music_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/single_post_instagram_cubit/single_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/tag_users_cubit/tag_users_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/add_story_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/comment_instagram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/create_post_instagram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/create_post_second_page_instagram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/follow_requests_instagram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instagram_add_location_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instagram_add_music_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instgram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/profile_instagram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/single_post_instagram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_all_discover_people.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_home_screen.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/pages/live_stream_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/music_reels.dart';
import 'package:fourtyninehub/features/reels_feature/presentation/pages/reels_page.dart';
import 'package:fourtyninehub/features/reels_feature/presentation/controllers/reels_cubit.dart'
    as tiktok_reels;
import 'package:fourtyninehub/features/social_media/snap/presentation/pages/snap_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/face_book_post_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/facebook_suggest_people.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/pages/spotlight_view.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/my_profile.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/edit_profile_tinder.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_post_details_notify.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/all_winner_view.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/be_star_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/subcategories_view.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/cubit/ten_percent_cubit.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/cubit/winners_ten_percent_cubit/winners_ten_percent_cubit.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/pages/ten_percent_view.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/pages/winners_ten_percent_view.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/presentation/cubits/cubit/add_new_pick_me_trip_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/presentation/views/add_new_pick_me_view.dart';
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
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/models/get_requests_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/presentation/cubits/cubit/get_requests_pick_me_cubit.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/presentation/views/get_requests_pick_me_view.dart';
import 'package:fourtyninehub/features/trip_join/notifications/presentation/views/request_trip_join_notification.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/get_request/get_request_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/pages/tripjoin_request_history_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/usecases/view_all_pick_me_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/cubits/view_all_pick_me/view_all_pick_me_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/request_trip_join_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/request_trip_join_cubit/request_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/trip_join_create_ad_view.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/join_meeting_screen.dart';
import 'package:fourtyninehub/main.dart';
import 'package:go_router/go_router.dart';

import '../common/widgets/stateless/pages/choose_lang_screen.dart';
import '../features/Conversations/Presentation/Controllers/cubits/conversations_cubit.dart';
import '../features/Conversations/Presentation/Pages/conversations_screen.dart';
import '../features/Conversations/Presentation/Pages/social_archived_conversations_screen.dart';
import '../features/Conversations/Presentation/Pages/social_deleted_conversations_screen.dart';
import '../features/OnBoarding/Presentation/Screens/on_boarding_screen.dart';
import '../features/RideFeature/domain/entities/dashboards/trip_entity.dart';
import '../features/RideFeature/domain/entities/loading/get_loading_history_entity.dart';
import '../features/RideFeature/presentation/controllers/client_trips_cubit/client_trips_cubit.dart';
import '../features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import '../features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import '../features/RideFeature/presentation/pages/Register/Driver/drivers_license_screen.dart';
import '../features/RideFeature/presentation/pages/Register/Driver/more_info_screen.dart';
import '../features/RideFeature/presentation/pages/Register/Driver/personal_documents_screen.dart';
import '../features/RideFeature/presentation/pages/Register/Driver/personal_information_screen.dart';
import '../features/RideFeature/presentation/pages/Register/Driver/vehicle_information_screen.dart';
import '../features/RideFeature/presentation/pages/Register/Driver/welcome_ride_register.dart';
import '../features/RideFeature/presentation/pages/Register/TruckDriver/truck_drivers_license_screen.dart';
import '../features/RideFeature/presentation/pages/Register/TruckDriver/truck_more_info_screen.dart';
import '../features/RideFeature/presentation/pages/Register/TruckDriver/truck_personal_documents_screen.dart';
import '../features/RideFeature/presentation/pages/Register/TruckDriver/truck_personal_information_screen.dart';
import '../features/RideFeature/presentation/pages/Register/TruckDriver/truck_vehicle_information_screen.dart';
import '../features/RideFeature/presentation/pages/Register/TruckDriver/truck_welcome_ride_register.dart';
import '../features/RideFeature/presentation/pages/Register/complete_register_screen.dart';
import '../features/RideFeature/presentation/pages/connection_call_screen.dart';
import '../features/RideFeature/presentation/pages/create_loading_trip_screen.dart';
import '../features/RideFeature/presentation/pages/current_ride_home.dart';
import '../features/RideFeature/presentation/pages/dashboards/ride_dashboard_details_screen.dart';
import '../features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import '../features/RideFeature/presentation/pages/osm_search_and_pick.dart';
import '../features/RideFeature/presentation/pages/rating_client_screen.dart';
import '../features/RideFeature/presentation/pages/ride_finding_screen.dart';
import '../features/RideFeature/presentation/pages/ride_home.dart';
import '../features/RideFeature/presentation/pages/ride_offers/all_client_rating_screen.dart';
import '../features/RideFeature/presentation/pages/ride_offers/all_driver_rating_screen.dart';
import '../features/RideFeature/presentation/pages/ride_offers/main_tabs_ride_offer_screen.dart';
import '../features/RideFeature/presentation/pages/ride_offers/pending_ride_offer_screen.dart';
import '../features/RideFeature/presentation/pages/ride_request_screen.dart';
import '../features/RideFeature/presentation/pages/ride_status_screen.dart';
import '../features/RideFeature/presentation/pages/safety_ride_screen.dart';
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
import '../features/account_taps/wallet/presentation/cubit/subscription_wallet_cubit/subscription_wallet_cubit.dart';
import '../features/account_taps/wallet/presentation/pages/wallet_history.dart';
import '../features/account_taps/wallet/presentation/pages/wallet_view.dart';
import '../features/account_taps/wallet/presentation/pages/winners_cashback_view.dart';
import '../features/ads_feature/ad_details/presentation/pages/ad_details_view.dart';
import '../features/ads_feature/ad_requests/presentation/pages/ad_requests_view.dart';
import '../features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import '../features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import '../features/ads_feature/create_company_ad/presentation/pages/create_company_ad.dart';
import '../features/auction/presentation/cubit/auction_cubit.dart';
import '../features/auction/presentation/screens/create_auction_screen.dart';
import '../features/auction/presentation/screens/fetch_available_auction_screen.dart';
import '../features/auction/presentation/screens/my_auction_screen.dart';
import '../features/authentication/domain/entities/forget_password_questions_entity.dart';
import '../features/authentication/presentation/controllers/create_new_forgot_password_cubit/create_new_forgot_password_cubit.dart';
import '../features/authentication/presentation/controllers/forgot_password_cubit/forgot_password_cubit.dart';
import '../features/authentication/presentation/controllers/verify_forgot_password_otp/verify_forgot_password_otp_cubit.dart';
import '../features/authentication/presentation/controllers/verify_otp_cubit/verify_otp_cubit.dart';
import '../features/authentication/presentation/pages/complete_register_welcome_screen.dart';
import '../features/authentication/presentation/pages/first_login_screen.dart';
import '../features/authentication/presentation/pages/forgot_password/create_new_forget_password_view.dart';
import '../features/authentication/presentation/pages/forgot_password/enter_email_forgot_password_view.dart';
import '../features/authentication/presentation/pages/forgot_password/forget_password_otp_verification_view.dart';
import '../features/authentication/presentation/pages/login_view.dart';
import '../features/authentication/presentation/pages/register/register_verify_otp.dart';
import '../features/authentication/presentation/pages/register/register_verify_phone_otp.dart';
import '../features/azkaar/presentation/pages/azkar_view.dart';
import '../features/chance_feature/presentation/pages/chance_main_view.dart';
import '../features/competition/presentation/pages/competition_view.dart';
import '../features/exchange_currency/presentation/logic/currency_cubit.dart';
import '../features/exchange_currency/presentation/views/currency_exchange_page.dart';
import '../features/food_feature/cusine_restaurants/presentation/pages/cusine_restaurants_view.dart';
import '../features/food_feature/food_cart/presentation/pages/cart_view.dart';
import '../features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../features/food_feature/restaurant_details/presentation/pages/restaurant_details_view.dart';
import '../features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import '../features/food_feature/restaurants_list/presentation/pages/restaurants_lists_view.dart';
import '../features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import '../features/fourty_nine/presentation/pages/fourty_nine.dart';
import '../features/fourty_nine/presentation/pages/main_categories_cards_view.dart';
import '../features/fourty_nine/presentation/pages/main_categories_taps_view.dart';
import '../features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import '../features/health_feature/booking/presentation/pages/booking_confirmation_screen.dart';
import '../features/health_feature/booking/presentation/pages/successful_booking_screen.dart';
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

import '../features/new_trip_join/driver/screen/captain_ride_details.dart';
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
import '../features/social_media/create_post/presentation/pages/create_life_event.dart';
import '../features/social_media/create_post/presentation/pages/create_post_view.dart';
import '../features/social_media/create_post/presentation/pages/life_event.dart';
import '../features/social_media/instagram/presentation/pages/followers_screen.dart';
import '../features/social_media/instagram/presentation/widgets/create_post_second_page_instagram_view_body.dart';
import '../features/social_media/instagram/presentation/widgets/tag_user_view.dart';
import '../features/social_media/reels/presentation/screen/add_story_screen.dart';
import '../features/social_media/reels/presentation/screen/use_sound_screen.dart';
import '../features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import '../features/social_media/social_posts/presentation/pages/Social_home.dart';
import '../features/social_media/social_posts/presentation/pages/other_account_view.dart';
import '../features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import '../features/social_media/twitter/presentation/twitter/presentation/pages/create_post_twitter_view.dart';
import '../features/social_media/twitter/presentation/twitter/presentation/pages/twitter_view.dart';
import '../features/star_feature/presentation/controller/comment_cubit/comment_cubit.dart';
import '../features/star_feature/presentation/pages/my_talent.dart';
import '../features/subcategories/presentation/cubit/subcategories_cubit.dart';
import '../features/subcategories/presentation/pages/custom_page_sub_categories_view.dart';
import '../features/trip_join/view_all_trip_join/presentation/views/trip_join_view.dart';
import '../features/youtube/presentation/pages/play_video.dart';
import '../features/youtube/presentation/pages/youtube.dart';
import '../features/zoom/presentation/pages/meeting_room.dart';
import '../features/zoom/presentation/pages/meeting_view.dart';
import '../service_locator/service_locator.dart';
import 'routes.dart';

class AppPages {
  AppPages._();

  static late final GoRouter router;

  static initializeRouter(String initialRoute) {
    router = GoRouter(
        navigatorKey: navigatorKey,
        initialLocation: initialRoute,
        routes: <RouteBase>[
          GoRoute(
            path: Paths.splash,
            name: Routes.splash,
            pageBuilder: (context, state) => customTransition(
              context,
              state,
              const BeforeSplash(),
            ),
            routes: [
              GoRoute(
                path: Paths.splashScreen,
                name: Routes.splashScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const SplashScreen(),
                ),
              ),
              GoRoute(
                path: Routes.HOME,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<SliderCubit>()..loadData(),
                      ),
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<StarCubit>()..allTalents,
                      ),
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<MainCategoriesCubit>()
                              ..loadData(context),
                      ),
                      // BlocProvider(
                      //   create: (context) => serviceLocator<ThumbnailsCubit>(),
                      // ),
                    ],
                    child: HomePage(
                      state: state.extra as dynamic,
                    ),
                    // child: const BeStarView(),
                    // child: const GetAllTalents(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.RIDEHOME,
                name: Routes.RIDE_HOME,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: serviceLocator<RideCubit>(),
                      ),
                    ],
                    child: const RideHome(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.EXCHANGECURRENCY,
                name: Routes.EXCHANGECURRENCY,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                    create: (context) => serviceLocator<CurrencyCubit>(),
                    child: const CurrencyExchangePage(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.RunningMapDetails,
                name: Routes.RunningMapDetails,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: serviceLocator<CaptainShareCubit>(),
                      ),
                    ],
                    child: RunningMapViewDetails(),
                  ),
                ),
              ),
              GoRoute(
                  path: Routes.CUSTOMPAGE,
                  name: Routes.CUSTOMPAGE,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        const CustomPage(),
                      ),
                  routes: [
                    // GoRoute(
                    //   path: Paths.PAGEPREVIEW,
                    //   name: Routes.PAGEPREVIEW,
                    //   pageBuilder: (context, state) => customTransition(
                    //     context,
                    //     state,
                    //     MultiBlocProvider(
                    //       providers: [
                    //         BlocProvider(
                    //           create: (context) =>
                    //               serviceLocator<SliderCubit>()..loadData(),
                    //         ),
                    //         // BlocProvider(
                    //         //   create: (context) =>
                    //         //       serviceLocator<ThumbnailsCubit>(),
                    //         // ),
                    //       ],
                    //       child: PagePreview(
                    //         state: state.extra as dynamic,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ]),
              GoRoute(
                path: Routes.onBoardingScreen,
                name: Routes.onBoardingScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const OnBoardingScreen(),
                ),
              ),
              GoRoute(
                path: Routes.ChooseLangScreen,
                name: Routes.ChooseLangScreen,
                pageBuilder: (context, state) =>
                    customTransition(context, state, const ChooseLangScreen()),
              ),
              GoRoute(
                path: Routes.FirstLoginScreen,
                name: Routes.FirstLoginScreen,
                pageBuilder: (context, state) =>
                    customTransition(context, state, FirstLoginScreen()),
              ),
              GoRoute(
                path: Routes.CompleteRegisterWelcomeScreen,
                name: Routes.CompleteRegisterWelcomeScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  CompleteRegisterWelcomeScreen(
                    giftMessageEntity: state.extra as String,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.RestaurantDashboard,
                name: Routes.RestaurantDashboard,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<RestaurantDashboardCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => serviceLocator<RestaurantsCubit>(),
                      ),
                    ],
                    child: RestaurantDashboardView(payload: state.extra),
                  ),
                ),
              ),
              // GoRoute(
              //   path: Paths.MY_TALENT,
              //   name: Routes.MY_TALENT,
              //   pageBuilder: (context, state) => customTransition(
              //     context,
              //     state,
              //     BlocProvider(
              //       create: (context) => serviceLocator<StarCubit>(),
              //       child: const MyTalentView(),
              //     ),
              //   ),
              // ),
              // GoRoute(
              //   path: Paths.RESTAURANTORDERS,
              //   name: Routes.RESTAURANTORDERS,
              //  pageBuilder: (context, state) =>
              //             customTransition(context, state, BlocProvider(
              //       create: (context) =>
              //           serviceLocator<RestaurantDashboardCubit>(),
              //       child: const RestaurantDashboardOrders()),
              // ),),
              GoRoute(
                path: Paths.RIDEACTIVITY,
                name: Routes.RIDEACTIVITY,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  ActivityTripScreen(),
                ),
              ),
              GoRoute(
                path: Paths.RIDERUNNINGTRIPS,
                name: Routes.RIDERUNNINGTRIPS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  RunningTripScreen(params: state.extra as RunningTripParams),
                ),
              ),
              GoRoute(
                path: Paths.RIDEEXPIREDTRIPE,
                name: Routes.RIDEEXPIREDTRIPE,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  ExpiredTripsScreen(
                    params: state.extra as ExpiredTripsScreenParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.RIDEDETAILSTRIPS,
                name: Routes.RIDEDETAILSTRIPS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  RideHistoryDetailsScreen(
                    params: state.extra as RideHistoryDetailsScreenParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.TripReceiptScreen,
                name: Routes.TripReceiptScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  TripReceiptScreen(
                    params: state.extra as TripReceiptScreenParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.RIDEHISTORYTRIPS,
                name: Routes.RIDEHISTORYTRIPS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  HistoryTripsScreen(
                    params: state.extra as HistoryTripsScreenParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.RIDEOPENSTREETMAPSEARCHANDPICK,
                name: Routes.RIDEOPENSTREETMAPSEARCHANDPICK,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  RideOpenStreetMapSearchAndPick(
                    params: state.extra as RideOpenStreetMapSearchAndPickParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.GoogleMapsSearchAndPick,
                name: Routes.GoogleMapsSearchAndPick,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  RideOpenGoogleMapSearchAndPickScreen(
                    params: state.extra as RideGoogleMapSearchAndPickParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.EditFoodView,
                name: Routes.EditFoodView,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: RestaurantMenuCubit(serviceLocator()),
                      ),
                      BlocProvider<CreateRestaurantCubit>.value(
                        value: serviceLocator()..loadData(),
                      ),
                      BlocProvider(
                        create: (context) => serviceLocator<EditFoodCubit>(),
                      )
                    ],
                    child: EditFoodView(
                      payload: state.extra,
                    ),
                  ),
                ),
              ),
              // FLIP CARDS
              GoRoute(
                path: Paths.SEARCH,
                name: Routes.SEARCH,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                      create: (context) => serviceLocator<SearchCubit>(),
                      child: const SearchView()),
                ),
              ),
              GoRoute(
                path: Paths.MAINCATEGORIESCARDS,
                name: Routes.MAINCATEGORIESCARDS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                    create: (context) => serviceLocator<MainCategoriesCubit>(),
                    child: MainCategoriesFlipCardsView(
                      mainCategoriesCardsParams:
                          state.extra as MainCategoriesCardsParams,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.CONTACTS_VIEW,
                name: Routes.CONTACTSVIEW,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  ContactsView(
                    contactsViewParams: state.extra as ContactsViewParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.ONETIMEVOICEMESSAGEVIEW,
                name: Routes.ONETIMEVOICEMESSAGE,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  OneTimeVoiceMessageView(
                    messageEntity: state.extra as MessageEntity,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.ONETIMEDOCUMENTMESSAGEVIEW,
                name: Routes.ONETIMEDOCUMENTMESSAGE,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  OneTimeDocumentMessageView(
                    oneTimeDocumentMessageViewParams:
                        state.extra as OneTimeDocumentMessageViewParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.FORWARDMESSAGESVIEW,
                name: Routes.FORWARDMESSAGES,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  ForwardMessagesView(
                    forwardMessagesViewParams:
                        state.extra as ForwardMessagesViewParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.ARCHIVEDCHATS,
                name: Routes.ARCHIVEDCHATS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  OptionsChatsView(
                    params: state.extra as OptionsChatsViewParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.BROADCAST,
                name: Routes.BROADCAST,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const BroadcastView(),
                ),
              ),
              GoRoute(
                path: Paths.IMAGESPAGEVIEW,
                name: Routes.IMAGESPAGEVIEW,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  ImagesPageView(
                    params: state.extra as ImagesPageViewParams,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.SHOWIMAGESVIEW,
                name: Routes.SHOWIMAGEVIEW,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  ShowImagesView(
                    messageEntity: state.extra as MessageEntity,
                  ),
                ),
              ),
              GoRoute(
                path: Paths.SEEALLBROADCASTS,
                name: Routes.SEEALLBROADCASTS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const SeeAllBroadcasts(),
                ),
              ),
              GoRoute(
                path: Paths.CHATPROFILEVIEW,
                name: Routes.CHATPROFILEVIEW,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const ChatProfileView(),
                ),
              ),
              //GRID VIEW
              GoRoute(
                path: Paths.MAINCATEGORIESTREE,
                name: Routes.MAINCATEGORIESTREE,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(providers: [
                    BlocProvider(
                      create: (context) =>
                          serviceLocator<MainCategoriesTapsCubit>(),
                    ),
                  ], child: const MainCategoriesGridView()),
                ),
              ),
              GoRoute(
                path: Paths.SUBCATEGORIES,
                name: Routes.SUBCATEGORIES,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                    create: (context) => serviceLocator<SubcategoriesCubit>(),
                    child: SubCategoriesView(
                      mainCategory: state.extra as MainCategoryEntity,
                    ),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: Paths.ADS,
                    name: Routes.ADS,
                    pageBuilder: (context, state) => customTransition(
                      context,
                      state,
                      BlocProvider(
                        create: (_) => serviceLocator<AdvertisementCubit>(),
                        child: AdsView(
                          params: state.extra as AdsViewParams,
                        ),
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
                            pageBuilder: (context, state) => customTransition(
                              context,
                              state,
                              BlocProvider<AdRequestsCubit>(
                                create: (_) => serviceLocator(),
                                child: AdRequestsView(payload: state.extra),
                              ),
                            ),
                          ),
                        ],
                        pageBuilder: (context, state) => customTransition(
                            context,
                            state,
                            MultiBlocProvider(
                              providers: [
                                BlocProvider<AdDetailsCubit>(
                                  create: (_) => serviceLocator(),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      serviceLocator<SubcategoriesCubit>(),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      serviceLocator<AdvertisementCubit>(),
                                ),
                              ],
                              child: AdDetailsView(payload: state.extra),
                            )),
                      ),
                      GoRoute(
                        path: Paths.CREATEAD,
                        name: Routes.CREATEAD,
                        pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider(
                              create: (context) =>
                                  serviceLocator<CreateAdCubit>(),
                              child: CreateAdView(
                                categorization:
                                    state.extra as CategorizationEntity,
                              )),
                        ),
                      ),
                      GoRoute(
                        path: Paths.FILTERADS,
                        name: Routes.FILTERADS,
                        pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider.value(
                            value: serviceLocator<CreateAdCubit>(),
                            child: FilterAdsView(
                              filterAdsParams: state.extra as FilterAdsParams,
                            ),
                          ),
                        ),
                      ),
                      GoRoute(
                        path: Paths.GOVERNORATEFILTERADS,
                        name: Routes.GOVERNORATEFILTERADS,
                        pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider.value(
                              value: serviceLocator<CreateAdCubit>(),
                              child: GovernorateFilterAdsView(
                                categorization:
                                    state.extra as CategorizationEntity,
                              )),
                        ),
                      ),
                      // CreateCompanyAdView
                      GoRoute(
                        path: Paths.CREATECOMPANYAD,
                        name: Routes.CREATECOMPANYAD,
                        pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          const CreateCompanyAdView(),
                        ),
                      ),
                      GoRoute(
                        path: Paths.CREATECOMPANYPOSTAD,
                        name: Routes.CREATECOMPANYPOSTAD,
                        pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<CreateCompanyAdCubit>(
                              create: (_) => serviceLocator(),
                              child: CreatePostCompany(
                                params: state.extra as CreatePostCompanyParams,
                              )),
                        ),
                      ),
                      GoRoute(
                        path: Paths.CREATECOMPANYPOSTREALAD,
                        name: Routes.CREATECOMPANYPOSTREALAD,
                        pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<CreateCompanyAdCubit>(
                              create: (_) => serviceLocator(),
                              child: CreatePostReelCompany(
                                totalPrice: state.extra as num,
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: Paths.CustomPageSubCategoriesView,
                name: Routes.CustomPageSubCategoriesView,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider.value(
                    value: serviceLocator<SubcategoriesCubit>(),
                    child: CustomPageSubCategoriesView(
                      params: state.extra as CustomPageSubCategoriesParams,
                    ),
                  ),
                ),
              ),
              // GoRoute(
              //   path: Paths.NavigatorSubCategoriesView,
              //   name: Routes.NavigatorSubCategoriesView,
              //  pageBuilder: (context, state) =>
              //     customTransition(context, state, NavigatorSubCategoriesView(
              //     mainCategory: state.extra as CustomPageCategoriesEntity,
              //   ),
              // ),),
              GoRoute(
                path: Paths.MARRIAGESUBCATEGORIES,
                name: Routes.MARRIAGESUBCATEGORIES,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<SubcategoriesCubit>(),
                      ),
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<AdvertisementCubit>(),
                      ),
                    ],
                    child: const MarriageSubCategoriesView(
                        // mainCategory: state.extra as MainCategoryEntity,
                        ),
                  ),
                ),
              ),
              GoRoute(
                name: Routes.LOGIN,
                path: Paths.LOGIN,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => serviceLocator<LoginCubit>(),
                      ),
                      BlocProvider(
                        create: (_) => serviceLocator<VerifyOtpCubit>(),
                      ),
                      // BlocProvider(
                      //   create: (_) => serviceLocator<GetWalletCubit>(),
                      // ),
                      BlocProvider(
                        create: (_) => serviceLocator<UserCubit>(),
                      ),
                      BlocProvider(
                        create: (_) => serviceLocator<RegisterCubit>(),
                      ),
                      BlocProvider(
                        create: (_) =>
                            serviceLocator<WalletCubit>()..loadData(),
                      ),
                      BlocProvider(
                        create: (_) => serviceLocator<GiftCubit>()..loadData(),
                      ),
                    ],
                    child: LoginView(
                      authType: AuthType.LOGIN,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.FORGOTPASSWORD,
                name: Routes.FORGOTPASSWORD,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider<ForgotPasswordCubit>(
                    create: (_) => serviceLocator(),
                    child: const EnterEmailForgotPasswordView(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.FORGOTPASSWORDOTP,
                name: Routes.FORGOTPASSWORDOTP,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<VerifyForgotPasswordOtpCubit>(
                        create: (_) => serviceLocator(),
                      ),
                      BlocProvider(
                        create: (_) => serviceLocator<VerifyOtpCubit>(),
                      ),
                    ],
                    child: ForgetPasswordOtpVerificationView(
                      email: state.extra as String,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.CREATENEWFORGOTPASSWORD,
                name: Routes.CREATENEWFORGOTPASSWORD,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider<CreateNewForgotPasswordCubit>(
                    create: (_) => serviceLocator(),
                    child: CreateNewForgetPasswordView(
                      emailOrUserId: state.extra as Map<String, dynamic>,
                    ),
                  ),
                ),
              ),
              GoRoute(
                name: Routes.REGISTER,
                path: Paths.REGISTER,
                //pageBuilder: (context, state) =>
                //  customTransition(context, state, BlocProvider<RegisterCubit>(
                //   create: (_) => serviceLocator(),
                //   child:
                // ),),
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => serviceLocator<LoginCubit>(),
                      ),
                      BlocProvider(
                        create: (_) => serviceLocator<VerifyOtpCubit>(),
                      ),
                      BlocProvider(
                        create: (_) => serviceLocator<RegisterCubit>(),
                      ),
                    ],
                    child: LoginView(
                      authType: AuthType.REGISTER,
                    ),
                  ),
                ),
                routes: [
                  GoRoute(
                    name: Routes.VERIFYMAIL,
                    path: Paths.VERIFYMAIL,
                    pageBuilder: (context, state) => customTransition(
                      context,
                      state,
                      BlocProvider<VerifyOtpCubit>(
                        create: (context) => serviceLocator(),
                        child: RegisterVerifyOTP(
                          email: state.extra as String,
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    name: Routes.registerVerifyPhoneOTP,
                    path: Paths.registerVerifyPhoneOTP,
                    pageBuilder: (context, state) => customTransition(
                      context,
                      state,
                      BlocProvider<VerifyOtpCubit>(
                        create: (context) => serviceLocator(),
                        child: RegisterVerifyPhoneOTP(
                          phoneNumber: state.extra as String,
                        ),
                      ),
                    ),
                  ),
                  // DriverRegister
                  GoRoute(
                    name: Routes.REGISTERDRIVER,
                    path: Paths.REGISTERDRIVER,
                    pageBuilder: (context, state) => customTransition(
                      context,
                      state,
                      BlocProvider<DriverRegisterCubit>(
                        create: (_) => serviceLocator(),
                        child: DriverRegister(
                          subCategoryId: state.extra as String,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              GoRoute(
                name: Routes.LUCKYWHEEL,
                path: Paths.LUCKYWHEEL,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
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
              ),
              // CompetitionView
              GoRoute(
                name: Routes.COMPETITIONS,
                path: Paths.COMPETITIONS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const CompetitionView(
                    list: [],
                  ),
                ),
                routes: const [],
              ),
              // PaymentView
              GoRoute(
                name: Routes.PAYMENT,
                path: Paths.PAYMENT,
                pageBuilder: (context, state) {
                  final args = state.extra as PaymobLink;

                  return customTransition(
                      context,
                      state,
                      BlocProvider(
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
                      ));
                },
                routes: const [],
              ),
              // GoRoute(
              //   path: Paths.WINNERS,
              //   name: Routes.WINNERS,
              //  pageBuilder: (context, state) =>
              //    customTransition(context, state, const Winners(),
              // ),),
              GoRoute(
                path: Paths.WINNERSCASHBACK,
                name: Routes.WINNERSCASHBACK,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                    create: (context) => serviceLocator<WinnersCashbackCubit>()
                      ..getWinners(context),
                    child: const WinnersCashbackView(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.WINNERSGift,
                name: Routes.WINNERSGift,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                    create: (context) =>
                        serviceLocator<WinnersGiftCubit>()..getWinners(context),
                    child: const WinnersGiftView(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.QURAAN,
                name: Routes.QURAAN,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider<QuranCubit>(
                      create: (_) => serviceLocator(),
                      child: const QuraanView()),
                ),
              ),
              GoRoute(
                path: Paths.AZKAAR,
                name: Routes.AZKAAR,
                routes: [
                  GoRoute(
                    path: Paths.AZKAARDETAILS,
                    name: Routes.AZKAARDETAILS,
                    pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<AzkarCubit>(
                          create: (_) => serviceLocator(),
                          child: AzkarDetails(
                            category: state.extra as String,
                          ),
                        )),
                  ),
                ],
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    BlocProvider<AzkarCubit>(
                      create: (_) => serviceLocator(),
                      child: const AzkarView(),
                    )),
              ),

              // WalletView
              GoRoute(
                  path: Paths.WALLET,
                  name: Routes.WALLET,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => serviceLocator<WalletTwoCubit>()
                                ..getAllDataWalletScreen(context),
                            ),
                            BlocProvider(
                              create: (_) =>
                                  serviceLocator<SubscriptionWalletCubit>(),
                            ),
                          ],
                          child: const WalletView(
                              // type: state.extra as WalletTypes,
                              ),
                        ),
                      ),
                  routes: [
                    GoRoute(
                        path: Paths.WALLETHISTORY,
                        name: Routes.WALLETHISTORY,
                        pageBuilder: (context, state) {
                          final item = state.extra as List<WalletHistoryEntity>;
                          return customTransition(
                              context,
                              state,
                              WalletHistory(
                                list: item,
                              ));
                        }),
                    GoRoute(
                      path: Paths.TRANSFERMONEY,
                      name: Routes.TRANSFERMONEY,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        const TransferMoneyView(),
                      ),
                    ),
                  ]),

              // CashBack
              GoRoute(
                path: Paths.CASHBACK,
                name: Routes.CASHBACK,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const CashbackView(),
                ),
              ),

              GoRoute(
                path: Paths.BALANCE,
                name: Routes.BALANCE,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider<BalanceCubit>(
                    create: (_) => serviceLocator(),
                    child: const BalanceWalletView(),
                  ),
                ),
              ),

              // Gift
              GoRoute(
                path: Paths.GIFT,
                name: Routes.GIFT,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const GiftView(),
                ),
              ),
              // GoRoute(
              //   path: Paths.GIFT,
              //   name: Routes.GIFT,
              //  pageBuilder: (context, state) =>
              //    customTransition(context, state, BlocProvider<WalletCubit>(
              //     create: (_) => serviceLocator(),
              //     child: const GiftWalletView(),
              //   ),
              // ),),

              // Winners
              // GoRoute(
              //   path: Paths.WINNERS,
              //   name: Routes.WINNERS,
              //  pageBuilder: (context, state) =>
              //       customTransition(context, state, GiftView(),
              // ),),

              // Change Password
              GoRoute(
                path: Paths.CHANGEPASSWORD,
                name: Routes.CHANGEPASSWORD,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const ChangePasswordView(),
                ),
              ),

              GoRoute(
                path: Paths.CHANGEPASSWORDSECOND,
                name: Routes.CHANGEPASSWORDSECOND,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const ChangePasswordSecondView(),
                ),
              ),

              GoRoute(
                path: Paths.VERIFICATION,
                name: Routes.VERIFICATION,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                    create: (context) => serviceLocator<ForgotPasswordCubit>(),
                    child: VerificationView(
                      questions: state.extra as ForgetPasswordQuestionsEntity,
                    ),
                  ),
                ),
              ),

              GoRoute(
                  path: Paths.ACCOUNT,
                  name: Routes.ACCOUNT,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider(
                            create: (context) =>
                                serviceLocator<NotificationSeenCubit>(),
                            child: const NotificationView()),
                      ),
                  routes: [
                    // GoRoute(
                    //   path: Paths.NOTIFICATIONS,
                    //   name: Routes.NOTIFICATIONS,
                    //  pageBuilder: (context, state) =>
                    // customTransition(context, state, MultiBlocProvider(
                    //     providers: [
                    //       BlocProvider<GetAppNotificationsCubit>(
                    //         create: (context) =>
                    //             serviceLocator<GetAppNotificationsCubit>(),
                    //       ),
                    //       BlocProvider<GetStatusAllServicesNotificationsCubit>(
                    //         create: (context) => serviceLocator<
                    //             GetStatusAllServicesNotificationsCubit>(),
                    //       ),
                    //       BlocProvider<GetSocialNotificationsCubit>(
                    //         create: (context) => GetSocialNotificationsCubit(
                    //           getNotficationsUseCase: serviceLocator(),
                    //           context: context,
                    //         ),
                    //       ),
                    //       BlocProvider<GetServicesNotificationsCubit>(
                    //         create: (context) => GetServicesNotificationsCubit(
                    //           getNotficationsUseCase: serviceLocator(),
                    //           context: context,
                    //         ),
                    //       ),
                    //     ],
                    //     child: const NotificationView(),
                    //   ),
                    // ),),
                    GoRoute(
                      path: Paths.NOTIFICATIONS,
                      name: Routes.NOTIFICATIONS,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        MultiBlocProvider(providers: [
                          BlocProvider(
                            create: (context) =>
                                serviceLocator<NotificationSeenCubit>(),
                          ),
                          BlocProvider(
                            create: (context) =>
                                serviceLocator<AllNotficationsSeenCubit>(),
                          ),
                          BlocProvider(
                            create: (context) =>
                                serviceLocator<DeleteNotificationCubit>(),
                          ),
                          BlocProvider(
                            create: (context) =>
                                serviceLocator<DeleteAllNotificationsCubit>(),
                          ),
                        ], child: const NotificationView()),
                      ),
                    ),
                    GoRoute(
                      path: Paths.SETTINGS,
                      name: Routes.SETTINGS,
                      pageBuilder: (context, state) => customTransition(
                          context, state, const SettingsView()),
                    ),
                    GoRoute(
                      path: Paths.PRIVACY,
                      name: Routes.PRIVACY,
                      pageBuilder: (context, state) =>
                          customTransition(context, state, PrivacyView()),
                    ),
                    GoRoute(
                      path: Paths.POLICY,
                      name: Routes.POLICY,
                      pageBuilder: (context, state) => customTransition(context,
                          state, PolicyView(fromTerms: state.extra as bool)),
                    ),
                    GoRoute(
                      path: Paths.Lists,
                      name: Routes.Lists,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<ListsCubit>(
                            create: (_) => serviceLocator()..loadFriends(''),
                            child: const ListsView(),
                          )),
                    ),
                    GoRoute(
                      path: Paths.SHAREAPP,
                      name: Routes.SHAREAPP,
                      //
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<ShareAppCubit>(
                            create: (_) =>
                                serviceLocator<ShareAppCubit>()..shareApp(),
                            child: const ShareTheApp(),
                          )),
                    ),
                    GoRoute(
                      path: Paths.FAVOURITE,
                      name: Routes.FAVOURITE,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider.value(
                              value: serviceLocator<FavouriteDrawerCubit>(),
                              child: const FavouriteView())),
                    ),
                    GoRoute(
                      path: Paths.FAVOURITECATEGORIES,
                      name: Routes.FAVOURITECATEGORIES,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<FavouriteCategoryCubit>(
                            create: (_) => serviceLocator(),
                            child: const FavouriteCategoryView(),
                          )),
                    ),
                    GoRoute(
                      path: Paths.FAVOURITESUBCATEGORIES,
                      name: Routes.FAVOURITESUBCATEGORIES,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<FavouriteSubCategoryCubit>(
                          create: (_) => serviceLocator(),
                          child: const FavSubCategoryView(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.MYADDS,
                      name: Routes.MYADDS,
                      routes: [
                        GoRoute(
                            path: Paths.EDITAD,
                            name: Routes.EDITAD,
                            pageBuilder: (context, state) => customTransition(
                                context,
                                state,
                                BlocProvider<CreateAdCubit>(
                                  create: (_) => serviceLocator(),
                                  child: EditMyAds(
                                    categorization:
                                        state.extra as MyAuctionAdsEntity,
                                  ),
                                ))),
                      ],
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<MyAddsCubit>(
                            create: (_) => serviceLocator(),
                            child: const MyAddsView(),
                          )),
                    ),
                  ]),

              GoRoute(
                path: Paths.ADDSTORYINSTAGRAM,
                name: Routes.ADDSTORYINSTAGRAM,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const AddStoryView(),
                ),
              ),

              GoRoute(
                path: Paths.TAGUSER,
                name: Routes.TAGUSER,
                pageBuilder: (context, state) {
                  final cubit = state.extra as CreatePostInstagramCubit;
                  return customTransition(
                      context,
                      state,
                      MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) =>
                                serviceLocator<TagUsersCubit>(),
                          ),
                          BlocProvider.value(
                            value: cubit,
                          ),
                        ],
                        child: const TagUserView(),
                      ));
                },
              ),
              GoRoute(
                path: Paths.INSTAGRAMADDLOCATION,
                name: Routes.INSTAGRAMADDLOCATION,
                pageBuilder: (context, state) {
                  final cubit = state.extra as CreatePostInstagramCubit;
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              serviceLocator<InstagramAddLocationCubit>(),
                        ),
                        BlocProvider.value(
                          value: cubit,
                        ),
                      ],
                      child: const InstagramAddLocationView(),
                    ),
                  );
                },
              ),

              GoRoute(
                path: Paths.INSTAGRAMADDMUSIC,
                name: Routes.INSTAGRAMADDMUSIC,
                pageBuilder: (context, state) {
                  final cubit = state.extra as MusicScreenParams;
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              serviceLocator<InstagramAddMusicCubit>(),
                        ),
                        BlocProvider.value(
                          value: cubit.cubit,
                        ),
                      ],
                      child: InstagramAddMusicView(
                        refreshUI: cubit.refreshUI,
                      ),
                    ),
                  );
                },
              ),

              GoRoute(
                path: Paths.INSTAGRAMPROFILE,
                name: Routes.INSTAGRAMPROFILE,
                pageBuilder: (context, state) {
                  final String? id = state.extra as String?;
                  return customTransition(
                    context,
                    state,
                    BlocProvider.value(
                      value: serviceLocator<ProfileInstagramCubit>()
                        ..getUserProfile(userId: id ?? ''),
                      child: ProfileInstagramView(
                        userId: id ?? '',
                      ),
                    ),
                  );
                },
              ),
              GoRoute(
                path: Paths.FOLLOWREQUESTSINSTAGRAM,
                name: Routes.FOLLOWREQUESTSINSTAGRAM,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    BlocProvider(
                      create: (_) =>
                          serviceLocator<FollowRequestsInstagramCubit>()
                            ..fetchInitialData(),
                      child: const FollowRequestsInstagramView(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: Paths.SINGLEPOSTINSTAGRAM,
                name: Routes.SINGLEPOSTINSTAGRAM,
                pageBuilder: (context, state) {
                  final String postId = state.extra as String;

                  return customTransition(
                      context,
                      state,
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<SinglePostInstagramCubit>()
                              ..getPost(postId),
                        child: SinglePostInstagramView(
                          postId: postId,
                        ),
                      ));
                },
              ),
              GoRoute(
                path: Paths.CREATEPOSTINSTAGRAM,
                name: Routes.CREATEPOSTINSTAGRAM,
                routes: [
                  GoRoute(
                    path: Paths.CREATEPOSTSECONDPAGEINSTAGRAM,
                    name: Routes.CREATEPOSTSECONDPAGEINSTAGRAM,
                    pageBuilder: (context, state) {
                      final CreatePostInstagramCubit cubit =
                          state.extra as CreatePostInstagramCubit;
                      return customTransition(
                          context,
                          state,
                          BlocProvider.value(
                            value: cubit,
                            child: const CreatePostSecondPageInstagramView(
                                // selectedImages: state.extra as List<Future<File?>>,
                                ),
                          ));
                    },
                  ),
                ],
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const CreatePostInstagramView(),
                ),
              ),
              GoRoute(
                path: Paths.InstagramSuggestPeople,
                name: Routes.InstagramSuggestPeople,
                routes: const [],
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider<InstagramCubit>(
                    create: (_) => serviceLocator(),
                    child: const InstagramAllDiscoverPeople(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.followersScreen,
                name: Routes.followersScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider<InstagramCubit>(
                    create: (_) => serviceLocator(),
                    child: FollowersScreen(
                      args: state.extra as FollowersScreenArguments,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.INSTAGRAMCOMMENT,
                name: Routes.INSTAGRAMCOMMENT,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  CommentInstagramView(
                    postId: state.extra as String,
                  ),
                ),
              ),

              GoRoute(
                path: Paths.INSTAGRAM,
                name: Routes.INSTAGRAM,
                // routes: [
                //   GoRoute(
                //     path: Paths.INSTAGRAMPROFILE,
                //     name: Routes.INSTAGRAMPROFILE,
                //    pageBuilder: (context, state) {
                //       final String? id = state.extra as String?;
                //
                //       return BlocProvider<ProfileInstagramCubit>(
                //         create: (_) => serviceLocator<ProfileInstagramCubit>()
                //           ..getUserProfile(id: id ?? ''),
                //         child: const ProfileInstagramView(),
                //       );
                //     },
                //   ),
                //   GoRoute(
                //     path: Paths.CREATEPOSTINSTAGRAM,
                //     name: Routes.CREATEPOSTINSTAGRAM,
                //     routes: [
                //       GoRoute(
                //         path: Paths.CREATEPOSTSECONDPAGEINSTAGRAM,
                //         name: Routes.CREATEPOSTSECONDPAGEINSTAGRAM,
                //        pageBuilder: (context, state) =>
                //     customTransition(context, state,
                //             CreatePostSecondPageInstagramView(
                //                 // selectedImages: state.extra as List<Future<File?>>,
                //                 ),
                //       ),),
                //     ],
                //    pageBuilder: (context, state) =>
                //     customTransition(context, state,
                //         const CreatePostInstagramView(),
                //   ),),
                //   GoRoute(
                //     path: Paths.InstagramSuggestPeople,
                //     name: Routes.InstagramSuggestPeople,
                //     routes: const [],
                //    pageBuilder: (context, state) =>
                //     customTransition(context, state, BlocProvider<InstagramCubit>(
                //       create: (_) => serviceLocator(),
                //       child: const InstagramAllDiscoverPeople(),
                //     ),
                //   ),),
                //   GoRoute(
                //     path: Paths.INSTAGRAMCOMMENT,
                //     name: Routes.INSTAGRAMCOMMENT,
                //    pageBuilder: (context, state) =>
                //     customTransition(context, state, CommentInstagramView(
                //       postId: state.extra as String,
                //     ),
                //   ),),
                // ],
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<InstagramCubit>()..loadData(),
                      ),
                      BlocProvider(
                        create: (context) => serviceLocator<StoryCubit>(),
                      ),
                      // BlocProvider(
                      //   create: (context) => CreatePostInstagramCubit(
                      //       repository: serviceLocator()),
                      // ),
                      BlocProvider(
                        create: (context) => GetPostsInstagramCubit(
                            getPostsUseCase: serviceLocator()),
                      ),
                    ],
                    child: const InstagramView(),
                  ),
                ),
              ),

              //social home
              GoRoute(
                path: Paths.POSTDETAILS,
                name: Routes.POSTDETAILS,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      BlocProvider<SocialPostsCubit>(
                        create: (_) {
                          return serviceLocator();
                        },
                        child: FaceBookPostDetails(
                          payload: state.extra as dynamic,
                        ),
                      ));
                },
              ),
              GoRoute(
                path: Paths.REELS,
                name: Routes.REELS,
                pageBuilder: (context, state) {
                  // context.read<ReelsCubit>().fetchReels();
                  return customTransition(
                      context,
                      state,
                      BlocProvider(
                        create: (context) => serviceLocator<SocialPostsCubit>(),
                        child: const ReelView(),
                      ));
                },
                routes: [
                  GoRoute(
                    path: Paths.MUSICREELS,
                    name: Routes.MUSICREELS,
                    pageBuilder: (context, state) => customTransition(
                      context,
                      state,
                      const MusicReels(),
                    ),
                  ),
                ],
              ),

              GoRoute(
                path: Paths.TIKTOK_REELS,
                name: Routes.TIKTOK_REELS,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<tiktok_reels.TiktokCubit>(),
                        child: const ReelsPage(),
                      ));
                },
              ),

              GoRoute(
                  path: Paths.SOCIAL,
                  name: Routes.SOCIAL,
                  pageBuilder: (context, state) {
                    final params = state.extra as dynamic;
                    return customTransition(
                        context,
                        state,
                        BlocProvider(
                          create: (context) =>
                              serviceLocator<SocialPostsCubit>()..loadData(),
                          child: SocialHomeView(
                            payload: params ??
                                SocialParams(
                                    userId: '', index: 0, hideAppBar: false),
                          ),
                        ));
                  },
                  routes: [
                    GoRoute(
                      path: Paths.CREATEPOST,
                      name: Routes.CREATEPOST,
                      pageBuilder: (context, state) => customTransition(
                          context, state, const CreatePostView(

                      )),
                    ),
                    GoRoute(
                      path: Paths.CREATEPOSTTWITTER,
                      name: Routes.CREATEPOSTTWITTER,
                      pageBuilder: (context, state) => customTransition(
                          context, state, const CreatePostTwitter()),
                    ),
                    GoRoute(
                      path: Paths.LIFEEVENT,
                      name: Routes.LIFEEVENT,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        const LifeEvent(),
                      ),
                    ),
                    GoRoute(
                      path: Paths.LIFEEVENTSub,
                      name: Routes.LIFEEVENTSub,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          LifeEventSubCategories(
                            lifeEvent: state.extra as LifeEventEntity,
                          )),
                    ),
                    GoRoute(
                      path: Paths.CREATELIFEEVENT,
                      name: Routes.CREATELIFEEVENT,
                      pageBuilder: (context, state) {
                        return customTransition(
                            context,
                            state,
                            CreateLifeEvent(
                              lifeEventData: state.extra as LifeEventEntity,
                            ));
                      },
                    ),
                    GoRoute(
                      path: Paths.FacebookSuggestPeople,
                      name: Routes.FacebookSuggestPeople,
                      pageBuilder: (context, state) {
                        // final social = state.extra as String?;

                        return customTransition(
                            context,
                            state,
                            BlocProvider<SocialPostsCubit>(
                              create: (_) => serviceLocator(),
                              child: const FacebookSuggestedPeople(),
                            ));
                      },
                    ),
                    GoRoute(
                        path: Paths.TWITTER,
                        name: Routes.TWITTER,
                        pageBuilder: (context, state) => customTransition(
                              context,
                              state,
                              const Twitter11(),
                            ),
                        routes: const []),
                    GoRoute(
                      path: Paths.TWITTERPOSTDETAILS,
                      name: Routes.TWITTERPOSTDETAILS,
                      pageBuilder: (context, state) {
                        // state.extra can be null / String / Map – pass it through as-is
                        final dynamic payload = state.extra;

                        return customTransition(
                          context,
                          state,
                          BlocProvider<TwitterCubit>(
                            create: (_) => serviceLocator<TwitterCubit>(),
                            child: TwitterPostDetailsNotify.fromPayload(
                                payload: payload),
                          ),
                        );
                      },
                    ),
                    GoRoute(
                        path: Paths.OTHERSACCOUNT,
                        name: Routes.OTHERSACCOUNT,
                        pageBuilder: (context, state) {
                          return customTransition(
                              context,
                              state,
                              BlocProvider<SocialPostsCubit>(
                                  create: (_) => serviceLocator(),
                                  child: OtherAccountView(
                                    payload: state.extra,
                                  )));
                        },
                        routes: [
                          GoRoute(
                            path: Paths.EDITPROFILE,
                            name: Routes.EDITPROFILE,
                            pageBuilder: (context, state) => customTransition(
                              context,
                              state,
                              BlocProvider<EditProfileCubit>(
                                  create: (_) =>
                                      serviceLocator<EditProfileCubit>()
                                        ..fetchRideGovernorates(),
                                  child: const EditProfileView()),
                            ),
                          ),
                        ]),
                    GoRoute(
                      path: Paths.TINDER,
                      name: Routes.Tinder,
                      pageBuilder: (context, state) =>
                          customTransition(context, state, const TinderView()),
                    ),
                    GoRoute(
                      path: Paths.UserProfilePage,
                      name: Routes.UserProfilePage,
                      pageBuilder: (context, state) => customTransition(
                          context, state, const UserProfilePage()),
                    ),
                    GoRoute(
                      path: Paths.FindMyProfileScreen,
                      name: Routes.FindMyProfileScreen,
                      pageBuilder: (context, state) => customTransition(
                          context, state, const FindMyProfileScreen()),
                    ),
                    GoRoute(
                      path: Paths.EditProfileTinder,
                      name: Routes.EditProfileTinder,
                      pageBuilder: (context, state) => customTransition(
                          context, state, const EditProfileTinder()),
                    ),
                    GoRoute(
                        path: Paths.LIVE,
                        name: Routes.LIVE,
                        pageBuilder: (context, state) => customTransition(
                              context,
                              state,
                              MultiBlocProvider(
                                providers: [
                                  //club voice
                                  BlocProvider<ClubVoiceCubit>(
                                    create: (context) =>
                                        serviceLocator()..loadData(),
                                    child: const ClubHouseHome(),
                                  ),
                                ],
                                child: const LiveStreamHomeScreen(),
                              ),
                            ),
                        routes: [
                          GoRoute(
                              path: Paths.LIVEVIEW,
                              name: Routes.LIVEView,
                              pageBuilder: (context, state) {
                                var extras = state.extra as ZegoArgs;
                                return customTransition(
                                    context,
                                    state,
                                    LiveStreamView(
                                      isHost: extras.isHost,
                                      liveID: extras.liveId,
                                    ));
                              }),

                          // ClubHouseHome

                          GoRoute(
                            path: Paths.CLUBHOUSEROOM,
                            name: Routes.AUDIOSTREAMSCREEN,
                            pageBuilder: (context, state) {
                              final extras = state.extra as RoomArgs;
                              return customTransition(
                                  context,
                                  state,
                                  AudioStreamScreen(
                                    liveId: extras.liveId,
                                    roomSubject: extras.subject,
                                    isHost: extras.isHost,
                                  ));
                            },
                            routes: const [],
                          ),
                        ]),
                  ]),
              GoRoute(
                path: Paths.Married,
                name: Routes.Married,
                pageBuilder: (context, state) =>
                    customTransition(context, state, const MarriedView()),
              ),
              // MazadatView
              // GoRoute(
              //     path: Paths.MAZADAT,
              //     name: Routes.MAZADAT,
              //     pageBuilder: (context, state) => customTransition(
              //           context,
              //           state,
              //           BlocProvider<AuctionListCubit>(
              //               child: const MazadatView(),
              //               create: (_) => serviceLocator()),
              //         ),
              //     routes: [
              //       GoRoute(
              //         path: Paths.MAZADDETAILS,
              //         name: Routes.MAZADDETAILS,
              //         pageBuilder: (context, state) => customTransition(
              //           context,
              //           state,
              //           BlocProvider<AuctionDetailsCubit>(
              //             create: (_) => serviceLocator(),
              //             child: MazadDetails(id: state.extra as String),
              //           ),
              //         ),
              //       ),
                    // CreateAuctionView
                  //   GoRoute(
                  //     path: Paths.CREATEAUCTION,
                  //     name: Routes.CREATEAUCTION,
                  //     pageBuilder: (context, state) => customTransition(
                  //         context,
                  //         state,
                  //         BlocProvider.value(
                  //           value: serviceLocator<CreateAuctionCubit>(),
                  //           child: CreateAuctionView(
                  //             adId: state.extra as String,
                  //           ),
                  //         )),
                  //   ),
                  //   // OtherAccountView
                  // ]),

              // ChatView
              GoRoute(
                path: Paths.CHAT,
                name: Routes.CHAT,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<ChatsCubit>(
                        create: (_) => serviceLocator(),
                      ),
                      // BlocProvider(
                      //   create: (context) => serviceLocator<ChatRoomCubit>(),
                      // ),
                    ],
                    child: ChatView(
                        chatsViewParams: state.extra as ChatsViewParams),
                  ),
                ),
              ),

              // Chat Home
              GoRoute(
                path: Paths.CHAT_HOME,
                name: Routes.CHAT_HOME,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider<ChatCubit>(
                    create: (_) => serviceLocator(),
                    child: const ChatHomePage(),
                  ),
                ),
              ),

              GoRoute(
                path: Paths.conversationsScreen,
                name: Routes.conversationsScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider.value(
                    value: serviceLocator<ConversationsCubit>(),
                    child: const ConversationsScreen(),
                  ),
                ),
              ),

              GoRoute(
                path: Paths.socialArchivedScreen,
                name: Routes.socialArchivedScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  SocialArchivedConversationsScreen(),
                ),
              ),

              GoRoute(
                path: Paths.socialDeletedScreen,
                name: Routes.socialDeletedScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  SocialDeletedConversationsScreen(),
                ),
              ),

              // Chat Room
              GoRoute(
                  path: Paths.CHATROOM,
                  name: Routes.CHATROOM,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        ChatRoomView(chatsCubit: state.extra as ChatsCubit),
                      ),
                  routes: [
                    GoRoute(
                      path: Paths.CHATROOMCAMERAPICKER,
                      name: Routes.CHATROOMCAMERAPICKER,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        CameraPickerView(
                          prams: state.extra as CameraPickerViewPrams,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.MEDIASLIDER,
                      name: Routes.MEDIASLIDER,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        MediaSliderView(
                            chatRoomCubit: (state.extra) as ChatRoomCubit),
                      ),
                    ),
                    GoRoute(
                      path: Paths.VIEWCONTACT,
                      name: Routes.VIEWCONTACT,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        ViewContactView(
                          chatsCubit: state.extra as ChatsCubit,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.ATTACHMENTSVIEW,
                      name: Routes.ATTACHMENTSVIEW,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        AttachementsView(
                          chatRoomCubit: state.extra as ChatRoomCubit,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.SELECTCONTACTSTOSHARE,
                      name: Routes.SELECTCONTACTSTOSHARE,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        SelectContactsToShareView(
                          chatRoomCubit: state.extra as ChatRoomCubit,
                        ),
                      ),
                    ),
                  ]),
              // Snap

              GoRoute(
                path: Paths.SNAP,
                name: Routes.SNAP,
                pageBuilder: (context, state) =>
                    customTransition(context, state, const SnapView()),
              ),
              // Spotlight
              GoRoute(
                path: Paths.SPOTLIGHT,
                name: Routes.SPOTLIGHT,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
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
              ),
              // _________________ services ____________

              GoRoute(
                  path: Paths.VISITA,
                  name: Routes.VISITA,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        MultiBlocProvider(
                          providers: [
                            BlocProvider<HealthCubit>(
                              create: (_) =>
                                  serviceLocator<HealthCubit>()..loadData(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<SubcategoriesCubit>(),
                            ),
                          ],
                          child: const HealthView(),
                        ),
                      ),
                  routes: [
                    GoRoute(
                      path: Paths.CREATERESTURANT,
                      name: Routes.CREATERESTURANT,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<CreateResturantCubit>(
                          create: (context) => serviceLocator(),
                          child: const CreateResturantView(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.VISITAEMERGENCY,
                      name: Routes.VISITAEMERGENCY,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<HealthEmergencyCubit>(
                          create: (context) => serviceLocator(),
                          child: const HealthEmergencyView(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.EMERGENCYREQUESTS,
                      name: Routes.EMERGENCYREQUESTS,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<EmergencyRequestsCubit>(
                          create: (context) => serviceLocator(),
                          child: EmergencyRequestsView(
                            subCategoryId: state.extra as String,
                          ),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.ALLAPPOINTMENTS,
                      name: Routes.ALLAPPOINTMENTS,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<AllAppointmentsCubit>(
                          create: (context) => serviceLocator(),
                          child: const AllAppointmentsView(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.CREATEDOCTOR,
                      name: Routes.CREATEDOCTOR,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<CreateDoctorCubit>(
                          create: (context) => serviceLocator(),
                          child: const CreateDoctorView(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.FILTERDOCTORSUBCATEGORY,
                      name: Routes.FILTERDOCTORSUBCATEGORY,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<DoctorSubcategoryFilterCubit>(
                          create: (context) => serviceLocator(),
                          child: DoctorSubcategoryFilterView(
                            type: state.extra as String,
                          ),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.FILTERDOCTORGOVERNORATE,
                      name: Routes.FILTERDOCTORGOVERNORATE,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<DoctorGovernorateFilterCubit>(
                          create: (context) => serviceLocator(),
                          child: DoctorGovernorateFilterView(
                            type: state.extra as String,
                          ),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.FILTERDOCTORCITY,
                      name: Routes.FILTERDOCTORCITY,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<DoctorCityFilterCubit>(
                          create: (context) => serviceLocator(),
                          child: DoctorCityFilterView(
                            type: state.extra as String,
                          ),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: Paths.VISITADOCTORLIST,
                      name: Routes.VISITADOCTORLIST,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<DoctorsListCubit>(
                          // BlocProvider<HealthCubit>(
                          create: (context) => serviceLocator(),
                          child: DoctorsListView(
                            params: state.extra as DoctorsListParams,
                          ),
                        ),
                      ),
                    ),
                    GoRoute(
                        path: Paths.VISITADOCTORDETAILS,
                        name: Routes.VISITADOCTORDETAILS,
                        pageBuilder: (context, state) {
                          return customTransition(
                              context,
                              state,
                              BlocProvider<DoctorDetailsCubit>(
                                  child: DoctorDetailsView(
                                    payload: state.extra as dynamic,
                                  ),
                                  create: (_) => serviceLocator()));
                        }),
                    GoRoute(
                      path: Paths.VISITABOOKING,
                      name: Routes.VISITABOOKING,
                      // BookDoctorAppointmentCubit
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<BookDoctorAppointmentCubit>(
                              create: (_) => serviceLocator(),
                              child: BookingConfirmationScreen(
                                doctorDetailsCubit:
                                    (state.extra) as DoctorDetailsCubit,
                              )

                              // child: VisitaBooking(
                              //   doctorDetailsCubit:
                              //       (state.extra) as DoctorDetailsCubit,
                              // )
                              )),
                    ),
                    GoRoute(
                      path: Paths.SUCCESSFULLBOOKING,
                      name: Routes.SUCCESSFULLBOOKING,
                      // BookDoctorAppointmentCubit
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<BookDoctorAppointmentCubit>(
                              create: (_) => serviceLocator(),
                              child: SuccessfulBookingScreen(
                                doctorDetailsCubit:
                                    (state.extra) as DoctorDetailsCubit,
                              ))),
                    ),
                    GoRoute(
                      path: Paths.DOCTORDASHBOARD,
                      name: Routes.DOCTORDASHBOARD,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<DoctorDashboardCubit>(
                              create: (_) => serviceLocator()..loadData(),
                              child: const DoctorDashboardView())),
                    ),
                    GoRoute(
                      path: Paths.EDITDOCTORPROFILE,
                      name: Routes.EDITDOCTORPROFILE,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<EditDoctorProfileCubit>(
                            create: (context) => serviceLocator(),
                            child: const EditDoctorProfileView(),
                          )),
                    ),
                    GoRoute(
                      path: Paths.EDITDOCTORPERSONALINFO,
                      name: Routes.EDITDOCTORPERSONALINFO,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider(
                              create: (_) =>
                                  serviceLocator<EditDoctorPersonalInfoCubit>(),
                              child: EditDoctorPersonalInfoView(
                                doctor: state.extra as DoctorEntity,
                              ))),
                    ),
                    GoRoute(
                      path: Paths.EDITDOCTORTIMETABLE,
                      name: Routes.EDITDOCTORTIMETABLE,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider(
                              create: (_) =>
                                  serviceLocator<EditDoctorTimetableCubit>(),
                              child: EditDoctorTimetableView(
                                params: state.extra as CheckBoxParams,
                              ))),
                    ),
                    GoRoute(
                      path: Paths.DOCTORSTATISTICS,
                      name: Routes.DOCTORSTATISTICS,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<DoctorStatisticsCubit>(
                            create: (context) => serviceLocator(),
                            child: DoctorStatisticsView(
                              totalEarnedMoney:
                                  state.extra as List<EarnedMoneyEntity>,
                            ),
                          )),
                    ),
                    GoRoute(
                      path: Paths.DOCTORREVIEWS,
                      name: Routes.DOCTORREVIEWS,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<DoctorDetailsCubit>(
                              create: (_) => serviceLocator(),
                              child: AllReviews(
                                doctorId: state.extra as String,
                              ))),
                    ),
                    GoRoute(
                      path: Paths.DOCTORTODAYAPPOINTMENTS,
                      name: Routes.DOCTORTODAYAPPOINTMENTS,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<DoctorTodayAppointmentsCubit>(
                            create: (context) => serviceLocator(),
                            child: const DoctorTodayAppointmentsView(),
                          )),
                    ),
                    GoRoute(
                      path: Paths.DOCTORUNHANDLEDAPPOINTMENTS,
                      name: Routes.DOCTORUNHANDLEDAPPOINTMENTS,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<DoctorUnhandledAppointmentsCubit>(
                            create: (context) => serviceLocator(),
                            child: const DoctorUnhandledAppointmentsView(),
                          )),
                    ),
                    GoRoute(
                      path: Paths.ALLDOCTORRESERVATIONS,
                      name: Routes.ALLDOCTORRESERVATIONS,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<AllDoctorReservationsCubit>(
                            create: (context) => serviceLocator(),
                            child: const AllDoctorReservationsView(),
                          )),
                    ),
                  ]),
              GoRoute(
                  path: Paths.FOOD,
                  name: Routes.FOOD,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        MultiBlocProvider(
                          providers: [
                            BlocProvider<RestaurantsCubit>(
                              create: (context) => serviceLocator()
                                ..loadData()
                                ..getReqCount(),
                            ),
                          ],
                          child: const RestaurantsListsView(),
                        ),
                      ),
                  routes: [
                    // CusineRestaurantsView
                    // GoRoute(
                    //   path: Paths.RestaurantDashboard,
                    //   name: Routes.RestaurantDashboard,
                    //  pageBuilder: (context, state) =>
                    // customTransition(context, state,
                    //       BlocProvider<RestaurantDashboardCubit>(
                    //     create: (_) => serviceLocator(),
                    //     child:  RestaurantDashboardView(),
                    //   ),
                    // ),
                    GoRoute(
                      path: Paths.CusineRestaurants,
                      name: Routes.CusineRestaurants,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<CusineRestaurantsCubit>(
                          create: (_) => serviceLocator(),
                          child: const CusineRestaurantsView(),
                        ),
                      ),
                    ),
                    GoRoute(
                        path: Paths.RESTAURANTDETAILS,
                        name: Routes.RESTAURANTDETAILS,
                        pageBuilder: (context, state) => customTransition(
                              context,
                              state,
                              BlocProvider(
                                create: (context) =>
                                    serviceLocator<RestaurantDetailsCubit>(),
                                child: RestaurantDetailsView(
                                  restaurant:
                                      state.extra as GetAllRestaurantEntity,
                                ),
                              ),
                            ),
                        routes: [
                          GoRoute(
                              path: Paths.FOODCART,
                              name: Routes.FOODCART,
                              pageBuilder: (context, state) => customTransition(
                                  context,
                                  state,
                                  BlocProvider(
                                    create: (context) => serviceLocator<
                                        RestaurantDetailsCubit>(),
                                    child: const FoodCartView(),
                                  ))),
                        ])
                  ]),
              GoRoute(
                path: Paths.CONTACTUS,
                name: Routes.CONTACTUS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider<ContactUsCubit>(
                    create: (_) => serviceLocator(),
                    child: const ContactUsView(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.SHIPPING,
                name: Routes.SHIPPING,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
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
              ),
              GoRoute(
                  path: Paths.RIDE,
                  name: Routes.RIDE,
                  pageBuilder: (context, state) {
                    return customTransition(
                        context,
                        state,
                        MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<GetCateogryRiderCubit>(),
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
                              create: (context) => GetTripInfoCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetTripInfoCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => StartingLocationCubit(
                                  fetchLocationCordinatesUseCase:
                                      serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => FetchPriceDistanceCubit(
                                  fetchPriceDistanceUsecase: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => FavoriteShippingCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => FavoriteShippingCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => RequestRiderTripCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  RaiseFareCubit(repository: serviceLocator()),
                            ),
                            BlocProvider<ShippingCubit>(
                              create: (context) =>
                                  serviceLocator<ShippingCubit>()
                                    ..getBannerData(),
                            ),
                            BlocProvider<GetMyTripCubit>(
                              create: (context) =>
                                  serviceLocator<GetMyTripCubit>()..getMyTrip(),
                            ),
                            BlocProvider<CreateTripCubit>(
                              create: (context) =>
                                  serviceLocator<CreateTripCubit>(),
                            ),
                            BlocProvider<GetAllRequestByMyTripCubit>(
                              create: (context) =>
                                  serviceLocator<GetAllRequestByMyTripCubit>(),
                            ),
                            BlocProvider<CallMessageCubit>(
                              create: (context) =>
                                  serviceLocator<CallMessageCubit>(),
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
                              create: (context) =>
                                  serviceLocator<TwitterCubit>(),
                            ),
                            BlocProvider(
                              create: (context) => CheckDriverTypeCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => DestinationLocationCubit(
                                  fetchLocationCordinatesUseCase:
                                      serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => MapBoxCubit(),
                            ),
                            BlocProvider(
                              create: (context) => MapBoxDestCubit(),
                            ),
                            BlocProvider(
                              create: (context) => SelectCateogryCubit(),
                            ),
                            BlocProvider(
                              create: (context) => CreateTripRequestRideCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  GetLocationFromLatLngRideCubit(
                                      repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetStartingPointRideCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetDestinationPointRideCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetTripInfoCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  GetCurrencyCubit(serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  GetCurrencyCubit(serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  GetCurrencyCubit(serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  GetUserLoginTripNoSocketCubit(
                                      repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetTripOffersNoSocketCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => AcceptOfferNoSocketCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => DeclineOfferNoSocketCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => DeleteOfferRideCubit(
                                  repository: serviceLocator()),
                            ),
                          ],
                          child: const ShippingRiderTabScreen(),
                        ));
                  },
                  routes: [
                    GoRoute(
                      path: Paths.registerRidePart,
                      name: Routes.registerRidePart,
                      pageBuilder: (context, state) {
                        return customTransition(
                            context, state, const RegisterRidePartsScreen());
                      },
                    ),
                    GoRoute(
                      path: Paths.updateDriverShipping,
                      name: Routes.updateDriverShipping,
                      pageBuilder: (context, state) {
                        return customTransition(
                            context,
                            state,
                            MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (context) =>
                                        GetDriverInfoShippingCubit(
                                            repository: serviceLocator())),
                              ],
                              child: const UpdateDriverShippingScreen(),
                            ));
                      },
                    ),
                    GoRoute(
                      path: Paths.updateDriverRide,
                      name: Routes.updateDriverRide,
                      pageBuilder: (context, state) {
                        return customTransition(
                            context,
                            state,
                            MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => GetDriverRideCubit(
                                      repository: serviceLocator())
                                    ..get(),
                                ),
                                BlocProvider(
                                    create: (context) => PictureOptionalCubit(
                                        repository: serviceLocator())
                                      ..getData()),
                                BlocProvider(
                                    create: (context) =>
                                        SelectCarModelBrandYearRideCubit()),
                                BlocProvider(
                                    create: (context) => GetCarBrandRideCubit(
                                        repository: serviceLocator())
                                      ..get()),
                                BlocProvider(
                                  create: (context) =>
                                      GetCarYearByModelRideCubit(
                                          repository: serviceLocator()),
                                ),
                                BlocProvider(
                                    create: (context) =>
                                        GetCarModelByBrandRideCubit(
                                            repository: serviceLocator())),
                                BlocProvider(
                                  create: (context) =>
                                      GetCarYearByModelRideCubit(
                                          repository: serviceLocator()),
                                ),
                                BlocProvider.value(
                                  value: serviceLocator<HealthCubit>()
                                    ..getGovernorates(),
                                ),
                              ],
                              child: const UpdateDriverRideScreen(),
                            ));
                      },
                    ),
                    GoRoute(
                      path: Paths.TripRideRating,
                      name: Routes.TripRideRating,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          TripRatingRideScreen(
                              model: state.extra as ReviewRideTripModel)),
                    ),
                    GoRoute(
                      path: Paths.TRIPINFOBYDRIVERSCREEN,
                      name: Routes.TRIPINFOBYDRIVERSCREEN,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          MultiBlocProvider(
                            providers: [
                              // BlocProvider(create: (context) => CheckTripEndCubit(repository: serviceLocator())),
                              BlocProvider(
                                create: (context) => GetReasonsCubit(
                                    repository: serviceLocator()),
                              ),
                              BlocProvider(
                                create: (context) => RiderInStartLocationCubit(
                                    repository: serviceLocator()),
                              ),
                              BlocProvider(
                                create: (context) => CancelTripRiderCubit(
                                    repository: serviceLocator()),
                              ),
                              BlocProvider(
                                create: (context) => CompletedTripRiderCubit(
                                    repository: serviceLocator()),
                              ),
                            ],
                            child: TripInfoByDriverScreen(
                                model: state.extra as CheckAcceptByRiderModel),
                          )),
                    ),
                    GoRoute(
                      path: Paths.TRIPINFOBYRIDERSCREEN,
                      name: Routes.TRIPINFOBYRIDERSCREEN,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => GetReasonsCubit(
                                      repository: serviceLocator()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      RiderInStartLocationCubit(
                                          repository: serviceLocator()),
                                ),
                                BlocProvider(
                                  create: (context) => CancelTripClientCubit(
                                      repository: serviceLocator()),
                                ),
                                BlocProvider(
                                  create: (context) => CompletedTripRiderCubit(
                                      repository: serviceLocator()),
                                ),
                                BlocProvider(
                                  create: (context) => PartialPaymentRiderCubit(
                                      repository: serviceLocator()),
                                ),
                                BlocProvider(
                                  create: (context) => GetTripInfoCubit(
                                      repository: serviceLocator()),
                                ),
                                // BlocProvider(create: (context) => CheckTripEndCubit(repository: serviceLocator()))
                              ],
                              child: TripInfoByRiderScreen(
                                  model: state.extra
                                      as CheckAcceptTripFromDriverModel))),
                    ),
                    GoRoute(
                      path: Paths.ALLTRIPRIDER,
                      name: Routes.ALLTRIPRIDER,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          MultiBlocProvider(providers: [
                            BlocProvider(
                              create: (context) => GetExpiredTripCubit(
                                  repository: serviceLocator())
                                ..get(),
                            ),
                            BlocProvider(
                              create: (context) => GetDriverInfoCubit(
                                  repository: serviceLocator())
                                ..get(),
                            ),
                            BlocProvider(
                              create: (context) => DeleteDriverRideCubit(
                                  repository: serviceLocator()),
                            ),
                            // BlocProvider(
                            //   create: (context) => GetAllTripRiderCubit(
                            //       repository: serviceLocator())
                            //     ..getAllTrip(),
                            // ),
                            BlocProvider(
                              create: (context) => VerifyCompleteDriverCubit(
                                  verifyOtpCompleteSeatDriverRemoteDataSource:
                                      serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  GetCurrencyCubit(serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  GetAvailableTripsForDriversCubit(),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  AcceptTripForDriverCubit(serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetRouteRiderCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  ChangeDriverStatusCubit(serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetRouteRiderCubit(
                                  repository: serviceLocator()),
                            ),
                          ], child: const AllRiderTripScreen())),
                      // BlocProvider(
                      //   create: (_) => GetAllTripRiderCubit(repository: serviceLocator())..getAllTrip(),
                      //   child: const AllRiderTripScreen(),
                      // )
                    ),
                    GoRoute(
                      path: Paths.ALLTRIPNOSOCKETSCREEN,
                      name: Routes.ALLTRIPNOSOCKETSCREEN,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          MultiBlocProvider(providers: [
                            BlocProvider(
                              create: (context) => SendOfferNoSocketCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetDriverInfoCubit(
                                  repository: serviceLocator())
                                ..get(),
                            ),
                            BlocProvider(
                              create: (context) => DeleteDriverRideCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  GetUserLoginTripNoSocketCubit(
                                      repository: serviceLocator())
                                    ..get(),
                            ),
                            BlocProvider(
                              create: (context) => GetTripOffersNoSocketCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => OfferNoSocketActionsCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  ChangeDriverStatusCubit(serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => GetAllTripNoSocketCubit(
                                  repository: serviceLocator())
                                ..get(),
                            ),
                            BlocProvider(
                              create: (context) => DeclineOfferNoSocketCubit(
                                  repository: serviceLocator()),
                            ),
                            BlocProvider(
                              create: (context) => CallMessageCubit(
                                  repository: serviceLocator()),
                            ),
                          ], child: const AllTripNoSocketScreen())
                          // BlocProvider(
                          //   create: (_) => GetAllTripRiderCubit(repository: serviceLocator())..getAllTrip(),
                          //   child: const AllRiderTripScreen(),
                          // )
                          ),
                    ),
                    GoRoute(
                      path: Paths.REQUESTSHISTORY,
                      name: Routes.REQUESTSHISTORY,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<RequestHistoryCubit>(
                            create: (_) => serviceLocator(),
                            child: BlocProvider(
                              create: (context) => RequestHistoryRideCubit(
                                  apiConsumer: serviceLocator()),
                              child: const HistoryRequestsView(),
                            ),
                          )),
                    ),
                    GoRoute(
                      path: Paths.TRIPDETAILS,
                      name: Routes.TRIPDETAILS,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          BlocProvider<TripDetailsCubit>(
                            create: (_) => serviceLocator(),
                            child: const TripDetailsView(),
                          )),
                    ),
                    GoRoute(
                      path: Paths.RIDERDASHBOARD,
                      name: Routes.RIDERDASHBOARD,
                      pageBuilder: (context, state) => customTransition(
                          context,
                          state,
                          MultiBlocProvider(
                            providers: [
                              BlocProvider<DriverDashboardCubit>(
                                create: (_) => serviceLocator(),
                              ),
                              BlocProvider(
                                create: (context) => DriverStatisticsCubit(
                                    repository: serviceLocator()),
                              ),
                            ],
                            child: const DriverDashboardView(),
                          )),
                    ),
                    GoRoute(
                        path: Paths.RIDERREGISTER,
                        name: Routes.RIDERREGISTER,
                        pageBuilder: (context, state) => customTransition(
                            context,
                            state,
                            MultiBlocProvider(
                              providers: [
                                BlocProvider<DriverDashboardCubit>(
                                  create: (_) => serviceLocator(),
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
                                      SelectCarModelBrandYearRideCubit(),
                                ),
                                BlocProvider(
                                  create: (context) => GetCarColorsRideCubit(
                                      repository: serviceLocator())
                                    ..get(),
                                ),
                                BlocProvider(
                                  create: (context) => GetCarBrandRideCubit(
                                      repository: serviceLocator())
                                    ..get(),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      GetCarModelByBrandRideCubit(
                                          repository: serviceLocator()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      GetCarYearByModelRideCubit(
                                          repository: serviceLocator()),
                                ),
                                BlocProvider(
                                  create: (_) => serviceLocator<HealthCubit>()
                                    ..getGovernorates(),
                                ),
                                BlocProvider(
                                  create: (context) => PictureOptionalCubit(
                                      repository: serviceLocator())
                                    ..getData(),
                                ),
                              ],
                              child: const RiderRegisterView(),
                            ))),
                  ]),
              GoRoute(
                  path: Paths.YOUTUBE,
                  name: Routes.YOUTUBE,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        const YouTubeView(),
                      ),
                  routes: [
                    // PlayVideo
                    GoRoute(
                      path: Paths.PLAYVIDEO,
                      name: Routes.PLAYVIDEO,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        const PlayVideo(),
                      ),
                    )
                  ]),
              GoRoute(
                  path: Paths.ZOOM,
                  name: Routes.ZOOM,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<StreamCubit>(
                          create: (context) => serviceLocator<StreamCubit>()
                            ..getScheduledMeetings(),
                          child: const MeetingView(),
                        ),
                      ),
                  // create: (context) => serviceLocator<StreamCubit>()..getScheduledMeetings(),
                  // child: const MeetingView(),

                  routes: [
                    // PlayVideo
                    GoRoute(
                      path: Paths.MEETINGROOM,
                      name: Routes.MEETINGROOM,
                      pageBuilder: (context, state) {
                        return customTransition(
                            context,
                            state,
                            MeetingRoom(
                              payload: state.extra as dynamic,
                            ));
                      },
                    ),
                  ]),
              GoRoute(
                  path: Paths.INSTALLMENT,
                  name: Routes.INSTALLMENT,
                  pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<InstallmentListCubit>(
                            create: (_) => serviceLocator(),
                            child: const InstallmentView()),
                      ),
                  routes: [
                    GoRoute(
                      path: Paths.INSTALLMENTDETAILS,
                      name: Routes.INSTALLMENTDETAILS,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<InstallmentDetailsCubit>(
                            create: (_) => serviceLocator(),
                            child: InstallmentsDetails(
                              installmentId: state.extra as String,
                            )),
                      ),
                    ),
                    // CreateInstallmentView
                    GoRoute(
                      path: Paths.CREATEINSTALLMENT,
                      name: Routes.CREATEINSTALLMENT,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        BlocProvider<CreateInstallmentCubit>(
                            create: (_) => serviceLocator(),
                            child: CreateInstallmentView(
                              adId: state.extra as String,
                            )),
                      ),
                    ),
                    GoRoute(
                      path: Paths.INSTALLMENTORDERDETAILS,
                      name: Routes.INSTALLMENTORDERDETAILS,
                      pageBuilder: (context, state) => customTransition(
                        context,
                        state,
                        const InstallmentOrderDetails(),
                      ),
                    ),
                    GoRoute(
                        path: Paths.INSTALLMENTORDERS,
                        name: Routes.INSTALLMENTORDERS,
                        pageBuilder: (context, state) => customTransition(
                              context,
                              state,
                              const InstallmentOrdersList(),
                            )),
                  ]),
              // ___________________ shipping ______________
              GoRoute(
                path: Paths.SHIPPING_REGISTER,
                name: Routes.SHIPPING_REGISTER,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(providers: [
                    BlocProvider(
                      create: (context) => serviceLocator<ShippingCubit>(),
                    ),
                    //to be reviewed

                    BlocProvider(
                      create: (context) => serviceLocator<CreateDoctorCubit>(),
                    ),
                    BlocProvider(
                      create: (context) => serviceLocator<HealthCubit>(),
                    ),
                  ], child: const RegisterShippingScreen()),
                ),
              ),
              GoRoute(
                path: Paths.DASHBOARDDRIVERSCREEN,
                name: Routes.DASHBOARDDRIVERSCREEN,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<RequestHistoryCubit>(
                          create: (_) => serviceLocator(),
                        ),
                        BlocProvider(
                          create: (context) =>
                              GetAllTripCubit(repository: serviceLocator()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CallMessageCubit(repository: serviceLocator()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              TripCubit(repository: serviceLocator()),
                        ),
                      ],
                      child: const DahsboardDriverScreen(),
                    )),
              ),
              GoRoute(
                path: Paths.TripRating,
                name: Routes.TripRating,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<RequestHistoryCubit>(
                          create: (_) => serviceLocator(),
                        ),
                        BlocProvider(
                          create: (context) =>
                              GetAllTripCubit(repository: serviceLocator()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CallMessageCubit(repository: serviceLocator()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              TripCubit(repository: serviceLocator()),
                        ),
                      ],
                      child: TripRatingScreen(
                          model: state.extra as GetRequestsForLoadingModel),
                    )),
              ),

              // Be a Star
              GoRoute(
                path: Paths.BE_STAR,
                name: Routes.BE_STAR,
                routes: [
                  GoRoute(
                    path: Paths.BE_STAR_DETAILS,
                    name: Routes.BE_STAR_DETAILS,
                    pageBuilder: (context, state) {
                      return customTransition(
                          context,
                          state,
                          BlocProvider<StarCubit>(
                              create: (_) => serviceLocator(),
                              child: const AllWinnerView()));
                    },
                  ),
                ],
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<StarCubit>(
                          create: (_) => serviceLocator(),
                        ),
                        // أضف هذا السطر
                        BlocProvider<CommentCubit>(
                          create: (_) => serviceLocator(),
                        ),
                      ],
                      child: const BeStarView(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: Paths.TenPercent,
                name: Routes.TenPercent,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      BlocProvider<TenPercentCubit>(
                          create: (_) => serviceLocator(),
                          child: const TenPercentView()));
                },
              ),
              GoRoute(
                path: Paths.WinnersTenPercent,
                name: Routes.WinnersTenPercent,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<WinnersTenPercentCubit>()
                              ..getWinners(),
                        child: const WinnersTenPercentView(),
                      ));
                },
              ),

              // ___________________ trip join ______________
              GoRoute(
                path: Paths.TRIP_JOIN,
                name: Routes.TRIP_JOIN,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => StartingLocationCubit(
                          fetchLocationCordinatesUseCase:
                              serviceLocator<FetchLocationCordinatesUseCase>(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => DestinationLocationCubit(
                          fetchLocationCordinatesUseCase:
                              serviceLocator<FetchLocationCordinatesUseCase>(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => FetchPriceDistanceCubit(
                          fetchPriceDistanceUsecase:
                              serviceLocator<FetchPriceDistanceUsecase>(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => FetchCarBrandsCubit(
                          fetchCarBrandUseCase:
                              serviceLocator<FetchCarBrandUseCase>(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => FetchCarModelsCubit(
                          fetchCarModelUseCase:
                              serviceLocator<FetchCarModelUseCase>(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => FetchCarYearTypeCubit(
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
                      BlocProvider(
                        create: (_) => GetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                      BlocProvider(
                        create: (_) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                      BlocProvider(create: (_) => TripJoinViewCubit()),
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      ),
                      BlocProvider(
                        create: (_) => serviceLocator<ViewAllTripJoinCubit>(),
                      ),
                    ],
                    child: TripJoinCreateAdView(
                      isFromPickMe: state.extra as bool,
                    ),
                    //const TripJoinView(),
                  ),
                ),
              ),

              //________________________AddNewPickMe____________________-
              GoRoute(
                path: Paths.AddNewPickMe,
                name: Routes.AddNewPickMe,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<AddNewPickMeTripCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      )
                    ],
                    child: const AddNewPickMeView(),
                  ),
                ),
              ),

              // ___________________ Available Trips ______________
              GoRoute(
                path: Paths.AVAILABLE_TRIPS,
                name: Routes.AVAILABLE_TRIPS,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<ViewAllTripJoinCubit>(),

                        // create: (_) => ViewAllTripJoinCubit(
                        //   viewAllTripJoinUseCase:
                        //       serviceLocator<ViewAllTripJoinUseCase>(),
                        // ),
                      ),
                      BlocProvider(
                        create: (_) => RequestTripJoinCubit(
                          requestTripJoinUseCase:
                              serviceLocator<RequstTripJoinUseCase>(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => ViewAllPickMeCubit(
                          viewAllPickMeUseCase:
                              serviceLocator<ViewAllPickMeUseCase>(),
                        ),
                      ),
                      BlocProvider<GetCurrencyCubit>(
                        create: (context) => GetCurrencyCubit(
                          serviceLocator(),
                        ),
                      ),
                      // car pool
                      BlocProvider<GetAllTripsCubit>(
                        create: (context) =>
                            GetAllTripsCubit(apiConsumer: serviceLocator()),
                      ),
                      BlocProvider<GetCurrencyCubit>(
                        create: (context) => GetCurrencyCubit(
                          serviceLocator(),
                        ),
                      ),
                      BlocProvider<JoinTripCarPoolCubit>(
                        create: (context) => JoinTripCarPoolCubit(
                            joinTripCarpoolUsecase: serviceLocator()),
                      ),
                      BlocProvider<AdvertisementCubit>(
                        create: (context) =>
                            serviceLocator<AdvertisementCubit>(),
                      ),
                    ],
                    child: const TripJoinView(
                      initialIndex: 1,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.All_PickMe_View,
                name: Routes.All_PickMe_View,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<ViewAllTripJoinCubit>(),

                        // create: (_) => ViewAllTripJoinCubit(
                        //   viewAllTripJoinUseCase:
                        //       serviceLocator<ViewAllTripJoinUseCase>(),
                        // ),
                      ),
                      BlocProvider(
                        create: (_) => RequestTripJoinCubit(
                          requestTripJoinUseCase:
                              serviceLocator<RequstTripJoinUseCase>(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) => ViewAllPickMeCubit(
                          viewAllPickMeUseCase:
                              serviceLocator<ViewAllPickMeUseCase>(),
                        ),
                      ),
                      BlocProvider<GetCurrencyCubit>(
                        create: (context) => GetCurrencyCubit(
                          serviceLocator(),
                        ),
                      ),
                      // car pool
                      BlocProvider<GetAllTripsCubit>(
                        create: (context) =>
                            GetAllTripsCubit(apiConsumer: serviceLocator()),
                      ),
                      BlocProvider<GetCurrencyCubit>(
                        create: (context) => GetCurrencyCubit(
                          serviceLocator(),
                        ),
                      ),
                      BlocProvider<JoinTripCarPoolCubit>(
                        create: (context) => JoinTripCarPoolCubit(
                            joinTripCarpoolUsecase: serviceLocator()),
                      ),
                      BlocProvider<AdvertisementCubit>(
                        create: (context) =>
                            serviceLocator<AdvertisementCubit>(),
                      ),
                    ],
                    child: const TripJoinView(
                      initialIndex: 2,
                    ),
                  ),
                ),
              ),

              GoRoute(
                path: Paths.TRIP_JOIN_REQUEST_NOTIFICATIONS,
                name: Routes.TRIP_JOIN_REQUEST_NOTIFICATIONS,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      RequestTripJoinNotificationView(
                          payload: state.extra! as Map<String, dynamic>));
                },
              ),
              GoRoute(
                path: Paths.TRIP_JOIN_REQUEST_HISTORY_Pick_Me,
                name: Routes.TRIP_JOIN_REQUEST_HISTORY_Pick_Me,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    BlocProvider<GetRequestsPickMeCubit>(
                      create: (context) => GetRequestsPickMeCubit(
                          getRequestsPickMeUseCase: serviceLocator()),
                      child: GetRequestsPickMeView(
                        pickMeRequests: state.extra as List<PickMeRequest>,
                      ),
                    )),
              ),
              GoRoute(
                path: Paths.TRIP_JOIN_REQUEST_HISTORY,
                name: Routes.TRIP_JOIN_REQUEST_HISTORY,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      MultiBlocProvider(
                        providers: [
                          BlocProvider<GetRequestCubit>(
                            create: (context) => GetRequestCubit(
                                getRequestUsecase: serviceLocator()),
                          ),
                          BlocProvider<GetRequestsPickMeCubit>(
                            create: (context) => GetRequestsPickMeCubit(
                                getRequestsPickMeUseCase: serviceLocator()),
                          ),
                        ],
                        child: TripJoinRequestHistoryView(
                            extra: state.extra! as Map<String, dynamic>),
                      ));
                },
              ),
              GoRoute(
                path: Paths.CAR_POOL,
                name: Routes.CAR_POOL,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      MultiBlocProvider(providers: [
                        BlocProvider<GetAllTripsCubit>(
                          create: (context) =>
                              GetAllTripsCubit(apiConsumer: serviceLocator()),
                        ),
                        BlocProvider<GetCurrencyCubit>(
                          create: (context) => GetCurrencyCubit(
                            serviceLocator(),
                          ),
                        ),
                        BlocProvider<JoinTripCarPoolCubit>(
                          create: (context) => JoinTripCarPoolCubit(
                              joinTripCarpoolUsecase: serviceLocator()),
                        ),
                      ], child: const CarPoolView()));
                },
              ),
              GoRoute(
                path: Paths.ADD_NEW_ROUTE,
                name: Routes.ADD_NEW_ROUTE,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      MultiBlocProvider(providers: [
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
                          create: (context) =>
                              GetAllTripsCubit(apiConsumer: serviceLocator()),
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
                          create: (context) =>
                              GetAllTripsCubit(apiConsumer: serviceLocator()),
                        ),
                        BlocProvider<GetCurrencyCubit>(
                          create: (context) => GetCurrencyCubit(
                            serviceLocator(),
                          ),
                        ),
                        BlocProvider<MapBoxCubit>(
                          create: (context) => MapBoxCubit(),
                        ),
                        BlocProvider<HereLocationCubit>(
                          create: (context) => HereLocationCubit(),
                        ),
                        BlocProvider<GetLatAndLongCubit>(
                          create: (context) => GetLatAndLongCubit(
                              getLatLongFromAddressRemoteDataSource:
                                  serviceLocator()),
                        ),
                        BlocProvider<DestGetLatAndLongCubit>(
                          create: (context) => DestGetLatAndLongCubit(
                              getLatLongFromAddressRemoteDataSource:
                                  serviceLocator()),
                        ),
                      ], child: const AddNewRouteView()));
                },
              ),
              GoRoute(
                path: Paths.welcomeRideRegister,
                name: Routes.welcomeRideRegister,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  serviceLocator<RideRegisterCubit>(),
                            ),
                          ],
                          child: WelcomeRideRegister(
                            isShipping: state.extra as bool,
                          )));
                },
              ),
              GoRoute(
                path: Paths.UploadRiderImages,
                name: Routes.UploadRiderImages,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<RideRegisterCubit>(),
                        child: UploadRiderImages(
                          params: state.extra as UploadRiderImagesParams?,
                        ),
                      ));
                },
              ),
              GoRoute(
                path: Paths.personalInformationScreen,
                name: Routes.personalInformationScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      BlocProvider(
                          create: (context) =>
                              serviceLocator<RideRegisterCubit>(),
                          child: PersonalInformationScreen(
                            params: state.extra as RideFeatureRegisterParams,
                          )));
                },
              ),
              GoRoute(
                path: Paths.driversLicenseScreen,
                name: Routes.driversLicenseScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                      context,
                      state,
                      MultiBlocProvider(
                          providers: [
                            BlocProvider<DestGetLatAndLongCubit>(
                              create: (context) => DestGetLatAndLongCubit(
                                  getLatLongFromAddressRemoteDataSource:
                                      serviceLocator()),
                            ),
                          ],
                          child: DriversLicenseScreen(
                            params: state.extra as UploadRiderImagesParams,
                          )));
                },
              ),
              GoRoute(
                path: Paths.drugAnalysisScreen,
                name: Routes.drugAnalysisScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                      context, state, const DragAnalyticsScreen());
                },
              ),
              GoRoute(
                path: Paths.criminalRecordScreen,
                name: Routes.criminalRecordScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                      context, state, const CriminalRecordScreen());
                },
              ),
              GoRoute(
                path: Paths.technicalExaminationScreen,
                name: Routes.technicalExaminationScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    const TechnicalExaminationScreen(),
                  );
                },
              ),
              GoRoute(
                path: Paths.personalDocumentsScreen,
                name: Routes.personalDocumentsScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                        providers: [
                          BlocProvider<DestGetLatAndLongCubit>(
                            create: (context) => DestGetLatAndLongCubit(
                                getLatLongFromAddressRemoteDataSource:
                                    serviceLocator()),
                          ),
                        ],
                        child: PersonalDocumentsScreen(
                            params: state.extra as UploadRiderImagesParams)),
                  );
                },
              ),
              GoRoute(
                path: Paths.vehicleInformationScreen,
                name: Routes.vehicleInformationScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                        providers: [
                          BlocProvider<DestGetLatAndLongCubit>(
                            create: (context) => DestGetLatAndLongCubit(
                                getLatLongFromAddressRemoteDataSource:
                                    serviceLocator()),
                          ),
                        ],
                        child: VehicleInformationScreen(
                            params: state.extra as UploadRiderImagesParams)),
                  );
                },
              ),
              GoRoute(
                path: Paths.moreInfoScreen,
                name: Routes.moreInfoScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const MoreInfoScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.truckWelcomeRideRegister,
                name: Routes.truckWelcomeRideRegister,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const TruckWelcomeRideRegister()),
                  );
                },
              ),

              GoRoute(
                path: Paths.truckPersonalInformationScreen,
                name: Routes.truckPersonalInformationScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const TruckPersonalInformationScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.truckDriversLicenseScreen,
                name: Routes.truckDriversLicenseScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const TruckDriversLicenseScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.truckPersonalDocumentsScreen,
                name: Routes.truckPersonalDocumentsScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const TruckPersonalDocumentsScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.truckVehicleInformationScreen,
                name: Routes.truckVehicleInformationScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const TruckVehicleInformationScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.truckMoreInfoScreen,
                name: Routes.truckMoreInfoScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const TruckMoreInfoScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.completeRegisterScreen,
                name: Routes.completeRegisterScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                        providers: [
                          BlocProvider<DestGetLatAndLongCubit>(
                            create: (context) => DestGetLatAndLongCubit(
                                getLatLongFromAddressRemoteDataSource:
                                    serviceLocator()),
                          ),
                        ],
                        child: CompleteRegisterScreen(
                          params: state.extra as UploadRiderImagesParams,
                        )),
                  );
                },
              ),
              GoRoute(
                path: Paths.createLoadingTripScreen,
                name: Routes.createLoadingTripScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const CreateLoadingTripScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.CURRENTRIDEHOME,
                name: Routes.CURRENTRIDEHOME,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      ),
                    ],
                    child: const CurrentRideScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.RideREGUESTHOME,
                name: Routes.RideRequestHOME,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      ),
                    ],
                    child: const RideRequestScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.RideStatusScreen,
                name: Routes.RideStatusScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      ),
                    ],
                    child: const RideStatusScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.ratingClientScreen,
                name: Routes.ratingClientScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      ),
                    ],
                    child: RatingClientScreen(),
                  ),
                ),
              ),

              GoRoute(
                path: Paths.connectionCallScreen,
                name: Routes.connectionCallScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      ),
                    ],
                    child: const ConnectionCallScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.safetyRideScreen,
                name: Routes.safetyRideScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      ),
                    ],
                    child: const SafetyRideScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.rideFindingScreen,
                name: Routes.rideFindingScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => serviceLocator<RideCubit>(),
                      ),
                    ],
                    child: const RideFindingScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.rideModeScreen,
                name: Routes.rideModeScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  RideModeScreen(params: state.extra as RideModeParams),
                ),
              ),
              GoRoute(
                path: Paths.rideDashboardDetailsScreen,
                name: Routes.rideDashboardDetailsScreen,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              serviceLocator<DashboardsCubit>(),
                        ),
                      ],
                      child: RideDashboardDetailsScreen(
                          tripEntity: state.extra as TripEntity),
                    )),
              ),
              GoRoute(
                path: Paths.routeDetailsScreen,
                name: Routes.routeDetailsScreen,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    BlocProvider(
                      create: (context) => serviceLocator<CaptainShareCubit>(),
                      child: RouteDetailsScreen(
                          tripEntity: state.extra as MyBookingEntity),
                    )),
              ),

              GoRoute(
                path: Paths.rideLoadingRequestScreen,
                name: Routes.rideLoadingRequestScreen,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    BlocProvider(
                      create: (context) => serviceLocator<ClientTripsCubit>()
                        ..loadInitialClientPendingTrips(),
                      child: PendingRideOfferScreen(
                        type: state.extra as String,
                      ),
                    )),
              ),
              GoRoute(
                path: Paths.rideOffer,
                name: Routes.rideOffer,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    BlocProvider(
                      create: (context) => serviceLocator<ClientTripsCubit>(),
                      child: MainTabsRideOffer(
                        type: state.extra as String,
                      ),
                    )),
              ),
              GoRoute(
                path: Paths.supportRideScreen,
                name: Routes.supportRideScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                      create: (context) => serviceLocator<DashboardsCubit>(),
                      child: SupportRideScreen(
                        params: state.extra as SupportRideParams,
                      )),
                ),
              ),
              GoRoute(
                path: Paths.supportClientDetailsScreen,
                name: Routes.supportClientDetailsScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  SupportClientDetailsScreen(),
                ),
              ),
              GoRoute(
                path: Paths.emergencyContactsScreen,
                name: Routes.emergencyContactsScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const EmergencyContactsScreen(),
                ),
              ),
              GoRoute(
                path: Paths.rideArrivedScreen,
                name: Routes.rideArrivedScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const RideArrivedScreen(),
                ),
              ),
              GoRoute(
                path: Paths.ratingDriverScreen,
                name: Routes.ratingDriverScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  RatingDriverScreen(),
                ),
              ),
              GoRoute(
                path: Paths.completeRideScreen,
                name: Routes.completeRideScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  const CompleteRideScreen(),
                ),
              ),
              GoRoute(
                path: Paths.newTripJoinScreen,
                name: Routes.newTripJoinScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const NewTripJoinScreen()),
                  );
                },
              ),
              // GoRoute(
              //     path: Paths.newTripJoinScreen,
              //     name: Routes.newTripJoinScreen,
              //    pageBuilder: (context, state) {
              //       return MultiBlocProvider(providers: [
              //         BlocProvider<DestGetLatAndLongCubit>(
              //           create: (context) => DestGetLatAndLongCubit(
              //               getLatLongFromAddressRemoteDataSource:
              //               serviceLocator()),
              //         ),
              //       ], child: const NewTripJoinScreen()),);
              //     },),
              GoRoute(
                path: Paths.captainShareScreen,
                name: Routes.captainShareScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                        providers: [
                          BlocProvider<DestGetLatAndLongCubit>(
                            create: (context) => DestGetLatAndLongCubit(
                                getLatLongFromAddressRemoteDataSource:
                                    serviceLocator()),
                          ),
                        ],
                        child: const TripJoinView(
                          initialIndex: 0,
                        )),
                  );
                },
              ),
              GoRoute(
                path: Paths.captainShareInfoScreen,
                name: Routes.captainShareInfoScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const CaptainShareInfoScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.tripJoinInfoScreen,
                name: Routes.tripJoinInfoScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const TripJoinInfoScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.pickMeInfoScreen,
                name: Routes.pickMeInfoScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ], child: const PickMeInfoScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.newRouteScreen,
                name: Routes.newRouteScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                      BlocProvider(
                        create: (context) =>
                            serviceLocator<CaptainShareCubit>(),
                      ),
                    ], child: const NewRouteScreen()),
                  );
                },
              ),
              GoRoute(
                path: Paths.runningAndPastTripsScreen,
                name: Routes.runningAndPastTripsScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              serviceLocator<CaptainShareDashboardCubit>()
                                ..loadInitData(context),
                        ),
                      ],
                      child: const RunningAndPastTripsScreen(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: Paths.captainRideDetails,
                name: Routes.captainRideDetails,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<DestGetLatAndLongCubit>(
                          create: (context) => DestGetLatAndLongCubit(
                              getLatLongFromAddressRemoteDataSource:
                                  serviceLocator()),
                        ),
                      ],
                      child: const CaptainRideDetails(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: Paths.newRideModeScreen,
                name: Routes.newRideModeScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<DestGetLatAndLongCubit>(
                          create: (context) => DestGetLatAndLongCubit(
                              getLatLongFromAddressRemoteDataSource:
                                  serviceLocator()),
                        ),
                      ],
                      child: const NewRideModeScreen(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: Paths.useSoundScreen,
                name: Routes.UseSoundScreen,
                pageBuilder: (context, state) {
                  return customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<DestGetLatAndLongCubit>(
                          create: (context) => DestGetLatAndLongCubit(
                              getLatLongFromAddressRemoteDataSource:
                                  serviceLocator()),
                        ),
                      ],
                      child: const UseSoundScreen(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: Paths.addStoryScreen,
                name: Routes.AddStoryScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<DestGetLatAndLongCubit>(
                        create: (context) => DestGetLatAndLongCubit(
                            getLatLongFromAddressRemoteDataSource:
                                serviceLocator()),
                      ),
                    ],
                    child: const AddStoryScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: Paths.allDriverRatingScreen,
                name: Routes.allDriverRatingScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                      create: (context) => serviceLocator<ClientTripsCubit>()
                        ..getDriverAllRating(params: state.extra as String),
                      child: AllDriverRatingScreen()),
                ),
              ),
              GoRoute(
                path: Paths.allClientRatingScreen,
                name: Routes.allClientRatingScreen,
                pageBuilder: (context, state) => customTransition(
                  context,
                  state,
                  BlocProvider(
                      create: (context) => serviceLocator<ClientTripsCubit>()
                        ..getClientAllRating(params: state.extra as String),
                      child: AllClientRatingScreen()),
                ),
              ),
              GoRoute(
                path: Paths.loadingDashboardDetailsScreen,
                name: Routes.loadingDashboardDetailsScreen,
                pageBuilder: (context, state) => customTransition(
                    context,
                    state,
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              serviceLocator<DashboardsCubit>(),
                        ),
                      ],
                      child: LoadingDashboardDetailsScreen(
                          tripEntity: state.extra as GetLoadingHistoryEntity),
                    )),
              ),
              GoRoute(
                path: Paths.CHANCE,
                name: Routes.CHANCE,
                pageBuilder: (context, state) =>
                    customTransition(context, state, ChanceMainView()),
              ),
              GoRoute(
                path: Paths.availableAuctionScreen,
                name: Routes.availableAuctionScreen,
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) =>
                        serviceLocator<AuctionCubit>()..fetchAuctionBanner(),
                        // serviceLocator<AuctionCubit>()..getAvailableNonSocketAuction(),
                    child: AuctionScreen(),
                  );
                },
              ),
              GoRoute(
                path: Paths.createAuctionScreen,
                name: Routes.createAuctionScreen,
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) =>
                        serviceLocator<AuctionCubit>(),
                    child: CreateAuctionScreen(),
                  );
                },
              ),
              GoRoute(
                path: Paths.myAuctionScreen,
                name: Routes.myAuctionScreen,
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) =>
                        serviceLocator<AuctionCubit>()..getMyAuction(),
                    child: MyAuctionScreen(),
                  );
                },
              ),
            ],
          ),

          // GoRoute(
          //   path: Routes.splash,
          //   name: Routes.splash,
          //   pageBuilder: (context, state) => customTransition(
          //     context,
          //     state,
          //     const SplashScreen(),
          //   ),
          //
          // ),
        ]);
  }
}

CustomTransitionPage customTransition(
        BuildContext context, state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
