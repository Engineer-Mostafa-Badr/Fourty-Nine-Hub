import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_user_posts_usecase.dart';

class EndPoints {
  static const pageSize = 20;
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
  static const getParentMainCategories = '/category/parent';
  static const getMainCategories = '/category/parent/get-all-main';
  static String getBannerByID({required String id}) => '/categories/main/$id';
  static const getMainCategoriesWithoutSubcategories = '/categories/main';
  static String getMainCategoryDetails(String id) => '/categories/main/$id';
  static String addMainCategoryToFavorite(String id) => '/favorite-category/$id';
  static String deleteMainCategoryFromFavorite(String id) => '/favorite-category/$id';

  static const getWheel = '/wheels/random';
  static const spinWheel = '/wheels/spin/';
  static const wheelWallet = '/wheel/wallets/my/wallet';
  static const sendForgetPasswordOTP = '/auth/forgot-password';
  static const verifyForgetPasswordOTP = '/auth/verify/otp';
  static const createNewForgetPassword = '/auth/reset-password';
  // static const report = '/report?subCategory=66a3583454e6e337915514db';
  static String report({required String subCategoryId}) =>
      '/report?subCategory=$subCategoryId';
  static const documentRequest =
      '/twitter/document-request?subCategory=66a3583454e6e337915514db';

  // ride
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
  static String getCities({required String governorateId}) => '/health/cities/$governorateId';
  static const getGovernorates = '/health/governorate';
  static const createDoctor = '/health/doctor';
  static const doctorSearch = '/health/doctor-search';
  static const bookEmergency = '/health/book-emergency';
  static String bookRegularAppointment(String appointmentId) => '/health/book-appointment/$appointmentId';
  static String toggleFavoriteSubcategory(String subCategoryId) => '/favorite-sub-category/$subCategoryId';
  static String bookPremiumAppointment(String appointmentId) => '/health/book-appointment-premium/$appointmentId';
  static String getDoctorReviewsForUsers(String doctorId) => '/health/doctor/rate/$doctorId';
  static String getDoctorDetails(String doctorId) => '/health/doctor/$doctorId?subCategory=62c8bae08e28a58a3edf5867';
  static const getHealthSubcategories = '/health/subCategories-health-with-ads';
  static const getMedicalServices = '/health/subCategories-medicalServices-with-ads';
  static const String getUpcomingUserAppointments = '/health/book-appointment';
  static const String getHealthRequestsHistory = '/health/history-patient-booking';
  static const remainingDaysOfDoctorPracticing = '/health/dashboard/remaining-days-of-doctor-id';
  static const remainingDaysOfDoctorID = '/health/dashboard/remaining-days-of-doctor-practicing-id';
  static const remainingDaysOfDoctorSubscription = '/health/dashboard/remaining-days-of-doctor-subscription';
  static const getDoctorAppointmentsByDay = '/health/doctor/booking-day';
  static const getDoctorUnhandledAppointments = '/health/book-requests';
  static const isDoctor = '/health/check-doctor-or-not';
  static const getDoctorTotalEarnedMoney = '/health/dashboard/total-earned-money';
  static String doctorAcceptAppointment(String appointmentId) => '/health/book-appointment/approve/$appointmentId';
  static String doctorRejectAppointment(String appointmentId) => '/health/book-appointment/reject/$appointmentId';
  static const getAllDoctorReservations = '/health/dashboard/number-of-reservations';
  static const getDoctorProfile = '/health/doctor-profile';
  static const updateDoctorProfilePhoto = '/health/doctor/picture';
  static const updateDoctorPractcing = '/health/doctor-upload-license-practicing';
  static const updateDoctorID = '/health/doctor-upload-license-id';
  static String deleteDoctor(String doctorId) => '/health/doctor/$doctorId';

  // reels
  static const getExploreReels = '/reels/explore';

