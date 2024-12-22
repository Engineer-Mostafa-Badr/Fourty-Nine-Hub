import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/get_ad_details_usecase.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/main_category_use_case.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_ads_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/get_meals_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_Id_usecase.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_details_azkar_use_case.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/get_emergency_requests_use_case.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_user_media_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/add_reel_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/add_reel_reply_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/create_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/create_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/reels_with_same_audia_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/share_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/star_feature/domain/use_case/fetch_all_star_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';

import '../../../../../features/account_taps/my_adds/domain/usecases/edit_my_ads_use_case.dart';
import '../../../../../features/account_taps/my_adds/domain/usecases/get_all_counts_ads_usecase.dart';
import '../../../../../features/account_taps/my_adds/domain/usecases/get_all_counts_usecase.dart';
import '../../../../../features/account_taps/my_adds/domain/usecases/update_my_ads_usecase.dart';
import '../../../../../features/ads_feature/create_company_ad/data/models/fetch_post_company_advertise_params.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_main_category.dart';

class EndPoints {
  //logout
  static const logout = '/auth/logout';

  static const pageSize = 10;
  static const developmentWebSocketBaseUrl = 'https://49dev.com';
  static const developmentBaseUrl = 'https://49dev.com/api/v1';
  static const productionBaseUrl = 'https://49dev.com/api/v1';
  static const storageBaseUrl = 'https://49-space.fra1.digitaloceanspaces.com/';
  static const login = '/auth/login';
  static const getProfile = '/users/profile';
  static const register = '/auth/register';
  static const verifyOTP = '/auth/verify/email';
  static const getWelcomeGift = '/auth/welcome-gift';
  static const socialLogin = '/auth/social/login';
  static const resendOTP = '/auth/resend-reset-code';
  static const refreshToken = '/auth/refresh/token';

  static String friendsList(TwitterFeedParams params) =>
      '/friends/allFriends?search=${params.search}&page=${params.page}&limit=${params.limit}';

  static String searchUsers(TwitterFeedParams params) =>
      '/search/users/${params.search}?page=${params.page}&limit=${params.limit}&subCategory=${Constants.facebookSubCategory}';

  static String friendRequestsList(TwitterFeedParams params) =>
      '/friends/FriendRequests?search=${params.search}&page=${params.page}&limit=${params.limit}';

  static String blockedUsersList(TwitterFeedParams params) =>
      '/users/blocked?search=${params.search}&page=${params.page}&limit=${params.limit}';

  static String followersList(TwitterFeedParams params) =>
      '/follow/followers?search=${params.search}&page=${params.page}&limit=${params.limit}';

  static const getParentMainCategories = '/category/parent';
  static const getMainCategories = '/category/parent/get-all-main';
  static String favouriteCategories = '/favorite-category';

  static String getBannerByID({required String id}) => '/categories/main/$id';
  static const getMainCategoriesWithoutSubcategories = '/categories/main';
  static const getWalletHome = '/main-wallet/user-wallets-amount';
  static const getCurrency = '/main-wallet/app-currency';
  static const anyCashBack = '/cashback/any';
  static String loggedUserId = UserCubit.to.state.data?.id ?? '';
  static String getMainCategoryDetails(String id) =>
      '/categories/main/$id${loggedUserId.isNotEmpty ? '?userId=$loggedUserId' : ''}';
  static const getCurrencyCarPool = '/main-wallet/app-currency';

  static String addMainCategoryToFavorite(String id) =>
      '/favorite-category/$id';

  static String deleteMainCategoryFromFavorite(String id) =>
      '/favorite-category/$id';

  static String toggleSubCategoryToFavorites(String id) =>
      '/favorite-sub-category/$id';

  static const getGift = '/subscriber/competitions';
  static const getBalance = '/main-wallet/user-balance';

  static String getHistoryBalance() {
    return '/user-transactions/balance';
  }

  static String getHistoryWallet() {
    return '/user-transactions/mainWallet';
  }

  static String geMainCategoryWallet(MainCategoryParams params) {
    return '/categories/main/for-subscriptions?page=1&limit=60';
  }

  static String geSubCategoryWallet(String id) {
    return '/categories/subcategories/$id';
  }

  static String deleteSubscription(String id) {
    return '/subscription/cancel-subscription/$id';
  }

  static String addSubscription() {
    return '/subscription/subscribe';
  }

  static String deleteCompanyAd(String id) {
    return '/advertisementCompany/$id';
  }

  static const payCompanyAd = '/advertisementCompany/payment';

  static String getPostsCompanyAd(FetchPostCompanyAdvertiseParams params) {
    return '/advertisementCompany/my-advertisement?page=${params.paginationParams.page}&filter=${params.filter}&limit=${params.paginationParams.limit}&subCategory=66adecd7aa2ff24015872e9f';
  }

  static String postCompanyAd() {
    return '/advertisementCompany?subCategory=66adecd7aa2ff24015872e9f';
  }

  // Custom Page
  static const socialPage = '/navigators/socialPage';
  static const subTab = '/navigators/subTap';
  static const navigateBar = '/navigators/navigatorsBar';
  static const favouriteCat = '/navigators/navigateCategories';
  static const activate = '/navigators/customPage';

  // Star
  static String allStar(StarPaginationParams params) =>
      '/talent/?page=${params.page}&limit=${params.limit}';
  static String winnerStar(StarPaginationParams params) =>
      '/subscriber/winners?page=${params.page}&limit=${params.limit}';
  static const myStar = '/talent/my-talent';
  static const uploadStar = '/talent/upload';
  static String deleteMyStar({required String id}) => '/talent/$id';

