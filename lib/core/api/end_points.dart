class EndPoints {
  static const developmentBaseUrl = 'https://www.49dev.com';
  static const productionBaseUrl = 'https://www.49dev.com';
  static const storageBaseUrl = 'https://49-space.fra1.digitaloceanspaces.com/';

  static const login = '/auth/login';
  static const getProfile = '/users/profiles';
  static const register = '/auth/register';
  static const verifyOTP = '/auth/verify/email';
  static const getWelcomeGift = '/auth/welcome-gift';
  static const refreshToken = '/auth/refresh/token';
  static const getParentMainCategories = '/categories/get-parent-category';
  static const getMainCategories = '/categories/main';

  // ride request
  static const expectedPrice = '/services/ride/get-expected-price';
}
