import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class RegistrationBanner extends StatelessWidget {
  const RegistrationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap:(){
        if (context.read<UserCubit>().isLoggedIn) {
          context.push(Routes.CREATEDOCTOR);
        } else {
          return pleaseLoginDialog(context);
          // context.push(Routes.REGISTER);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: 64.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.c0B1035,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 4),
              blurRadius: 6,
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              AppColors.PRIMARY_COLOR,
              Color(0xFF3A4CD1),
              AppColors.PRIMARY_COLOR
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              context.isArabic
                  ? 'ساعد العملاء بالضغط علي تسجيل '
                  : 'Serve clients by click Register',
              style: Styles.mediumText(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