  //My Ads
  static const myAdsAuction = '/ads/allMyAds/auction';
  static const myAdsInstallment = '/ads/allMyAds/installment';
  static const myAdsOther = '/ads/allMyAds/other';
  static const myAdsTripJoin =
      '/ride/come-with-you/my?subCategory=62ea00e269ea29c91dfc390c';
  static const clickGlobal = '/global/click';

  static String deleteMyTripJoin({required String id}) =>
      '/ride/come-with-you/Delete/$id';

  static String getMyAdsWithId({required String id}) => '/ads/getAd/$id';

  static String deleteMyInstallment({required String id}) =>
      '/ads/deleteAd/$id';

  static String getAllCount(Params params) =>
      '/ride/come-with-you/callAndChat/${params.id}?status=${params.status}';

  static String getAllAdsCount(CountAdsParams params) =>
      '/ads/users-ads-field/${params.id}?field=${params.status}';

  static String updateMyAds(UpdateMyAdsParams params) =>
      '/ads/update-ads/${params.id}';

  static String editMyAds(EditParams params) => '/ads/update-ads/${params.id}';

  static String search(SearchParams params) =>
      '/searchApp?page=${params.params.page}&limit=${params.params.limit}}';

  static const getWallet = '/main-wallet/user-wallet';
  static const transferMoney = '/main-wallet/send-money';
  static const sendPoints = '/stream/fan/send-points';
  static sendLiveGift(String id) => '/stream/fan/send-gift/$id';
  static const fetchUsers = '/users/all-usernames';
  static const getPrice = '/advertisementCompany/price';
  static const getSubscription = '/subscription';
  static const transferFiveBalance = '/main-wallet/transfer-five-years';
  static const transferTenBalance = '/main-wallet/transfer-ten-years';
  static const requestWithdrawBalance =
      '/main-wallet/request-withdrawal-balance';
  static const checkRequestWithdrawBalance =
      '/main-wallet/check-request-withdrawal';

  static const getWheel = '/wheels/random';
  static const spinWheel = '/wheels/spin/';
  static const wheelWallet = '/wheel/wallets/my/wallet';
  static const sendForgetPasswordOTP = '/auth/forgot-password';
  static const verifyForgetPasswordOTP = '/auth/verify/otp';
  static const createNewForgetPassword = '/auth/reset-password';
  static const notifications = '/notifications';
  static const unreadNotificationsCount = '/notifications/unread/count';
  static const privacy = '/users/privacy';
  static const deleteAccount = '/users/settings/delete-account';
  static const disableAccount = '/users/settings/disable-account';
  static const enableAccount = '/users/settings/enable-account';
  static const shareApp = '/users/referral';

  // Quran
  static String quranSurah(QuranParams params) =>
      '/quran/surahs?page=${params.page}&limit=${params.limit}';
  static String quran(int id) => '/quran/surah/$id';
  static String azkar(AzkarParams params) =>
      '/azkar/categories?page=${params.page}&limit=${params.limit}';
  static String azkarDetails(AzkarDetailsParams params) =>
      '/azkar/azkar-in-category?page=${params.page}&limit=${params.limit}';

  static String notificationsSeen(String id) => '/notifications/$id';

  static String deleteNotification(String id) => '/notifications/$id';
  static const deleteAllNotification = '/notifications/all';

  // static const report = '/report?subCategory=66a3583454e6e337915514db';
  static String report({required String subCategoryId}) =>
      '/report?subCategory=$subCategoryId';
  static String documentRequest =
      '/twitter/document-request?subCategory=${Constants.documentSubCategory}';

  // ride
  static String bannerDataRider = "$developmentBaseUrl/ride/get-thumbnail-ride";
  static String specialRegister =
      "$developmentBaseUrl/ride/riders/special/register";
  static String riderRegister = "$developmentBaseUrl/ride/riders/register";
  static String expectedPrice = "$developmentBaseUrl/ride/trips/expected/price";
  static String acceptOfferRide =
      "$developmentBaseUrl/ride/offers/accept/offer";
  static String declineOfferRide =
      "$developmentBaseUrl/ride/offers/decline/offer";
  static String expiredTripRider =
      "$developmentBaseUrl/ride/trips/user?limit=10&page=1&subCategory=667382a7f87288ce577e723b";
  static String pictureOptional =
      "$developmentBaseUrl/ride/info/picture-optional";
  static String newTripRide = "$developmentBaseUrl/ride/trips/newTrip";

  //Rider no Socket
  static String createTripNoSocket = "$developmentBaseUrl/ride/trip";
  static String createPremiumTripNoSocket =
      "$developmentBaseUrl/ride/trip/premium";
  static String createOfferNoSocket =
      "$developmentBaseUrl/ride/trip/createOffer";
  static String offerAcceptNoSocket =
      "$developmentBaseUrl/ride/trip/offer/accept";
  static String offerRejectNoSocket =
      "$developmentBaseUrl/ride/trip/offer/reject";
  static String getAllTripNoSocket = "$developmentBaseUrl/ride/trip/all";
  static String getTripOffersNoSocket = "$developmentBaseUrl/ride/trip/offers";
  static String getUserLoginTripNoSocket =
      "$developmentBaseUrl/ride/trip/user/trip";
  static String deleteTripNoSocket = "$developmentBaseUrl/ride/trip";

  static String recordVoiceRide = "$developmentBaseUrl/ride/trips/record-voice";

