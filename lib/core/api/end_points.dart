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

  // reels
  static const getExploreReels = '/reels/explore';

  // ride request
  static const expectedPrice = '/ride/trips/expected/price';
  static const carTypes = '/cars';
  static String subCategories({required String mainCategoryId}) {
    return '/categories/subcategories/$mainCategoryId';
  }

  static const riderInfoRegister = '/ride/riders/register';
}
