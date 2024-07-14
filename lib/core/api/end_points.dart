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
  static const getParentMainCategories = '/categories/get-parent-category';
  static const getMainCategories = '/categories/main';
  static const getWheel = '/wheels/random';
  static const spinWheel = '/wheels/spin/';
  static const wheelWallet = '/wheel/wallets/my/wallet';

  // ride

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
  static const sendRideRequest = '/ride/trips/new';
  static const getMyPickMeTrips = '/ride/pick-me/trip/requests';
  static String deletePickMeTrips(String id) {
    return '/ride/pick-me/Delete/$id';
  }

  static String deleteComeWithYouTrips(String id) {
    return '/ride/come-with-you/Delete/$id';
  }

  static const getMyComeWithYouTrips = '/ride/come-with-you/trip/requests';
  // social

  static const createFacebookPost = '/facebook/post';
  static const getFeedPosts = '/facebook/feed';
  static String userPosts(String userId) {
    return '/facebook/post/user/$userId?limit=20&page=1&type=1';
  }

  static String reactOnPost(String postId) {
    return '/facebook/post/react/$postId';
  }

  static String commentOnPost(String postId) {
    return '/facebook/comment/create-comment/$postId';
  }

  static String getPostComments(String postId) {
    return '/facebook/comment/get-post-comments/$postId';
  }

  static String deletePost(String postId) {
    return '/facebook/post/$postId';
  }

  static String hidePost(String postId) {
    return '/facebook/post/hide/$postId';
  }

  // contact us
  static const helpMessages = '/help';
}