  //shipping
  static String bannerData = "$developmentBaseUrl/loading/driver/subcategory";
  static const drivingLicenseS3 = '/ride/info/driving-license';
  static const carImageS3 = '/ride/info/car-images';
  static const carLicenseS3 = '/ride/info/car-license';
  static const idLicenseS3 = '/ride/info/id';
  static const mainWallet = '$developmentBaseUrl/main-wallet';
  static const infoDocuments =
      '$developmentBaseUrl/loading/driver/info/documents';
  static const infoId = '$developmentBaseUrl/ride/info/id';
  static const drivingLicense = '$developmentBaseUrl/ride/info/driving-license';
  static const carLicense = '$developmentBaseUrl/ride/info/car-license';
  static const successUpload = '$developmentBaseUrl/ride/info/success-upload';
  static const successDocuments = '$developmentBaseUrl/ride/info/documents';
  static const successCarImages =
      '$developmentBaseUrl/ride/info/success-car-images';

  // health
  static String getCities({required String governorateId}) =>
      '/health/cities/$governorateId';
  static const getGovernorates = '/health/governorate';
  static const createDoctor = '/health/doctor';
  static String doctorSearch =
      '/health/doctor-search${loggedUserId.isNotEmpty ? "?userId=$loggedUserId" : ""}';
  static const bookEmergency = '/health/book-emergency';
  static cancelAppointment(String id) => '/health/book-appointment-cancel/$id';
  static doctorCancelAppointment(String id) => '/health/book-appointment-doctor-cancel/$id';
  static emergencyRequests(GetEmergencyRequestsParams params) => '/health/show-emergency?limit=${params.limit}&page=${params.page}&subCategory=${params.subCategoryId}';
  static allAppointments(PaginationParams params) => '/health/doctor/all-doctor-requests?limit=${params.limit}&page=${params.page}';

  static String bookRegularAppointment(String appointmentId) =>
      '/health/book-appointment/$appointmentId';

  static String toggleFavoriteSubcategory(String subCategoryId) =>
      '/favorite-sub-category/$subCategoryId';

  static String bookPremiumAppointment(String appointmentId) =>
      '/health/book-appointment-premium/$appointmentId';

  static String getDoctorReviewsForUsers(String doctorId) =>
      '/health/doctor/rate/$doctorId';
  static const String getDoctorReviews = '/health/doctor/rate';
  static String getDoctorDetailsId(GetDoctorDetailsIdParams params) =>
      '/health/doctor-details/${params.doctorId}${loggedUserId.isNotEmpty ? "?userId=$loggedUserId" : ""}';

  static String getDoctorDetails(String doctorId) =>
      '/health/doctor/$doctorId?subCategory=62c8bae08e28a58a3edf5867';

  static String toggleFavoriteCategory(String subCategoryId) =>
      '/favorite-category/$subCategoryId';
  static getHealthSubcategories(String userId) =>
      '/health/subCategories-health-with-ads${userId.isNotEmpty ? "?userId=$userId" : ""}';
  static getMedicalServices(String userId) =>
      '/health/subCategories-medicalServices-with-ads${userId.isNotEmpty ? "?userId=$userId" : ""}';
  static const getFavoriteCategory = '/favorite-category';
  static const getDoctorInfo = '/health/dashboard/doctor-infos';
  static String getUpcomingUserAppointments(String userId) =>
      '/health/book-appointment${userId.isNotEmpty ? "?userId=$userId" : ""}';
  static const String getHealthRequestsHistory =
      '/health/history-patient-booking';
  static const remainingDaysOfDoctorPracticing =
      '/health/dashboard/remaining-days-of-doctor-id';
  static const remainingDaysOfDoctorID =
      '/health/dashboard/remaining-days-of-doctor-practicing-id';
  static const remainingDaysOfDoctorSubscription =
      '/health/dashboard/remaining-days-of-doctor-subscription';
  static const String getPaymentProvider = '/payment-provider/active';

  // static const String getPaymentProvider = '/dashboard/payment-provider';
  static const String getPaymob = '/paymob/paynow';
  static const String postInstaPay = '/manual-payment/create';
  static const String saveCardToken = '/fawry/tokenize-card';
  static const String payWithCardToken = '/fawry/pay-with-card-token';
  static const favouriteCategoriesList = '/favorite-category';
  static const String getSavedCards = '/payment/cards';
  static const String makeMultiPayment = '/fawry/multi-charge';
  static const String deleteSavedCard = '/payment/cards';
  static const String chargeWithCard = '/fawry/charge-with-card';
  static const getDoctorAppointmentsByDay = '/health/doctor/booking-day';
  static const getDoctorUnhandledAppointments = '/health/book-requests';
  static const isDoctor = '/health/check-doctor-or-not';
  static const getDoctorTotalEarnedMoney =
      '/health/dashboard/total-earned-money';

  //  Payment Cache Out
  static const instaPay = '/payment-profile';
  static const requestYellowCard = '/payout/yellow-card';
  static const banks = '/banks';
  static const requestWithdrawalMainWallet =
      '/main-wallet/request-withdrawal-mainWallet';
  static const checkWalletEnough = '/main-wallet/check-wallet-enough';
  static const payout = '/payout/request';
  static const requestInstapay = '/payout/request-instapay';
  static const yellowCardPrice = '/payout/yellow-card/price';
  static const payoutMethod = '/payout/methods';
  static String doctorAcceptAppointment(String appointmentId) =>
      '/health/book-appointment/approve/$appointmentId';

  static String doctorRejectAppointment(String appointmentId) =>
      '/health/book-appointment/reject/$appointmentId';
  static const getAllDoctorReservations =
      '/health/dashboard/number-of-reservations';

