import 'package:flutter/material.dart';
import '../features/authentication/domain/entities/user_entity.dart';
import 'manage_vibration.dart';

class FeatureAccessControl {
  static bool canAccessFeature(String featureName, UserEntity? user) {
    if (user == null) return false;

    if (user.isGuest) {
      switch (featureName) {
        case 'browse':
        case 'search':
        case 'cart':
          return true;
        case 'favorites':
        case 'orders':
        case 'wallet':
        case 'rewards':
        case 'profile':
          return false;
        default:
          return false;
      }
    }

    return true; // authenticated users can access everything
  }

  static void showFeatureRestrictionDialog(
      BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ميزة غير متاحة'),
        content: Text(
            'هذه الميزة متاحة فقط للمستخدمين المسجلين. يرجى إنشاء حساب أو تسجيل الدخول.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
          ElevatedButton(
            onPressed: () {
      ManageVibration.vibrate();
              Navigator.pop(context);
              // Show upgrade dialog or navigate to login
            },
            child: Text('إنشاء حساب'),
          ),
        ],
      ),
    );
  }
}