  // ride request
  static const expectedPrice = '/ride/trips/expected/price';
  static const carTypes = '/cars';
  static String subCategories({required String mainCategoryId}) {
    return '/categories/subcategories/$mainCategoryId';
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
  static const createTwitterPost = '/twitter/post';
  // static const getFeedPosts = '/facebook/feed';
  static const activities = '/facebook/post/activities';
  static const feelings = '/facebook/post/feelings';
  static const getTwitterFeedPosts = '/twitter/feed';
  static String userPosts(UserPostsParams params) {
    return '/facebook/post/user/${params.userId}?limit=${params.limit}&page=${params.page}&type=1&subCategory=66b77e77bb35968b535dc944';
  }

  static String userSuggests(SuggestedFriendsParams params) {
    return '/users/suggest?limit=${params.limit}&page=${params.page}&subCategory=66b77e77bb35968b535dc944';
  }

  static String userTweets(GetUserTweetsParams params) {
    return '/twitter/post/user/${params.userId}?limit=10&page=${params.page}&type=1&subCategory=66a3583454e6e337915514db';
  }

  static String getFeedPosts(TwitterFeedParams params) {
    return '/facebook/feed?limit=${params.limit}&page=${params.page}&subCategory=66b77e77bb35968b535dc944';
  }

  static String getInstagramPosts(TwitterFeedParams params) {
    return '/instagram/feed?limit=${params.limit}&page=${params.page}';
  }

  static String getReels(TwitterFeedParams params) {
    return '/reels/explore?limit=${params.limit}&page=${params.page}';
  }

  static String getUserReels(UserReelsParams params) {
    return '/reels/users/${params.userId}?limit=${params.limit}&page=${params.page}';
  }

  static String getAdvertisement(TwitterFeedParams params) {
    return '/advertisementCompany?limit=${params.limit}&page=${params.page}&subCategory=66b77e77bb35968b535dc944';
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
    return '/facebook/post/react/$postId?subCategory=66b77e77bb35968b535dc944';
  }

  static String reactOnComment(String postId) {
    return '/facebook/comment/react/$postId';
  }

  static String reactOnTwitterPost(String postId) {
    return '/twitter/post/react/$postId?subCategory=66a3583454e6e337915514db';
  }

  static String reactOnTwitterComment(String commentId) {
    return '/twitter/comment/react/$commentId?subCategory=66a3583454e6e337915514db';
  }

  static String shareTwitterPost(String postId) {
    return '/twitter/post/share/$postId?subCategory=66a3583454e6e337915514db';
  }

  static String shareFacebookPost(String postId) {
    return '/facebook/post/share/$postId?subCategory=66b77e77bb35968b535dc944';
  }

  static String commentOnPost(String postId) {
    return '/facebook/comment/create-comment/$postId?subCategory=66b77e77bb35968b535dc944';
  }

  static String getUserProfile(String userId) {
    return '/users/profile/$userId?subCategory=66b77e77bb35968b535dc944';
  }

  static String commentOnTwitterPost(String postId) {
    return '/twitter/comment/create-comment/$postId?subCategory=66b77e77bb35968b535dc944';
  }

  static String getPostComments(PostCommentsParams params) {
    return '/facebook/comment/get-post-comments/${params.postId}?limit=${params.limit}&page=${params.page}&subCategory=66b77e77bb35968b535dc944';
  }

  static String getPostCommentReplies(PostCommentsParams params) {
    return '/facebook/comment/get-comment-replies/${params.postId}?limit=${params.limit}&page=${params.page}&subCategory=66b77e77bb35968b535dc944';
  }

  static String getTwitterPostComments(PostCommentsParams params) {
    return '/twitter/comment/get-post-comments/${params.postId}?limit=${params.limit}&page=${params.page}&subCategory=66a3583454e6e337915514db';
  }

  static String getTwitterCommentReplies(PostCommentsParams params) {
    return '/twitter/comment/get-comment-replies/${params.postId}?limit=${params.limit}&page=${params.page}&subCategory=66a3583454e6e337915514db';
  }

  static String deletePost(String postId) {
    return '/facebook/post/$postId?subCategory=66b77e77bb35968b535dc944';
  }

  static String deleteComment(String commentId) {
    return '/facebook/comment/delete-comment/$commentId?subCategory=66b77e77bb35968b535dc944';
  }

  static String hidePost(String postId) {
    return '/facebook/post/hide/$postId?subCategory=66b77e77bb35968b535dc944';
  }

  static String deleteTwitterPost(String postId) {
    return '/twitter/post/$postId?subCategory=66a3583454e6e337915514db';
  }

  static String hideTwitterPost(String postId) {
    return '/twitter/post/hide/$postId?subCategory=66a3583454e6e337915514db';
  }

  static String friendRequest(String userId) {
    return '/friends/sendFriendRequest/$userId?subCategory=66b77e77bb35968b535dc944';
  }

  static String removeFriendRequest(String userId) {
    return '/friends/deleteRequest/$userId?subCategory=66b77e77bb35968b535dc944';
  }

  static String blocUser(String userId) {
    return '/users/$userId/blocked';
  }

  static String followRequest(String userId) {
    return '/follow/make-follow/$userId?subCategory=66b77e77bb35968b535dc944';
  }

  static String removeFollow(String userId) {
    return '/follow/unFollow/$userId?subCategory=66b77e77bb35968b535dc944';
  }

  static String greetMessage(String userId) {
    return '/users/greet/$userId?subCategory=66b77e77bb35968b535dc944';
  }

  static String removeSuggestUser(String userId) {
    return '/friends/remove-user-suggest/$userId?subCategory=66b77e77bb35968b535dc944';
  }

  // food
  static String subCategoryRestaurants(String id) {
    return '/restaurants/subcategory/$id';
  }

  static String getNumOfResturants = '/restaurants/num-of-restaurants';
  static String isResturant = '/restaurants/check-user-have-restaurant';
  static String createRestaurant = '/restaurants/create-restaurant';
  static String getMealsWithCountRestaurant({PostCommentsParams? params}) =>
      '/restaurants/subcategories-count-restaurant${params?.page != null || params?.userId != null ? "?page=${params?.page}&userId=${params?.userId}" : ""}';
  static String getAllRestaurantWithMenu({PostCommentsParams? params}) =>
      '/restaurants/subcategories-count-restaurant${params?.page != null  ? "?page=${params?.page}" : ""}';
//?page=1&userId=
  static String restaurantDetails(String id) {
    return '/restaurants/$id';
  }

  static String restaurantMeals(String id) {
    return '/food/food-items/$id';
  }

  static String getSubcategoryAdProps(String id) {
    return '/ads/PropsBySubCategoryId/$id';
  }

  static const createAd = '/ads/create-ads';
  static const myAds = '/ads/allMyAds';
  static const makeRequest = '/ads-requests/makeAdRequest';
  static const favouriteAds = '/ads-favourites/allFavouriteAds';
  static String deleteAd(String id) {
    return '/ads/deleteAd/$id';
  }

  static String subCategoryAds(String id) {
    return '/ads/subCategoryAds/$id';
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

  static String adDetails(String id) {
    return '/ads/getAd/$id';
  }

  // /installment
  static String installment = '/installment';
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
  static String mediaUrl = '/media/signed-url';
  static String confirmUpload(String mediaId) {
    return '/media/confirm/$mediaId';
  }

  // chat_room
  static String getChats = '/chat/get-chats';
  static String getChatMessages(String chatId) {
    return '/chat/get-chat/$chatId';
  }

  //club voice
  static String allClubVoiceRooms = '/clubvoice';
  static String createClubVoiceRoom = '/clubvoice';
  static String joinVoiceRoom(String id) => '/clubvoice/join/$id';
  static String endVoiceRoom(String id) => '/clubvoice/$id';
  static String leaveVoiceRoom(String id) => '/clubvoice/leave/$id';
  static String searchVoiceRooms(String subject) => '/clubvoice?search=$subject';

  //meeting
  static String createMeeting = '/room-id';
  static String joinMeeting(String id) => '/room-id/join/$id';
  static String endMeeting(String id) => '/room-id/finish/$id';
  static String deleteChatMessage = '/chat/message';

  static String changeChatMuteState(String chatId) {
    return '/chat/mute-chat/$chatId';
  }

  static String changeChatToArchiveOrNormal(String chatId) {
    return '/chat/archive-chat/$chatId';
  }

  static String buttonAvailable = '/global/click';
  static String getSubscriptionPlans(String subcategoryId) => '/subscription/plans/$subcategoryId';
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

  static String getChatGroups = '/chat/group/get-groups/';
  static String seenHistoryEndpoint(String chatId) {
    return '/chat/last-seen-logs/$chatId';
  }

  static String geocodingUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';

}