  static const isDoctorApproval = '/health/check-doctor-approval';
  static const getDoctorProfile = '/health/doctor-profile';
  static const getDoctorWorkDays = '/health/doctor-work-days';
  static const updateDoctorProfilePhoto = '/health/doctor/picture';
  static const updateDoctorTimeTable = '/health/doctor/add-appointments';
  static const updateDoctorPractcing =
      '/health/doctor-upload-license-practicing';
  static const updateDoctorID = '/health/doctor-upload-license-id';

  static String deleteDoctor(String doctorId) => '/health/doctor/$doctorId';

  // ride
  //shipping
  static String registerDriver = "$developmentBaseUrl/loading/driver/register";
  static String favoriteSubCategory =
      "$developmentBaseUrl/favorite-sub-category";
  static String createLoadingTrip =
      "$developmentBaseUrl/loading/trip/createLoadingTrip";

  // static const idLicenseS3 = '/ride/info/id';
  static const getAllTripBySubCategory =
      '$developmentBaseUrl/loading/trip/driver/subcategory';
  static const carPlate = '/loading/driver/info/car-plate';
  static getRestaurantOrders(PaginationParams params) =>
      '/food/get-restaurant-orders?page=${params.page}&limit=${params.limit}';
  static const makeRatingDriver = '/loading/rating-driver/makeRating';
  static const getDriverData = '$developmentBaseUrl/loading/driver/info';
  static const updateDriver = '$developmentBaseUrl/loading/driver';
  static const completeTrip = '$developmentBaseUrl/loading/trip/complete';
  static const deleteDriver = '$developmentBaseUrl/loading/driver/deleteDriver';
  static const driverStatistics =
      '$developmentBaseUrl/loading/driver/driverStatistics';

  //trip
  static const sendOffer = '$developmentBaseUrl/loading/trip/sendOffer';
  static const reportUrl = '$developmentBaseUrl/report';
  static const getRestaurantInfo = '/restaurants/info-restaurant';
  static const getRestaurantStatistics = '/restaurants/statistics';
  static deleteRestaurant(String id) => '/restaurants/delete-restaurant/$id';
  static const updateRestaurant = '/restaurants/update-restaurant-info';
  static const favoriteCategory = '$developmentBaseUrl/favorite-category';
  static const reasons = '$developmentBaseUrl/cancellation/reasons';
  static const sendOfferPremium =
      '$developmentBaseUrl/loading/trip/sendOffer-premium';
//
  // static const acceptLoadingTripOffer =
  //     '$developmentBaseUrl/loading/trip/acceptLoadingTripOffer';
  static const mediasignedUrl =
      '$developmentBaseUrl/dashboard/media/signed-url';
  static const mediaconfirm = '$developmentBaseUrl/dashboard/media/confirm';
  static const click = '$developmentBaseUrl/global/click';
  static const allUserTrips = '$developmentBaseUrl/loading/trip/allUserTrips';
  static const cancelOffer = '$developmentBaseUrl/loading/trip/cancelOffer';
  static const acceptLoadingTripOffer =
      '$developmentBaseUrl/loading/trip/acceptOffer';
  static const deleteLoadingTrip =
      '$developmentBaseUrl/loading/trip/deleteLoadingTrip';
  static const loadingTripRequests =
      '$developmentBaseUrl/loading/trip/loadingTripRequests';

  // reels
  static const getExploreReels = '/reels/explore';
  static const fetchReelsForFollowers =
      '/reels/followers?subCategory=66684135dbb427ee42aa0141';
  static saveReel(String id) => '/reels/saved/$id';
  static shareReel(String id) => '/reels/share/$id';
  static likeReel(String id) => '/reels/likes/$id';
  static getComments(String id) => '/reels/comments/$id';
  static getReelsWithSameAudio(ReelsWithSameAudioParams params) =>
      '/reels/audio/${params.audioId}';
  static toggleCommentLike(String id) => '/reels/comments/like/$id';
  static makeViews(String id) => '/stories/view/$id';
  static getGifts(PaginationParams params) =>
      '/dashboard-gifts?limit=${params.limit}&page=${params.page}';
  static getTinderUserProfile(String params) =>
      '/tinder/get-profile/$params?subCategory=66b2683f3a360fbdbf110767';
  static const getUsers = '/tinder/';
  static const fetchSubCategoryData = '/tinder/subCategories';
  static const fetchFavourites = '/favorite-sub-category';
  static const fetchFavouritesCategory = '/favorite-category';
  static deleteStory(String id) => '/stories/$id';
  static addFavouriteCategories(String id) => '/favorite-sub-category/$id';
  static fetchLastSeen(String id) => '/users/last-seen/$id';
  static const sendGift =
      '/tinder/sendGifts?subCategory=6718f27eacb309f8b1f94d0c';
  static const fetchGifts = '/dashboard-gifts?limit=10';
  static const tinderUploadPicture =
      '/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
  static const createStory = '/stories/text';
  static getStoryViewers(String id) => '/Stories/view/$id';
  static getMutedStories(PaginationParams params) =>
      '/stories/mutedStories?limit=${params.limit}&page=${params.page}';
  static fetchStories(PaginationParams params) =>
      '/stories/explore?limit=${params.limit}&page=${params.page}';
  static const muteUserStories = '/stories/muteUserStory';
  static const updatePrivacy = '/stories/privacy';
  static const getFollowers =
      '/follow/followers?subCategory=62ef7cf658c90d4a7ed48120';
  static addReelComment(AddReelCommentParams params) =>
      '/reels/comments/${params.reelId}';
  static addReelReply(AddReelReplyParams params) =>
      '/reels/comments/${params.reelId}';

  // ride request
  // static const expectedPrice = '/ride/trips/expected/price';
  static const carTypes = '/cars';

  static String subCategories({required String mainCategoryId}) {
    return '/categories/subcategories/$mainCategoryId';
  }

