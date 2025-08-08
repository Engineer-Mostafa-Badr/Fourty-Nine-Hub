import '../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../service_locator/service_locator.dart';

class GuestDataManager {
  static const String _cartKey = 'guest_cart';
  static const String _favoritesKey = 'guest_favorites';
  static const String _preferencesKey = 'guest_preferences';

  // جلب السلة للـ Guest
  static Future<List<Map<String, dynamic>>> getGuestCart() async {
    final userCubit = serviceLocator<UserCubit>();
    final cart = await userCubit.getGuestData<List<dynamic>>(_cartKey);
    return cart?.cast<Map<String, dynamic>>() ?? [];
  }

  // جلب المفضلة للـ Guest
  static Future<List<String>> getGuestFavorites() async {
    final userCubit = serviceLocator<UserCubit>();
    final favorites =
        await userCubit.getGuestData<List<dynamic>>(_favoritesKey);
    return favorites?.cast<String>() ?? [];
  }

  // جلب التفضيلات
  static Future<Map<String, dynamic>> getGuestPreferences() async {
    final userCubit = serviceLocator<UserCubit>();
    final prefs =
        await userCubit.getGuestData<Map<String, dynamic>>(_preferencesKey);
    return prefs ?? {};
  }

  // حفظ السلة للـ Guest
  static Future<void> saveGuestCart(List<Map<String, dynamic>> cart) async {
    final userCubit = serviceLocator<UserCubit>();
    await userCubit.saveGuestData(_cartKey, cart);
  }

  // حفظ المفضلة للـ Guest (محدود)
  static Future<void> saveGuestFavorites(List<String> favorites) async {
    final userCubit = serviceLocator<UserCubit>();
    if (favorites.length <= 5) {
      // محدود بـ 5 عناصر للـ Guest
      await userCubit.saveGuestData(_favoritesKey, favorites);
    }
  }

  // حفظ التفضيلات
  static Future<void> saveGuestPreferences(Map<String, dynamic> prefs) async {
    final userCubit = serviceLocator<UserCubit>();
    await userCubit.saveGuestData(_preferencesKey, prefs);
  }
}
