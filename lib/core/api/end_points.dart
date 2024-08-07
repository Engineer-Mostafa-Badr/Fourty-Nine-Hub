import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
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
  static const getWheel = '/wheels/random';
  static const spinWheel = '/wheels/spin/';
  static const wheelWallet = '/wheel/wallets/my/wallet';
  static const sendForgetPasswordOTP = '/auth/forgot-password';
  static const verifyForgetPasswordOTP = '/auth/verify/otp';
  static const createNewForgetPassword = '/auth/reset-password';
  static const report = '/report';
  static const documentRequest = '/twitter/document-request';
  // ride

  // health
  static String getCities({required String governorateId}) =>
      '/health/cities/$governorateId';
  static const getGovernorates = '/health/governorate';
  static const createDoctor = '/health/doctor';
  static const doctorSearch = '/health/doctor-search';
  static const bookEmergency = '/health/book-emergency';
  static String bookRegularAppointment(String appointmentId) =>
      '/health/book-appointment/$appointmentId';
  static String toggleFavoriteSubcategory(String subCategoryId) =>
      '/favorite-sub-category/$subCategoryId';
  static String bookPremiumAppointment(String appointmentId) =>
      '/health/book-appointment-premium/$appointmentId';
  static String getDoctorReviewsForUsers(String doctorId) =>
      '/health/doctor/rate/$doctorId';
  static String getDoctorDetails(String doctorId) => '/health/doctor/$doctorId';
  static const getHealthSubcategories = '/health/subCategories-health-with-ads';
  static const getMedicalServices =
      '/health/subCategories-medicalServices-with-ads';
  static const String getUpcomingUserAppointments = '/health/book-appointment';
  static const String getHealthRequestsHistory =
      '/health/history-patient-booking';
  static const remainingDaysOfDoctorPracticing =
      '/health/dashboard/remaining-days-of-doctor-id';
  static const remainingDaysOfDoctorID =
      '/health/dashboard/remaining-days-of-doctor-practicing-id';
  static const remainingDaysOfDoctorSubscription =
      '/health/dashboard/remaining-days-of-doctor-subscription';
  static const getDoctorAppointmentsByDay = '/health/doctor/booking-day';
  static const getDoctorUnhandledAppointments = '/health/book-requests';
  static const isDoctor = '/health/check-doctor-or-not';
  static const getDoctorTotalEarnedMoney =
      '/health/dashboard/total-earned-money';
  static String doctorAcceptAppointment(String appointmentId) =>
      '/health/book-appointment/approve/$appointmentId';
  static String doctorRejectAppointment(String appointmentId) =>
      '/health/book-appointment/reject/$appointmentId';

  // reels
  static const getExploreReels = '/reels/explore';

  // ride request
  static const expectedPrice = '/ride/trips/expected/price';
  static const carTypes = '/cars';
  static String subCategories({required String mainCategoryId}) {
    return '/categories/subcategories/$mainCategoryId?page=1&limit=30';
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
  static const getFeedPosts = '/facebook/feed';
  static const getTwitterFeedPosts = '/twitter/feed';
  static String userPosts(String userId) {
    return '/facebook/post/user/$userId?limit=20&page=1&type=1';
  }

  static String userSuggests(SuggestedFriendsParams params) {
    return '/users/suggest?limit=${params.limit}&page=${params.page}';
  }

  static String userTweets(GetUserTweetsParams params) {
    return '/twitter/post/user/${params.userId}?limit=10&page=${params.page}&type=1';
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
    return '/facebook/post/react/$postId';
  }

  static String reactOnTwitterPost(String postId) {
    return '/twitter/post/react/$postId';
  }

  static String reactOnTwitterComment(String commentId) {
    return '/twitter/comment/react/$commentId';
  }

  static String shareTwitterPost(String postId) {
    return '/twitter/post/share/$postId';
  }

  static String commentOnPost(String postId) {
    return '/facebook/comment/create-comment/$postId';
  }

  static String commentOnTwitterPost(String postId) {
    return '/twitter/comment/create-comment/$postId';
  }

  static String getPostComments(String postId) {
    return '/facebook/comment/get-post-comments/$postId';
  }

  static String getTwitterPostComments(String postId) {
    return '/twitter/comment/get-post-comments/$postId';
  }

  static String getTwitterCommentReplies(String commentId) {
    return '/twitter/comment/get-comment-replies/$commentId';
  }

  static String deletePost(String postId) {
    return '/facebook/post/$postId';
  }

  static String hidePost(String postId) {
    return '/facebook/post/hide/$postId';
  }

  static String friendRequest(String userId) {
    return '/friends/sendFriendRequest/$userId';
  }

  static String followRequest(String userId) {
    return '/follow/make-follow/$userId';
  }

  static String greetMessage(String userId) {
    return '/users/greet/$userId';
  }

  static String removeSuggestUser(String userId) {
    return '/friends/remove-user-suggest/$userId';
  }

  // food
  static String subCategoryRestaurants(String id) {
    return '/restaurants/subcategory/$id';
  }

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

  static String changeChatMuteState(String chatId) {
    return '/chat/mute-chat/$chatId';
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
}