  static String mainSubCategories({required GetSubCategoriesParams params}) {
    return '/categories/subcategories/${params.mainCategoryId}?userId=${params.userId}';
  }

  static const riderInfoRegister = '/ride/riders/register';
  static const sendComeWithYou = '/ride/come-with-you';
  static const sendPickMe = '/ride/pick-me';

  static String acceptPickMeRequest(String id) {
    return '/ride/pick-me/$id/accept';
  }

  static String rejectPickMeRequest(String id) {
    return '/ride/pick-me/$id/reject';
  }

  static String acceptComeWithYouRequest(String id) {
    return '/ride/come-with-you/$id/accept';
  }

  static String rejectComeWithYouRequest(String id) {
    return '/ride/come-with-you/$id/reject';
  }

  static const sendRideRequest = '/ride/trips/new';
  static const checkDriverType = '/ride/riders/checkDriver/type';
  static const createRideTripRequest = '/ride/trip';
  static const createRideTripRequestPremium = '/ride/trip/premium';
  static const getAddressFromLatAndLong = '/ride/trips/address/latAndLong';

  static const getMyPickMeTrips = '/ride/pick-me/trip/requests';
  static const getAllComeWithMeAds = '/ride/come-with-you/get-all';
  static const getAllPickMeAds = '/ride/pick-me/get-all';
  static const getRideThumbnails = '/ride/come-with-me/get-thumbnails';

  static String deletePickMeTrips(String id) {
    return '/ride/pick-me/Delete/$id';
  }

  static String requestPickMe(String id) {
    return '/ride/pick-me/request/$id';
  }

  static String favouriteAd(String id) {
    return '/ads-favorites/adToFavorites/$id';
  }

  static String removeFavouriteAd(String id) {
    return '/ads-favourites/reomveAdFromFavourites/$id';
  }

  static String requestComeWithMe(String id) {
    return '/ride/come-with-you/request/$id';
  }

  static String deleteComeWithYouTrips(String id) {
    return '/ride/come-with-you/Delete/$id';
  }

  static const getMyComeWithYouTrips = '/ride/come-with-you/trip/requests';
  static const getRiderNewTrips = '/ride/trips/rider/newTrip';

  // social

  static const createFacebookPost = '/facebook/post';
  static String createTwitterPost =
      '/twitter/post?subCategory=${Constants.twitterSubCategory}';

  // static const getFeedPosts = '/facebook/feed';
  static const activities = '/facebook/post/activities';
  static const feelings = '/facebook/post/feelings';
  static String getTwitterFeedPosts =
      '/twitter/feed?subCategory=${Constants.twitterSubCategory}';
  static const editProfile = '/users/profile-data';

  static String userPosts(UserPostsParams params) {
    return '/facebook/post/user/${params.userId}?limit=${params.limit}&page=${params.page}&type=1&subCategory=${Constants.facebookSubCategory}';
  }

  static String getFriendsFollowers(FriendsFollowersParams params) {
    return '/friends/friends-followers?search=${params.search}&limit=${params.limit}&page=${params.page}&subCategory=66b77e77bb35968b535dc944';
  }

  static String getPlaces(FriendsFollowersParams params) {
    return '/friends/get-place?place=${params.search}&subCategory=66b77e77bb35968b535dc944';
  }

  static String userSuggests(SuggestedFriendsParams params) {
    return '/users/suggest?limit=${params.limit}&page=${params.page}&subCategory=${Constants.facebookSubCategory}';
  }

  static String userTweets(GetUserTweetsParams params) {
    return '/twitter/post/user/${params.userId}?limit=10&page=${params.page}&type=1&subCategory=${Constants.twitterSubCategory}';
  }

  static String getFeedPosts(TwitterFeedParams params) {
    return '/facebook/feed?limit=${params.limit}&page=${params.page}&subCategory=${Constants.facebookSubCategory}';
  }

  static String getGlobalFeed(TwitterFeedParams params) {
    return '/facebook/feed/general?limit=${params.limit}&page=${params.page}&subCategory=${Constants.facebookSubCategory}';
  }

  static String getInstagramPosts(TwitterFeedParams params) {
    return '/instagram/feed?limit=${params.limit}&page=${params.page}&subCategory=${Constants.instagramSubCategory}';
  }

  static String getUserMedia(InstagramUserMediaParams params) {
    return '/instagram/posts/${params.userId}?limit=${params.limit}&page=${params.page}&subCategory=${Constants.instagramSubCategory}';
  }

  static String getInstagramGlobalPosts(TwitterFeedParams params) {
    return '/instagram/feed/general?limit=${params.limit}&page=${params.page}&subCategory=${Constants.instagramSubCategory}';
  }

  static String getReels(TwitterFeedParams params) {
    return '/reels/explore?limit=${params.limit}&page=${params.page}&subCategory=${Constants.reelsSubCategory}';
  }

  static String getUserReels(UserReelsParams params) {
    return '/reels/users/${params.userId}?limit=${params.limit}&page=${params.page}&subCategory=${Constants.reelsSubCategory}';
  }

  static String getSavedReels(TwitterFeedParams params) {
    return '/reels/saved?limit=${params.limit}&page=${params.page}&subCategory=${Constants.reelsSubCategory}';
  }

  static String followers(TwitterFeedParams params) {
    return '/follow/followers?search=${params.search}&limit=${params.limit}&page=${params.page}';
  }

  static String following(TwitterFeedParams params) {
    return '/follow/allFollowing?search=${params.search}&limit=${params.limit}&page=${params.page}';
  }


  static String createReel(CreateReelParams params) {
    return '/reels/views/${params.reelId}';
  }

