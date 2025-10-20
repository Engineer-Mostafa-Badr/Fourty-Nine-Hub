import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../stateless/labels/label.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String? label;
  final double? labelSize;
  final String? subTitle;
  final Color? backColor;
  final Color? iconColor;
  final Color? textColor;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool enableCustomAppBar;

  const BackAppBar({
    super.key,
    this.automaticallyImplyLeading = true,
    this.label,
    this.backColor,
    this.iconColor,
    this.actions,
    this.centerTitle = false,
    this.leading,
    this.textColor,
    this.enableCustomAppBar = false,
    this.subTitle, this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backColor ?? AppColors.PRIMARY_COLOR,
      surfaceTintColor: backColor ?? AppColors.PRIMARY_COLOR,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          IconButton(
            onPressed: () async {
              ManageVibration.vibrate();
              await _handleBackNavigation(context);
            },
            visualDensity: VisualDensity(horizontal: -4),
            icon: Icon(
              Icons.arrow_back,
              size: 40.w,
              color: AppColors.whiteColor,
            ),
          ),
      title: label != null
          ? Label(
              text: label ?? '',
              maxLines: 2,
              style: Styles.headerText(fontSize: labelSize??32).copyWith(
                  color: AppColors.whiteColor))
          : null,
      actions: actions,
      bottom: subTitle?.isEmpty ?? true ? null : PreferredSize(
        preferredSize: const Size.fromHeight(16.0), // here the desired height
        child: Row(
          children: [
            const Sizer(width: 100,),
            Label(
                text: subTitle ?? '',
                style: Styles.mediumText().copyWith(
                    color: !enableCustomAppBar ? Colors.white : textColor)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBackNavigation(BuildContext context) async {
    // Get the current route path to check if we're on login page
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    
    // Check if we're on the login page - this indicates user was redirected here due to session expiry
    if (currentLocation.contains('/login') || currentLocation.contains(Routes.LOGIN)) {
      // User is on login page, likely due to expired refresh token
      // Apply same logout logic as when refresh token fails
      await _performLogoutCleanup();
    }
    
    context.pop();
  }

  Future<void> _performLogoutCleanup() async {
    // Clear all tokens and auth data (same as UserCubit.logout logic)
    await CacheManager.deleteAllTokens();
    
    // Clear login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("ISLOGIN", false);
    
    // Disconnect WebSocket
    SharedWebSocket.disconnect();
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