  static String createAdvertisement(CreateAdvertisementParams params) {
    return '/advertisementCompany';
  }

  static String getAdvertisement(TwitterFeedParams params) {
    return '/advertisementCompany?limit=${params.limit}&page=${params.page}&subCategory=${Constants.facebookSubCategory}';
  }

  static String acceptTripRider(String id) {
    return '/ride/trips/accept/$id';
  }

  static String riderInStartLocation(String id) {
    return '/ride/trips/in-start-location/$id';
  }

  static String startTripRider(String id) {
    return '/ride/trips/start/$id';
  }

  static String partialPayment(String id) {
    return '/ride/payment/partial-payment/$id';
  }

  static String completedTripRider(String id) {
    return '/ride/trips/complete/$id';
  }

  static String cancelTripRider(String id) {
    return '/ride/trips/cancel-by-rider/$id';
  }

  static String cancelTripClient(String id) {
    return '/ride/trips/cancel-by-client/$id';
  }

  static String createOffer(String id) {
    return '/ride/offers/new/offer/$id';
  }

  static String acceptOffer(String id) {
    return '/ride/offers/accept/offer/$id';
  }

  static String rejectOffer(String id) {
    return '/ride/offers/decline/offer/$id';
  }

  static String getTripOffers(String id) {
    return '/ride/offers/trip/$id';
  }

  static String reactOnPost(String postId) {
    return '/facebook/post/react/$postId?subCategory=${Constants.facebookSubCategory}';
  }

  static String reactOnComment(String postId) {
    return '/facebook/comment/react/$postId?subCategory=${Constants.facebookSubCategory}';
  }

  static String reactOnTwitterPost(String postId) {
    return '/twitter/post/react/$postId?subCategory=${Constants.twitterSubCategory}';
  }

  static String reactOnTwitterComment(String commentId) {
    return '/twitter/comment/react/$commentId?subCategory=${Constants.twitterSubCategory}';
  }

  static String shareTwitterPost(String postId) {
    return '/twitter/post/share/$postId?subCategory=${Constants.twitterSubCategory}';
  }

  static String shareFacebookPost(SharePostParams params) {
    return '/facebook/post/share/${params.postId}?subCategory=${Constants.facebookSubCategory}';
  }

  static String commentOnPost(String postId) {
    return '/facebook/comment/create-comment/$postId?subCategory=${Constants.facebookSubCategory}';
  }

  static String getUserProfile(String userId) {
    return '/users/profile/$userId?subCategory=${Constants.facebookSubCategory}';
  }

  static String viewProfile(String userId) {
    return '/users/profile-view/$userId?subCategory=${Constants.facebookSubCategory}';
  }

  static String editComment(PostCommentParams params) {
    return '/facebook/comment/update-comment/${params.postId}?subCategory=${Constants.facebookSubCategory}';
  }

  static String acceptRejectFriendRequest(
      AcceptRejectFriendRequestParams params) {
    return '/friends/acceptOrRejectrequest/${params.userId}?subCategory=${Constants.facebookSubCategory}';
  }

  static String deleteFriend(String userId) {
    return '/friends/deleteFriend/$userId';
  }

  static String commentOnTwitterPost(String postId) {
    return '/twitter/comment/create-comment/$postId?subCategory=${Constants.twitterSubCategory}';
  }

  static String getPostComments(PostCommentsParams params) {
    return '/facebook/comment/get-post-comments/${params.postId}?limit=${params.limit}&page=${params.page}&subCategory=${Constants.facebookSubCategory}';
  }

  static String getPostCommentReplies(PostCommentsParams params) {
    return '/facebook/comment/get-comment-replies/${params.postId}?limit=${params.limit}&page=${params.page}&subCategory=${Constants.facebookSubCategory}';
  }

  static String getTwitterPostComments(PostCommentsParams params) {
    return '/twitter/comment/get-post-comments/${params.postId}?limit=${params.limit}&page=${params.page}&subCategory=${Constants.twitterSubCategory}';
  }

  static String getTwitterCommentReplies(PostCommentsParams params) {
    return '/twitter/comment/get-comment-replies/${params.postId}?limit=${params.limit}&page=${params.page}&subCategory=${Constants.twitterSubCategory}';
  }

  static String deletePost(String postId) {
    return '/facebook/post/$postId?subCategory=${Constants.facebookSubCategory}';
  }

  static String deleteComment(String commentId) {
    return '/facebook/comment/delete-comment/$commentId?subCategory=${Constants.facebookSubCategory}';
  }

  static String hidePost(String postId) {
    return '/facebook/post/hide/$postId?subCategory=${Constants.facebookSubCategory}';
  }

  static String deleteTwitterPost(String postId) {
    return '/twitter/post/$postId?subCategory=${Constants.twitterSubCategory}';
  }

  static String hideTwitterPost(String postId) {
    return '/twitter/post/hide/$postId?subCategory=${Constants.twitterSubCategory}';
  }

  static String deleteTwitterComment(String commentId) {
    return '/twitter/comment/delete-comment/$commentId?subCategory=${Constants.twitterSubCategory}';
  }

  static String editTwitterComment(String commentId) {
    return '/twitter/comment/update-comment/$commentId?subCategory=${Constants.twitterSubCategory}';
  }

  static String friendRequest(String userId) {
    return '/friends/sendFriendRequest/$userId?subCategory=${Constants.facebookSubCategory}';
  }

  static String removeFriendRequest(String userId) {
    return '/friends/deleteRequest/$userId?subCategory=${Constants.facebookSubCategory}';
  }

  static String blocUser(String userId) {
    return '/users/$userId/blocked?subCategory=${Constants.facebookSubCategory}';
  }

  static String followRequest(String userId) {
    return '/follow/make-follow/$userId?subCategory=${Constants.instagramSubCategory}';
  }

  static String deleteFollow(String userId) {
    return '/follow/unfollow/$userId?subCategory=${Constants.instagramSubCategory}';
  }

  static String greetMessage(String userId) {
    return '/users/greet/$userId?subCategory=${Constants.instagramSubCategory}';
  }

  static String removeSuggestUser(String userId) {
    return '/friends/remove-user-suggest/$userId?subCategory=${Constants.facebookSubCategory}';
  }

  // food
  static String subCategoryRestaurants(GetSubCategoryRestaurants params) {
    return '/restaurants/subcategory?${params.id != '' ? 'subCategoryId=${params.id}&' : ''}page=${params.page}&limit=${params.limit}${params.userId != '' ? "&userId=${params.userId}" : ""}';
  }

  static String getNumOfResturants = '/restaurants/num-of-restaurants';
  static String toggleRestaurantFavourite(String id) =>
      '/food/favorite-restaurant/$id';
  static String foodExpiredOrders(PaginationParams params) =>
      '/food/expired-orders?page=${params.page}&limit=${params.limit}';
  static String isResturant = '/restaurants/check-user-have-restaurant';
  static String createRestaurant = '/restaurants/create-restaurant';
  static String changeConnectivity = '/restaurants/modify-active';

  static String getMealsWithCountRestaurant({PostCommentsParams? params}) =>
      '/restaurants/subcategories-count-restaurant?page=${params?.page}&limit=${params?.limit}${params?.userId != null ? "&userId=${params?.userId}" : ""}';

  static String getAllRestaurantWithMenu({PostCommentsParams? params}) =>
      '/restaurants/all-restaurants?page=${params?.page}&limit=${params?.limit}${params?.userId != null ? "&userId=${params?.userId}" : ""}';

  static String searchRestaurants({PostCommentsParams? params}) =>
      '/restaurants/search-restaurants${params?.page != null ? "?page=${params?.page ?? "1"}&limit=${params?.limit ?? "20"}" : ""}';

//?page=1&userId=
  static String restaurantDetails(String id) {
    return '/restaurants/$id';
  }

  static String restaurantMeals(GetMealsParams params) {
    return '/food/food-items/${params.restaurantId}?page=${params.page}&limit=${params.limit}';
  }

  static String getSubcategoryAdProps(String id) {
    return '/ads/PropsByMainCategoryId/$id';
  }

  static const createAd = '/ads/create-ads';

  static filterAd(FilterModel filter) =>
      '/ads/filter-ads/${filter.subCategoryId}?government=${filter.governorateId}&city=${filter.cityId}&limit=${filter.limit}&page=${filter.page}&type=${filter.filter}';
  static deleteFood(String id) => '/food/delete-food-item/$id';
  static const addFood = '/food/add-food';
  static const deleteCart = '/food/deleteCart';
  static const deleteFoodFromCart = '/food/deleteFromCart';
  static const changeFoodQuantity = '/food/change-quantity';
  static const myAds = '/ads/allMyAds?limit=100';
  static const makeRequest = '/ads-requests/makeAdRequest';
  static const makePremiumRequest = '/ads-requests/makeAdRequest-Premium';
  static const favouriteAds = '/ads-favorites/allFavoriteAds';
  static const favouriteSubCategories = '/favorite-sub-category';

  static String deleteFavouriteAds(String id) {
    return '/ads-favourites/reomveAdFromFavourites/$id';
  }

  static String deleteAd(String id) {
    return '/ads/deleteAd/$id';
  }

  static String subCategoryAds(GetAdsParams params) {
    return '/ads/subCategoryAds/${params.subCategoryId}?filter=${params.filter}&page=${params.page}&limit=${params.limit}${(params.userId != null && params.userId != "") ? "&userId=${params.userId}" : ""}';
  }

  static String createAuction(String id) {
    return '/auction/$id';
  }

  static const auctionsList = '/auction';
  static const myAuctions = '/auction/my-auction';

  static String auctionDetails(String id) {
    return '/auction/$id';
  }

  static String getAuctionRequests(String id) {
    return '/auction/all-auction-request/$id';
  }

  static String sendAuctionRequest(String id) {
    return '/auction/add-auction-request/$id';
  }

  static String followUserAuctions(String userId) {
    return '/auction/follow-user-auction/$userId';
  }

  static String getAllAuctionRequests(String id) {
    return '/auction/all-auction-request/$id';
  }

  static String endAuction(String id) {
    return '/auction/end-auction/$id';
  }

  static String adDetails(GetAdDetailsParams params) {
    return '/ads/getAd/${params.adId}${params.userId.isNotEmpty ? "?userId=${params.userId}" : ""}';
  }

  static String adRequests(String id) {
    return '/ads-requests/getAdRequest/$id/search';
  }

  // /installment
  static String installment = '/installment/all-generale';

  // static String installment = '/installment';
  static String createInstallment(String id) {
    return '/installment/$id';
  }

  static String installmentDetails(String id) {
    return '/installment/$id';
  }

  static String addInstallmentRequest(String id) {
    return '/installment/add-installments-request/$id';
  }

  static String addToCart = '/food/addToCart';
  static String getCart = '/food/getCart';
  static String deleteFromCart = '/food/deleteFromCart';
  static String placeOrder = '/food/make-order';

  // contact us
  static const helpMessages = '/help';
  static const contactUs = '/email/contact-us';
  static String mediaUrl = '/media/signed-url';

  static String confirmUpload(String mediaId) {
    return '/media/confirm/$mediaId';
  }

  // chat_room
  static String getChats = '/chat/get-chats';

  static String getChatMessages(String chatId) {
    return '/chat/get-chat/$chatId';
  }

  static String getChatDetails(String chatId) {
    return '/chat/get-chat-details/$chatId';
  }

  static String createNormalChat(
      {required String categoryId, required String otherUserId}) {
    return '/chat/start-chat/$otherUserId?categoryId=$categoryId';
  }

  static String createAnonymousChat(String otherUserId) =>
      '/chat/start-anonymous-chat/$otherUserId';

  //club voice
  static String allClubVoiceRooms = '/clubvoice';
  static String createClubVoiceRoom = '/clubvoice';

  static String joinVoiceRoom(String id) => '/clubvoice/join/$id';

  static String endVoiceRoom(String id) => '/clubvoice/$id';

  static String leaveVoiceRoom(String id) => '/clubvoice/leave/$id';

  static String searchVoiceRooms(String subject) =>
      '/clubvoice?search=$subject';

  //meeting
  static String createMeeting = '/room-id';

  static String joinMeeting(String id) => '/room-id/join/$id';

  static String endMeeting(String id) => '/room-id/finish/$id';

  static String getScheduledMeetings(String id) => '/room-id/$id';

  //lives
  static String allLiveTopics = '/stream-topic';
  static String createLive = '/stream';
  static String editGoal(String id) => '/stream/goal/$id';

  static String endStream(String id) => '/stream/$id';
  static String allLives = '/stream/explore';

//secrets
  static String getSecrets = '/app-manager-dashboard/apiKeys';
  static String deleteChatMessage = '/chat/message';

  static String changeChatMuteState(String chatId) {
    return '/chat/mute-chat/$chatId';
  }

  static String deleteChat(String chatId) {
    return '/chat/delete-chat/$chatId';
  }

  static String pinAndUnPinChat(String chatId) {
    return '/chat/pin-chat/$chatId';
  }

  static String changeChatToArchiveOrNormal(String chatId) {
    return '/chat/archive-chat/$chatId';
  }

  static String buttonAvailable = '/global/click';

  static String getSubscriptionPlans(String subcategoryId) =>
      '/subscription/plans/$subcategoryId';

  static String checkUserSubscription(String id) {
    return '/subscription/subcategory/$id';
  }

  static String subscribe = '/subscription/subscribe';

  static String getActiveSubscriptionAmounts = '/payment-amount/active';

  static String lockChat(String chatId) {
    return '/chat/lock-chat/$chatId';
  }

  static String unLockChat(String chatId) {
    return '/chat/unlock-chat/$chatId';
  }

  static String updateUnLockChatPassword() {
    return '/chat/update-lock-chat';
  }

  static String getOneTimeViewMessage() {
    return '/chat/message/one-time-message';
  }

  static String clearChat(String chatId) {
    return '/chat/clear-chat/$chatId';
  }

  static String pinMessage(String chatId) {
    return '/chat/pin-chat-message/$chatId';
  }

  static String unPinMessage(String chatId) {
    return '/chat/unpin-chat-message/$chatId';
  }

  static String getChatGroups = '/chat/group/get-groups/';

  static String seenHistoryEndpoint(String chatId) {
    return '/chat/last-seen-logs/$chatId';
  }

  // gecoding google api url
  static String geocodingUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';

  // trip join
  static String tripJoinExpectedPrice =
      "/ride/come-with-you/trip/expectedPrice";
  static String getCarBrand = "/ride/riders/brands";
  static String getCarModelByBrand = "/ride/riders/models";
  static String getCarYearType = "/ride/riders/car-years-and-types";
  static String publishTripJoin = "/ride/come-with-you";

  static String getAllTripJoin = '/ride/come-with-you/get-all';
  static String getAllPickMe = '/ride/pick-me/get-all';
  static String addNewPickMeTrip =
      '/ride/pick-me?subCategory=62ea008d69ea29c91dfc3908';
  static String makeTripJoinRequest(
      String addId, String subCategory, String url) {
    return '$url$addId?subCategory=$subCategory';

    // return '/ride/come-with-you/request/$addId?subCategory=62ea00e269ea29c91dfc390c';
  }

  static String getAllMyTripJoin = '/ride/come-with-you/my';
  static String getAllMyPickMeTrips = '/ride/pick-me/my';
  static String getRequestPickMeTrips = '/ride/pick-me/trip/requests';

  static String deleteTrip(String url, String id) => '$url/$id';

  static String getRequest(String id) =>
      '/ride/come-with-you/trip/requests//$id';
  static String carpoolRoutePrice = '/carpool/price';
  static String getAcceptedTrips = '/carpool/driver/trip';

  static String verifyUserOtp(String tripId) =>
      '/carpool/verifyPassengersOtp/$tripId';

  static String completeUserSeat = '/carpool/completeSeat';

  static String acceptTripForDriver(String id) =>
      '/carpool/driverAcceptCarpool/$id';
  static String getLatAndLongFromAddress = '/ride/trips/address/latAndLong';

  // Chance
  static String chance = '/chance-ads/my-ads';
  static String addChance = '/chance-ads';
  static String subCatChance = '/categories/main/has-auction?page=1&limit=100';

  static String rateChance(String id) =>
      '/chance-ads/contribution-percentage/$id';

  static String mainCatChance(MainCategoryChanceParams params) {
    return '/categories/main/has-auction?page=${params.paginationParams.page}&limit=${params.paginationParams.limit}';
  }

  static String joinTripCarPool = '/carpool/joinCompleteBus';
  static String createCarPool = '/carpool/create';
}
